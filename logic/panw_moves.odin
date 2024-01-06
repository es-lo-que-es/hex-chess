package hexchess_logic


unpasant_cond :: proc(game: ^Game, point: Point, col: PieceColor) -> bool
{
   a := point;
   move := last_move(game);

   if move == nil do return false;
   if move.piece.color == col || move.piece.type != .Pawn do return false;

   if point.x != move.from.x do return false;
   if !even(move.from.y + move.to.y) do return false;
   
   result := ((move.from.y + move.to.y) / 2) == point.y;

   return result;
}


forward_pawn_moves :: proc(game: ^Game, point: Point, dir: Direction, col: PieceColor)
{
   mpoint := point;

   if move_point(&game.board, &mpoint, dir) {

      if get_piece(&game.board, mpoint).type != .None do return;
      append_move(game, point, mpoint);

      if !can_charge(point, col) do return;

      if move_point(&game.board, &mpoint, dir) {
         if get_piece(&game.board, mpoint).type != .None do return;
         append_move(game, point, mpoint);
      }
   }

}


pawn_hit :: proc(game: ^Game, point: Point, dir: Direction, col: PieceColor)
{
   mpoint := point;
   if !move_point(&game.board, &mpoint, dir) do return;

   if enemy(get_piece(&game.board, mpoint), col) {
      append_move(game, point, mpoint);
   } else if unpasant_cond(game, mpoint, col) {
      append_move(game, point, mpoint);
   }

}


pawn_moves :: proc(game: ^Game, point: Point, col: PieceColor)
{
   dir : Direction = col == .White ? .Up : .Down; 

   forward_pawn_moves(game, point, dir, col);

   pawn_hit(game, point, dec(dir), col);
   pawn_hit(game, point, inc(dir), col);
}
