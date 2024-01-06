package hexchess_logic


pawn_danger :: proc(board: ^Board, point: Point, dir: Direction, col: PieceColor) -> bool
{
   point := point;
   if !move_point(board, &point, dir) do return false;

   piece := get_piece(board, point);
   result := piece.color != col && piece.type == .Pawn;

   return result;
}


line_danger :: proc(board: ^Board, point: Point, dir: Direction, col: PieceColor) -> bool
{
   point := point;
   piece: Piece = { .None, .White };

   for piece.type == .None && move_point(board, &point, dir) {
      piece = get_piece(board, point);
   }

   result := piece.color != col && ( piece.type == .Rook || piece.type == .Queen );

   return result;
}


diagonal_danger :: proc(board: ^Board, point: Point, dir: Direction, col: PieceColor) -> bool
{
   point := point;
   piece: Piece = { .None, .White };

   for piece.type == .None && move_next_dg(board, &point, dir) {
      piece = get_piece(board, point);
   }

   result := piece.color != col && ( piece.type == .Bishop || piece.type == .Queen );

   return result;
}


knight_danger :: proc(board: ^Board, point: Point, dir: Direction, col: PieceColor) -> bool
{
   point := point;
   if !move_point(board, &point, dir) do return false;

   a := point;
   if move_next_dg(board, &point, dir) {

      piece := get_piece(board, point);

      if piece.color != col && piece.type == .Knight {
         return true;
      }
   }

   if move_next_dg(board, &a, dir) {

      piece := get_piece(board, a);

      if piece.color != col && piece.type == .Knight {
         return true;
      }
   }

   return false;
}


king_danger :: proc(board: ^Board, point: Point, dir: Direction, col: PieceColor) -> bool
{
   point := point;
   if !move_point(board, &point, dir) do return false;

   piece := get_piece(board, point);
   if piece.color != col && piece.type == .King do return true;

   if !move_point(board, &point, inc(dir)) do return false;

   piece = get_piece(board, point);
   if piece.color != col && piece.type == .King do return true;

   return false;
}


in_danger :: proc(board: ^Board, point: Point, col: PieceColor) -> bool
{
   point := point;
   dir: Direction = col == .White ? .Up : .Down;

   if pawn_danger(board, point, inc(dir), col) || pawn_danger(board, point, dec(dir), col) do return true;

   for dir in Direction {
      if line_danger(board, point, dir, col) do return true;
      if diagonal_danger(board, point, dir, col) do return true;
      if knight_danger(board, point, dir, col) do return true;
      if king_danger(board, point, dir, col) do return true;
   }

   return false;
}
