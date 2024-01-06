package hexchess

import gui "gui"
import logic "logic"

import "vendor:sdl2"


HexChess :: struct {
   
   display:      ^gui.Display,
   main_menu:    gui.MainMenu,
   game_display: gui.GameDisplay,

   game:         logic.Game,
   run:          bool,
}

// TODO: replace it all with config
BG_COLOR: sdl2.Color: { 55, 55, 55, 255 };

HEIGHT: i32: 800;
WIDTH: i32: 800;
TICK: u32: 100;


init_hex_chess :: proc(using self: ^HexChess) -> bool
{
   ok := false;

   run = true;
   gui.init_gui(BG_COLOR, TICK, WIDTH, HEIGHT) or_return;
   defer if !ok do gui.release_gui();

   logic.init_game(&game, .White, logic.DEFAULT_BOARD) or_return;
   defer if !ok do logic.release_game(&game);

   gui.init_game_display(&game_display, gui.globals.rect, &game) or_return;
   defer if !ok do gui.release_game_display(&game_display);

   gui.init_main_menu(&main_menu, gui.globals.rect) or_return;

   bind_callbacks(self);
   display = &main_menu;
   ok = true;

   return ok;
}


release_hex_chess :: proc(using self: ^HexChess)
{
   gui.release_game_display(&game_display);
   gui.release_main_menu(&main_menu);

   logic.release_game(&game);
   gui.release_gui();
}


main_menu_cb :: proc(tile_display: ^gui.TileDisplay, par: rawptr)
{
   self := (^HexChess)(par);
   using self;

   index := tile_display.index;

   if index == 0 do start_one_player_game(self);
   else do run = false;

}


bind_callbacks :: proc(using self: ^HexChess) 
{
   gui.set_tile_display_cb(&main_menu, main_menu_cb, self);
}


poll_events :: proc(using self: ^HexChess)
{
   event: sdl2.Event;

   for sdl2.PollEvent(&event) {
      if event.type == .QUIT { run = false; return; }
      gui.handle_event(display, &event);
   }
}


main_loop :: proc (using self: ^HexChess)
{
   for run {
      // NOTE: this will be replaced when there are more game mode's to handle
      handle_one_player_game(self);

      poll_events(self);
      gui.draw(display);
   }
}

