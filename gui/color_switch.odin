package hexchess_gui

import "vendor:sdl2"
import logic "../logic"


ColorSwitch :: struct {
   
   using display: Display,
   
   front:         ^sdl2.Texture,
   back:          ^sdl2.Texture,

   front_rect:    sdl2.Rect,
   back_rect:     sdl2.Rect,

   selected:      logic.PieceColor,
   hovered:       bool,

};


init_color_switch :: proc(using self: ^ColorSwitch, r: sdl2.Rect)
{
   rect = r;

   back = globals.textures[Texture.BlackPawn];
   front = globals.textures[Texture.WhitePawn];

   s := r.w / 20;
   front_rect = { r.x - s, r.y + s, r.w, r.h };
   back_rect = { r.x + s, r.y - s, r.w, r.h };

   event_loop = color_switch_event_loop;
   draw_method = render_color_switch;
}


switch_colors :: proc(using self: ^ColorSwitch)
{
   tmp := front;
   self.selected = logic.opposite_color(self.selected);

   front = back;
   back = tmp;
}


color_switch_event_loop :: proc(ptr: ^Display, e: ^sdl2.Event)
{
   self := (^ColorSwitch)(ptr);
   using self;

   if !mouse_event(e) do return;

   point: sdl2.Point = { e.motion.x, e.motion.y }; 
   hovered = bool(sdl2.PointInRect(&point, &rect));

   if !hovered do return;

   if e.type == .MOUSEBUTTONDOWN do switch_colors(self);

}


render_color_switch :: proc(ptr: ^Display)
{
   self := (^ColorSwitch)(ptr);
   using self;
   
   c: sdl2.Color: { 119, 149, 86, 255 };

   if hovered do fill_rect(&rect, c);
   else do fill_cell(c, &rect);

   sdl2.RenderCopy(globals.renderer, back, nil, &back_rect);
   sdl2.RenderCopy(globals.renderer, front, nil, &front_rect);
}
