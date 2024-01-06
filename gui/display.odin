package hexchess_gui

import "vendor:sdl2"


Display :: struct {

   event_loop:  proc(^Display, ^sdl2.Event),
   draw_method: proc(^Display),

   rect:        sdl2.Rect,

};


handle_event :: proc(using self: ^Display, e: ^sdl2.Event)
{
   if event_loop != nil do event_loop(self, e);  
}


render :: proc(using self: ^Display)
{
   if draw_method != nil do draw_method(self);
}
