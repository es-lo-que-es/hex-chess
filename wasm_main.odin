package hexchess

import gui "gui"

import "core:fmt"
import "core:runtime"
import "vendor:sdl2"

import "core:mem"
import buddy "buddy_allocator"


when ODIN_ARCH == .wasm32 {

MIN_POWER :: 6;
MAX_POWER :: 20;
MIN_BLOCK :: 1 << MIN_POWER;
MAX_BLOCK :: 1 << MAX_POWER;
DEPTH :: MAX_POWER - MIN_POWER + 1;

// NOTE: or u could call buddy_allocator.data_size(min, max)
// to get needed data size instead of calculating it urself
DATA_SIZE :: MAX_BLOCK + DEPTH * size_of(rawptr);
MEMORY: [DATA_SIZE]u8;

default_alocator: mem.Allocator;
ballocator:  buddy.BuddyAllocator;

hex_chess: HexChess;


draw_flag: bool = false;
wasm_draw :: proc(display: ^gui.Display)
{
   using gui.globals;
   
   // the laziest frame pacing for browser i could come up with
   if draw_flag {
      sdl2.RenderPresent(renderer);
   } else {
      sdl2.RenderClear(renderer);
      gui.render(display);
   }

   draw_flag = !draw_flag;
}


// animation frame export for web-based app
@(export, link_name="_animation_frame")
animation_frame :: proc "contextless" (ctx: runtime.Context) -> bool
{
   context = ctx;
   context.allocator = default_alocator;

   handle_one_player_game(&hex_chess);

   poll_events(&hex_chess);
   gui.draw(hex_chess.display);

   // i would return hex_chess.run but its not like web-app ever quits
   return true;
}


@(export, link_name="_wasm_init")
wasm_init :: proc "contextless" (ctx: runtime.Context) -> bool
{
   context = ctx;
   
   ok := buddy.init(&ballocator, MEMORY[:], MIN_BLOCK, MAX_BLOCK);

   if !ok {
      fmt.eprintln("failed to init buddy allocator");
      return false;
   }

   default_alocator = buddy.buddy_allocator(&ballocator);
   context.allocator = default_alocator;

   ok = init_hex_chess(&hex_chess);

   if !ok  {
      fmt.eprintln("failed to init hex chess");
      return false;
   };

   return true;
}


}
