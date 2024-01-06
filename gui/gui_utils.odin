package hexchess_gui

import "core:fmt"
import "vendor:sdl2" 
import "vendor:sdl2/image"


render_flipped :: proc(renderer: ^sdl2.Renderer, texture: ^sdl2.Texture, src, dest: ^sdl2.Rect) -> i32
{
   return sdl2.RenderCopyEx(renderer, texture, src, dest, 0, nil, .HORIZONTAL | .VERTICAL);
}


load_png_texture :: proc(filename: cstring) -> ^sdl2.Texture
{
   surface := image.Load(filename);

   if surface == nil {
      fmt.eprintf("failed to load '%v'. %v\n", filename, image.GetError());
      return nil;
   }

   texture := sdl2.CreateTextureFromSurface(globals.renderer, surface);
   sdl2.FreeSurface(surface);

   return texture;
}


draw_rect :: proc(rect: ^sdl2.Rect, c: sdl2.Color)
{
   f: sdl2.Color;

   sdl2.GetRenderDrawColor(globals.renderer, &f.r, &f.g, &f.b, &f.a);
   sdl2.SetRenderDrawColor(globals.renderer, c.r, c.g, c.b, c.a);

   sdl2.RenderDrawRect(globals.renderer, rect);

   sdl2.SetRenderDrawColor(globals.renderer, f.r, f.g, f.b, f.a);
}


fill_rect :: proc(rect: ^sdl2.Rect, c: sdl2.Color)
{
   f: sdl2.Color;

   sdl2.GetRenderDrawColor(globals.renderer, &f.r, &f.g, &f.b, &f.a);
   sdl2.SetRenderDrawColor(globals.renderer, c.r, c.g, c.b, c.a);

   sdl2.RenderFillRect(globals.renderer, rect);

   sdl2.SetRenderDrawColor(globals.renderer, f.r, f.g, f.b, f.a);
}


mouse_event :: proc(e: ^sdl2.Event) -> bool
{
   // i only care about this 2
   return e.type == .MOUSEBUTTONDOWN || e.type == .MOUSEMOTION;
}
