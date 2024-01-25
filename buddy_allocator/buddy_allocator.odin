package buddy_allocator

import "core:fmt"
import "core:mem"
import "core:math"


Preambule :: struct {
   free:  bool,
   depth: i32,
};


Node :: struct {
   using preambule: Preambule,
   next: ^Node,
   prev: ^Node,
};


BuddyAllocator :: struct {
   freelist: []^Node,
   data:     []u8,
   maxdepth: i32,
   max, min: int,
};


data_size :: proc(min, max: int) -> int
{
   min := min; max := max;
   if !validate_input(min, max) do return 0;
   if min > max do swap(&min, &max);
   
   depth := get_power_of_two(max / min) + 1;
   // maximal block size plus space for freelist head
   result := max + size_of(^Node) * depth;

   return result;
}


init :: proc(using self: ^BuddyAllocator, udata: []u8, minblock, maxblock: int) -> bool
{
   min = minblock; max = maxblock;
   if min > max do swap(&min, &max);

   validate_input(min, max) or_return;
   if len(udata) != data_size(min, max) do return false;
   maxdepth = i32(get_power_of_two(max / min) + 1);

   // since transmute doesnt change len(cus why would it) we have to adjust for it when we slice
   freelist = transmute([]^Node) udata[max:max+int(maxdepth)]; 
   mem.set(raw_data(freelist), 0, len(freelist)*size_of(^Node));
   data = udata[:max];

   // make free node for initial block
   first_node := (^Node)(raw_data(data));
   first_node^ = { { true, 0 }, nil, nil };
   freelist[0] = first_node;

   return true;
}


print_debug_data :: proc(using self: ^BuddyAllocator)
{
   free_mem_count := 0;
   for i in 0 ..< maxdepth {
      
      block := freelist[i];
      block_size := block_size_at(self, i);

      count := 0;
      for block != nil {
         free_mem_count += int(block_size);
         block = block.next;
         count = count + 1;
      }

      fmt.printf("[ %v ] free blocks at depth ( %v ) //block size: %v\n", count, i, block_size);
   }

   used := max - free_mem_count;
   fmt.printf("\n[ %v of %v ] bytes are in use [ %v%% ]\n\n", used, max, 100 * (f32(used) / f32(max)));
}


/* odin allocator stuff */
buddy_allocator :: proc(allocator: ^BuddyAllocator) -> mem.Allocator {
   return mem.Allocator{
      procedure = buddy_allocator_proc,
      data = allocator,
   }
}


buddy_allocator_proc :: proc(data: rawptr, mode: mem.Allocator_Mode, size, alignment: int, old_memory: rawptr, old_size: int, location := #caller_location) -> ([]byte, mem.Allocator_Error) 
{
	buddy := cast(^BuddyAllocator)data;

	switch mode {
      case .Alloc, .Alloc_Non_Zeroed:
         
         ptr := buddy_alloc(buddy, size, alignment);
         if ptr == nil do return nil, .Out_Of_Memory;

         if mode != .Alloc_Non_Zeroed do mem.zero(ptr, size);
         return mem.byte_slice(ptr, size), nil;

      case .Free:
         buddy_free(buddy, old_memory);
         return nil, nil;

      case .Free_All:
         buddy_free_all(buddy);
         return nil, nil;

      case .Query_Features:
         set := (^mem.Allocator_Mode_Set)(old_memory);
         if set != nil do set^ = { .Alloc, .Alloc_Non_Zeroed, .Free, .Free_All, .Query_Features };
         return nil, nil;

      case .Query_Info: fallthrough; 
      case .Resize: return nil, .Mode_Not_Implemented;
	}

	return nil, nil
}
