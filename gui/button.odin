package hexchess_gui

import "vendor:sdl2"


Button :: struct {
   
   using display:  Display,
   texture:        ^sdl2.Texture,

   click_callback: proc(^Button, rawptr),
   callback_par:   rawptr,

   color:          sdl2.Color,
   hovered:        bool,
   
};


init_button :: proc(using self: ^Button, r: sdl2.Rect, t: Texture, col: sdl2.Color)
{
   color = col; rect = r;
   texture = globals.textures[t];

   event_loop = button_event_loop;
   draw_method = render_button;
}


set_button_cb :: proc(using self: ^Button, callback: proc(^Button, rawptr), par: rawptr)
{
   click_callback = callback;
   callback_par = par;
}


button_event_loop :: proc(par: ^Display, e: ^sdl2.Event)
{
   self := (^Button)(par);
   using self;
   
   if !mouse_event(e) do return;

   point: sdl2.Point = { e.motion.x, e.motion.y }; 

   hovered = bool(sdl2.PointInRect(&point, &rect));
   if !hovered do return;

   if e.type == .MOUSEBUTTONDOWN {
      if click_callback != nil do click_callback(self, callback_par);
   }
}


render_button :: proc(par: ^Display)
{
   self := (^Button)(par);
   using self;

   sdl2.RenderCopy(globals.renderer, texture, nil, &rect);
   if hovered do draw_rect(&rect, color);

}
