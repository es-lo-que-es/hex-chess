//+private 
package buddy_allocator

import "core:fmt"
import "core:math"


swap :: proc(a, b: ^int)
{ 
   tmp := a^; 
   a^ = b^;
   b^ = tmp;
}


get_power_of_two :: proc(num: int) -> int
{
   num := num; result := 0;
   if !math.is_power_of_two(num) do return 0;

   for num != 1 {
      num = num >> 1;
      result += 1;
   }

   return result; 
}


pop_free_block :: proc(using self: ^BuddyAllocator, depth: i32) -> ^Node
{
   block := freelist[depth];

   freelist[depth] = block.next;
   if freelist[depth] != nil do freelist[depth].prev = nil;

   return block;
}


append_free_list :: proc(using self: ^BuddyAllocator, block: ^Node, depth: i32)
{
   block := block;
   block.prev = nil;
   block.next = freelist[depth];

   if freelist[depth] != nil do freelist[depth].prev = block;
   freelist[depth] = block;

   block.depth = depth;
   block.free = true;
}


remove_free_block :: proc(using self: ^BuddyAllocator, block: ^Node)
{
   depth := block.depth;
   if freelist[depth] == block do freelist[depth] = block.next;

   if block.prev != nil do block.prev.next = block.next;
   if block.next != nil do block.next.prev = block.prev;
}


block_size_at :: proc(using self: ^BuddyAllocator, depth: i32) -> uintptr
{
   return uintptr(min * int(1 << uint(maxdepth - depth - 1)));
}


validate_input :: proc(min, max: int) -> bool
{
   if !math.is_power_of_two(min) {
      fmt.eprintln("min block size has to be power of 2");
      return false;
   }

   if !math.is_power_of_two(max) {
      fmt.eprintln("max block size has to be power of 2");
      return false;
   }

   if min <= size_of(Preambule) {
      fmt.eprintf("min block has to be > %v bytes\n", size_of(Preambule));
      return false;
   }
   
   return true;
}
