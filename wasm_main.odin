package hexchess

import gui "gui"

import "core:fmt"
import "core:runtime"


when ODIN_ARCH == .wasm32 {

   hex_chess: HexChess;

   // animation frame export for web-based app
   @(export, link_name="_animation_frame")
   animation_frame :: proc "contextless" (ctx: runtime.Context)
   {
      context = ctx;

      handle_one_player_game(&hex_chess);

      poll_events(&hex_chess);
      gui.draw(hex_chess.display);
   }
   

   @(export, link_name="_wasm_init")
   wasm_init :: proc "contextless" (ctx: runtime.Context) -> bool
   {
      context = ctx;
      
      ok := init_hex_chess(&hex_chess);

      if !ok  {
         fmt.eprintln("failed to init hex chess");
         return false;
      };

      return true;
   }
}
