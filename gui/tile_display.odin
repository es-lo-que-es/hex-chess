package hexchess_gui

import "core:fmt"
import "vendor:sdl2"


TileDisplay :: struct {

   using display:  Display,

   tile_width:     i32,
   color:          sdl2.Color,
   tiles:          []^sdl2.Texture,

   click_callback: proc(^TileDisplay, rawptr),
   callback_par:   rawptr,
   
   index:          i32,

};


init_tile_display :: proc(using self: ^TileDisplay, r: sdl2.Rect, col: sdl2.Color, t: []Texture) -> bool
{
   index = -1;
   color = col; rect = r; 

   if len(t) == 0 {
      fmt.eprintln("init_tile_display: 0 tiles provided");
      return false;
   }

   tile_width = rect.w / i32(len(t));
   rect.y = (rect.h - tile_width) / 2;
   rect.h = tile_width;

   tiles = make([]^sdl2.Texture, len(t));
   
   if tiles == nil {
      fmt.eprintln("init_tile_display: bad alloc");   
      return false;
   }

   for name, ind in t do tiles[ind] = globals.textures[name];

   event_loop = tile_display_event_loop;
   draw_method = render_tile_display;

   return true;
}


set_tile_display_cb :: proc(using self: ^TileDisplay, callback: proc(^TileDisplay, rawptr), par: rawptr)
{
   click_callback = callback;
   callback_par = par;
}


release_tile_display :: proc(using self: ^TileDisplay)
{
   delete(tiles);
}


tile_display_event_loop :: proc(ptr: ^Display, e: ^sdl2.Event)
{
   self := (^TileDisplay)(ptr);
   using self;

   if !mouse_event(e) do return;

   point: sdl2.Point = { e.motion.x, e.motion.y }; 
   if !sdl2.PointInRect(&point, &rect) { index = -1; return; }

   if e.type == .MOUSEBUTTONDOWN {
      if click_callback != nil do click_callback(self, callback_par);
   } else if e.type == .MOUSEMOTION {
      point.x = point.x - rect.x;
      index = point.x / tile_width;
   }
}


hightlight_tile :: proc(using self: ^TileDisplay, r: sdl2.Rect)
{
   if index < 0 do return;

   r := r;
   r.x = rect.x + index * tile_width;
   fill_rect(&r, color);
}


render_tile_display :: proc(ptr: ^Display)
{
   self := (^TileDisplay)(ptr); 
   using self;

   r := rect; r.w = tile_width;
   hightlight_tile(self, r);

   for tile in tiles {
      sdl2.RenderCopy(globals.renderer, tile, nil, &r);
      r.x += r.w;
   }
}
