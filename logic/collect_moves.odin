package hexchess_logic


can_hit :: #force_inline proc(piece: Piece, col: PieceColor) -> bool
{
   return piece.type == .None || ( piece.color != col );
}


enemy :: #force_inline proc(piece: Piece, col: PieceColor) -> bool
{
   return piece.type != .None && piece.color != col;
}


bishop_moves :: proc(game: ^Game, point: Point, col: PieceColor)
{
   for dir in Direction {
      
      mpoint := point;
      for move_next_dg(&game.board, &mpoint, dir) {

         piece := get_piece(&game.board, mpoint);

         if piece.type != .None {
            if piece.color != col do append_move(game, point ,mpoint);
            break;
         }

         append_move(game, point, mpoint);
      }
   }

}


rook_moves :: proc(game: ^Game, point: Point, col: PieceColor)
{
   for dir in Direction {
      
      mpoint := point;
      for move_point(&game.board, &mpoint, dir) {
         
         piece := get_piece(&game.board, mpoint);

         if piece.type != .None {
            if piece.color != col do append_move(game, point, mpoint);
            break;
         }

         append_move(game, point, mpoint);
      }
   }

}


queen_moves :: proc(game: ^Game, point: Point, col: PieceColor)
{
   bishop_moves(game, point, col);
   rook_moves(game, point, col);
}


// TODO: consider refactoring this since horse wont be able to just through borders on custom &game.boards
knight_moves :: proc(game: ^Game, point: Point, col: PieceColor)
{
   for dir in Direction {

      mpoint := point;
      if !move_next_dg(&game.board, &mpoint, dir) do continue;
         
      a := mpoint;
      if move_point(&game.board, &mpoint, dir) {

         if can_hit(get_piece(&game.board, mpoint), col) {
            append_move(game, point, mpoint);
         }
      }

      if move_point(&game.board, &a, inc(dir)) {

         if can_hit(get_piece(&game.board, a), col) {
            append_move(game, point, a);
         }
      }
   }

}


king_moves:: proc(game: ^Game, point: Point, col: PieceColor)
{
   for dir in Direction {
      
      mpoint := point;
      if move_next_dg(&game.board, &mpoint, dir) {

         if can_hit(get_piece(&game.board, mpoint), col) {
            append_move(game, point, mpoint);
         }
      }

      mpoint = point;
      if move_point(&game.board, &mpoint, dir) {

         if can_hit(get_piece(&game.board, mpoint), col) {
            append_move(game, point, mpoint);
         }
      }
   }

}


collect_moves :: proc(game: ^Game, point: Point)
{
   clear(&game.moves); 
   piece := get_piece(&game.board, point);

   switch piece.type {

      case .Bishop: bishop_moves(game, point, piece.color);
      case .Knight: knight_moves(game, point, piece.color);
      case .Queen: queen_moves(game, point, piece.color);
      case .Rook: rook_moves(game, point, piece.color);
      case .Pawn: pawn_moves(game, point, piece.color);
      case .King: king_moves(game, point, piece.color);

      case .Border: fallthrough; 
      case .None: return;
   }

}
