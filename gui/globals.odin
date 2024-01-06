package hexchess_gui

import "core:fmt"
import "vendor:sdl2"
import "vendor:sdl2/image"


Globals :: struct {

   window:   ^sdl2.Window,
   renderer: ^sdl2.Renderer,
   textures: TexturePack,

   rect:     sdl2.Rect,
   tick:     u32,

};


init_sdl_components :: proc(using self: ^Globals, c: sdl2.Color) -> bool
{
   sdl2.Init( { .VIDEO } );
   image.Init( { .PNG } );

   flags : sdl2.WindowFlags;
   pos : i32 = sdl2.WINDOWPOS_CENTERED;

   when ODIN_ARCH != .wasm32 do flags = { .RESIZABLE, .SHOWN };
   else do flags = { .SHOWN };
   

   window = sdl2.CreateWindow("hex-chess", pos, pos, rect.w, rect.h, flags);
   
   if window == nil {
      fmt.eprintln("failed to create sdl window.", sdl2.GetError());
      return false;
   }
   
   renderer = sdl2.CreateRenderer(window, -1, sdl2.RENDERER_ACCELERATED);

   if renderer == nil {
      fmt.eprintln("failed to create sdl renderer.", sdl2.GetError());
      return false;
   }

   sdl2.SetRenderDrawColor(renderer, c.r, c.g, c.b, c.a);
   sdl2.RenderSetLogicalSize(renderer, rect.w, rect.h);
   
   return true;
}


init_gui :: proc(c: sdl2.Color, t: u32, w, h: i32) -> bool
{
   using globals;

   tick = t;
   ok := false;

   rect = { 0, 0, w, h };
   init_sdl_components(&globals, c) or_return;
   defer if !ok do release_sdl_components();

   init_texture_pack(&textures) or_return;
   ok = true;

   return ok;
}


release_sdl_components :: proc()
{
   using globals;
   sdl2.DestroyRenderer(renderer);
   sdl2.DestroyWindow(window);
   image.Quit();
   sdl2.Quit();
}


release_gui :: proc()
{
   using globals;
   release_texture_pack(&textures);
   release_sdl_components();
}


draw :: proc(display: ^Display)
{
   using globals;

   sdl2.RenderClear(renderer);
   render(display);

   sdl2.RenderPresent(renderer);

   sdl2.Delay(tick);
}


globals: Globals;
