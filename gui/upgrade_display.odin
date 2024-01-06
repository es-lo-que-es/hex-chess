package hexchess_gui

import logic "../logic"
import "vendor:sdl2"


UpgradeDisplay :: struct 
{
   using display: Display,

   white_upgrade: TileDisplay,
   black_upgrade: TileDisplay,

   game: ^logic.Game,
}


init_upgrade_display :: proc(using self: ^UpgradeDisplay, r: sdl2.Rect, g: ^logic.Game) -> bool
{
   rect = r; game = g;  

   // TODO: get this from a config
   col: sdl2.Color: { 240, 105, 105, 255 }; 

   white_pieces: []Texture = { .WhiteKnight, .WhiteBishop, .WhiteQueen, .WhiteRook };
   black_pieces: []Texture = { .BlackKnight, .BlackBishop, .BlackQueen, .BlackRook };

   init_tile_display(&white_upgrade, rect, col, white_pieces) or_return;
   ok := init_tile_display(&black_upgrade, globals.rect, col, black_pieces);

   if !ok {
      release_tile_display(&white_upgrade);
      return false;
   }

   set_tile_display_cb(&white_upgrade, upgrade_clicked, self);
   set_tile_display_cb(&black_upgrade, upgrade_clicked, self);

   event_loop = upgrade_display_event_loop;
   draw_method = render_upgrade_display;

   return true;
}


release_upgrade_display :: proc(using self: ^UpgradeDisplay)
{
   release_tile_display(&white_upgrade);
   release_tile_display(&black_upgrade);
}


UPGRADES: [4]logic.PieceType = { .Knight, .Bishop, .Queen, .Rook };


upgrade_clicked :: proc(using self: ^TileDisplay, par: rawptr)
{
   game := (^UpgradeDisplay)(par).game;
   move := logic.last_move(game);

   move.piece.type = UPGRADES[index];
   move.piece.color = game.turn;

   logic.set_piece(&game.board, move.to, move.piece);
   game.state = .SwitchingTurns;
}


upgrade_display_event_loop :: proc(ptr: ^Display, e: ^sdl2.Event)
{
   self := (^UpgradeDisplay)(ptr);
   using self;

   if game.turn == .White do handle_event(&white_upgrade, e);
   else do handle_event(&black_upgrade, e);
}


render_upgrade_display :: proc(ptr: ^Display)
{
   self := (^UpgradeDisplay)(ptr);
   using self;

   if game.turn == .White do render(&white_upgrade);
   else do render(&black_upgrade);
}
