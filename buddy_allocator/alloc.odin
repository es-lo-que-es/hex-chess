//+private
package buddy_allocator

import "core:mem"
import "core:math"


right_buddy :: proc(using self: ^BuddyAllocator, block: ^Node) -> ^Node
{
   block_size := block_size_at(self, block.depth);
   buddy := (^Node)(uintptr(block) + block_size);

   return buddy;
}


any_free_block :: proc(using self: ^BuddyAllocator, depth: i32) -> ^Node
{
   depth := depth;
   block: ^Node = nil;

   for depth >= 0 {
      if freelist[depth] != nil {
         block = pop_free_block(self, depth); 
         break;
      }
      depth = depth - 1;
   } 
   
   return block;
}


split_blocks :: proc(using self: ^BuddyAllocator, depth: i32) -> ^Node
{
   block := any_free_block(self, depth);
   if block == nil do return nil; 

   // split the block untill it is small enough
   for depth > block.depth {
      block.depth = block.depth + 1;
      append_free_list(self, right_buddy(self, block), block.depth);
   }

   block.free = false;

   return block; 
}


buddy_alloc :: proc(using self: ^BuddyAllocator, size, alignment: int) -> rawptr
{
   size := size + size_of(Preambule) + alignment;
   size = math.next_power_of_two(size);

   if size < min do size = min;
   if size > max do return nil;

   depth := i32(get_power_of_two(max/size));

   block := split_blocks(self, depth);
   if block == nil do return nil;

   ptr := uintptr(block) + size_of(Preambule);
   result := mem.align_forward(rawptr(ptr), uintptr(alignment));

   return result;
}
