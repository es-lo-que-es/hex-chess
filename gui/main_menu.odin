package hexchess_gui

import "vendor:sdl2"


MainMenu :: struct {
   using menu_items: TileDisplay,
   color_switch:     ColorSwitch,
};



init_main_menu :: proc(using self: ^MainMenu, r: sdl2.Rect) -> bool
{
   // TODO: take this from config
   col: sdl2.Color = { 62, 62, 62, 250 };
   items: []Texture = { .WhiteKnight, .BlackRook };

   init_tile_display(&menu_items, r, col, items) or_return;

   sw := r.w / 7;
   sr: sdl2.Rect = { (r.w - sw) / 2, r.h-sw-20, sw, sw };
   init_color_switch(&color_switch, sr);

   event_loop = main_menu_event_loop;
   draw_method = render_main_menu;

   return true;
}


release_main_menu :: proc(using self: ^MainMenu)
{
   release_tile_display(&menu_items);
}


main_menu_event_loop :: proc(ptr: ^Display, e: ^sdl2.Event)
{
   self := (^MainMenu)(ptr); 
   using self;
   
   tile_display_event_loop(&menu_items, e);
   handle_event(&color_switch, e);
}


render_main_menu :: proc(ptr: ^Display)
{
   self := (^MainMenu)(ptr); 
   using self;

   render_tile_display(&menu_items);
   render(&color_switch);
}
