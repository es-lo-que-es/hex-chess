package hexchess_logic

import "core:fmt"


Move :: struct {
   
   to:       Point,
   from:     Point,

   captured: Piece,
   piece:    Piece,

   unpasant: bool,
   upgrade:  bool,

};


init_move :: proc(using self: ^Move, board: ^Board, a, b: Point)
{
   to = b;
   from = a;

   captured = get_piece(board, b);
   piece = get_piece(board, a);

   if piece.type == .Pawn {
   
      unpasant = from.x != to.x && captured.type == .None;
      if unpasant do captured = { .Pawn, opposite_color(piece.color) };
         
      // TODO consider making upgrade condition fptr just like charge condition
      point := to;
      dir : Direction = piece.color == .White ? .Up : .Down;
      upgrade = !move_point(board, &point, dir);
      
   }

}


apply_move :: proc(using self: ^Move, game: ^Game)
{
   if unpasant {

      point := to;
      point.y += piece.color == .White ? 2 : -2;

      set_piece(&game.board, point, { .None, .White });
   }

   if piece.type == .King do game.king_pos[piece.color] = to;
   
   set_piece(&game.board, from, { .None, .White });
   set_piece(&game.board, to, piece);

}


revert_move :: proc(using self: ^Move, game: ^Game)
{
   point := to;

   if unpasant {
      set_piece(&game.board, to, { .None, .White });
      point.y += piece.color == .White ? 2 : -2;
   }

   set_piece(&game.board, point, captured);
   if piece.type == .King do game.king_pos[piece.color] = from;

   set_piece(&game.board, from, piece);
}


safe_move :: proc(using self: ^Move, game: ^Game) -> bool
{
   apply_move(self, game);

   result := !in_danger(&game.board, game.king_pos[piece.color], piece.color);

   revert_move(self, game);

   return result;
}
