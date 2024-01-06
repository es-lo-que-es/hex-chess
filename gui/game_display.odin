package hexchess_gui

import "core:fmt"
import "core:time"
import "vendor:sdl2"

import logic "../logic"


GameDisplay :: struct {

   using display: Display,

   cons:          GameDisplayConstants,

   upgrade:       UpgradeDisplay,
   exit_button:   Button,

   texture:       ^sdl2.Texture,
   game:          ^logic.Game,

   flipped:       bool,

};


CellColor :: enum { White, Gray, Black, Highlight };


COLOR_ARR : [len(CellColor)]sdl2.Color = { 
   { 230, 237, 222, 255 }, // white 
   { 119, 149, 86, 255 },  // black
   { 150, 160, 140, 255 }, // grey 
   { 207, 218, 139, 255 }, // highlight
};


highlight :: proc(using self: ^GameDisplay)
{
   if !logic.is_valid(&game.board, game.selected) do return;

   r := cell_rect(self, game.selected);
   fill_cell(COLOR_ARR[CellColor.Highlight], &r);
}


fill_cell :: proc(c: sdl2.Color, rect: ^sdl2.Rect)
{
   t := globals.textures[Texture.Cell];

   sdl2.SetTextureColorMod(t, c.r, c.g, c.b);
   sdl2.RenderCopy(globals.renderer, t, nil, rect);
}


render_moves :: proc(using self: ^GameDisplay)
{
   t := globals.textures[Texture.Avaliable];

   for &move in game.moves {
      r := cell_rect(self, move.to);
      sdl2.RenderCopy(globals.renderer, t, nil, &r);
   }
}


pre_render_board ::proc(using self: ^GameDisplay)
{
   r := cons.hex_rect;

   sdl2.SetRenderTarget(globals.renderer, texture);
   sdl2.RenderClear(globals.renderer);

   for i in 0 ..< game.board.height {

      r.x = even(i) ? cons.step_x / 2.0 : 0;
      for j := even(i) ? 1 : 0; j < len(game.board.cells[i]); j+=2 {
         
         type := logic.get_piece(&game.board, {j, i}).type;
         if type != .Border do fill_cell(COLOR_ARR[i%3], &r);
         r.x += cons.step_x;
      }

      r.y += cons.step_y;
   }

   sdl2.SetRenderTarget(globals.renderer, nil);
}


render_pieces :: proc(using self: ^GameDisplay)
{
   // TODO: make this linear instead of calculating every cell
   // NOTE: reverse algo fo a flipped board could be a bit tricky but its worth it
   for i in 0 ..< game.board.height {
      for j := even(i) ? 1 : 0; j < len(game.board.cells[i]); j+=2 {
         r := piece_rect(self, { j, i });
         render_piece(logic.get_piece(&game.board, {j, i}), &r);
      }
   }
}


init_board_texture :: proc(using self: ^GameDisplay) -> bool
{
   access := sdl2.TextureAccess.TARGET;
   format := u32(sdl2.PixelFormatEnum.RGBA32);

   texture = sdl2.CreateTexture(globals.renderer, format, access, rect.w, rect.h)

   if texture == nil {
      fmt.eprintln("failed to create board texture. ", sdl2.GetError());
      return false;
   }

   pre_render_board(self);
   return true;
}


exit_button_cb :: proc(btn: ^Button, par: rawptr)
{
   game := (^GameDisplay)(par).game;
   game.state = .Quiting;
}


init_game_display :: proc(using self: ^GameDisplay, r: sdl2.Rect, g: ^logic.Game) -> bool
{
   ok := false;
   rect = r; game = g;

   flipped = game.player == .Black;
   calc_game_display_constants(self);
   
   init_upgrade_display(&self.upgrade, r, g) or_return;
   defer if !ok do release_upgrade_display(&upgrade);

   init_board_texture(self) or_return;

   s: i32 = 60;
   br: sdl2.Rect = { r.x + r.w - s, r.y, s, s };
   init_button(&exit_button, br, .XButton, {240, 240, 240, 255});
   set_button_cb(&exit_button, exit_button_cb, self);
   
   event_loop = game_display_event_loop;
   draw_method = render_game_display;
   ok = true;

   return ok;
}


release_game_display :: proc(using self: ^GameDisplay)
{
   release_upgrade_display(&upgrade);
   sdl2.DestroyTexture(texture);
}


render_game_display :: proc(ptr: ^Display)
{
   self: ^GameDisplay = (^GameDisplay)(ptr);
   using self;

   if game.state == .PawnUpgrade { render(&upgrade); return; }

   if flipped do render_flipped(globals.renderer, texture, nil, &rect);
   else do sdl2.RenderCopy(globals.renderer, texture, nil, &rect);

   render(&exit_button);

   highlight(self);
   render_moves(self);
   render_pieces(self);
}


game_display_event_loop :: proc(ptr: ^Display, e: ^sdl2.Event)
{
   self := (^GameDisplay)(ptr);
   using self;

   if game.state == .PawnUpgrade { handle_event(&upgrade, e); return; }

   if e.type == .MOUSEBUTTONDOWN {
      point := click_index(self, {e.motion.x, e.motion.y});
      logic.select_cell(game, point);
   }

   handle_event(&exit_button, e);
}


reset_game_display :: proc(using self: ^GameDisplay, g: ^logic.Game)
{
   flipped = g.player == .Black;

   upgrade.game = g;
   game = g;
}
