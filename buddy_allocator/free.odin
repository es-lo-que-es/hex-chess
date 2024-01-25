//+private
package buddy_allocator

import "core:mem"


locate_buddy :: proc(using self: ^BuddyAllocator, block: ^Node) -> ^Node
{
   buddy: ^Node = nil;

   size := block_size_at(self, block.depth);
   offset := uintptr(block) - uintptr(raw_data(self.data)); 

   // if our block is odd one it is the right buddy
   right := ((offset / size) & 1) == 1;

   if right do buddy = (^Node)(uintptr(block) - size);
   else do buddy = (^Node)(uintptr(block) + size);

   return buddy;
}


merge_block :: proc(using self: ^BuddyAllocator, block: ^Node) -> ^Node
{
   block := block;

   for block.depth > 0 { 
      buddy := locate_buddy(self, block);
      if !buddy.free || buddy.depth != block.depth do return block;

      remove_free_block(self, buddy);
      if block > buddy do block = buddy;

      block.depth = block.depth - 1;
   }

   return block; 
}


buddy_free :: proc(using self: ^BuddyAllocator, ptr: rawptr)
{
   if ptr == nil do return;

   block := (^Node)(uintptr(ptr) - size_of(Preambule));
   if block.free do return;

   block = merge_block(self, block);
   block.free = true;

   append_free_list(self, block, block.depth);   
}


buddy_free_all :: proc(using self: ^BuddyAllocator)
{
   mem.set(raw_data(freelist), 0, len(freelist)*size_of(^Node));

   first_node := (^Node)(raw_data(data));
   first_node^ = { { true, 0 }, nil, nil };
   freelist[0] = first_node;
}
