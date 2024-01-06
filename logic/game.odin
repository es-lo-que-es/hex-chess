package hexchess_logic

import "core:fmt"


GameState :: enum { Ongoing, PawnUpgrade, SwitchingTurns };


Game :: struct {

   state:    GameState,
   turn:     PieceColor,
   player:   PieceColor,

   history:  [dynamic]Move,
   moves:    [dynamic]Move,

   king_pos: [2]Point,
   selected: Point,

   board:    Board,
};


init_game :: proc(using self: ^Game, side: PieceColor, cells: [][]Piece) -> bool
{
   turn = .White;
   player = side;
   state = .Ongoing;

   invalidate_point(&selected);
   init_board(&board, cells) or_return;
      
   ok: bool;
   for col in PieceColor {
      king_pos[col], ok = find_piece(&board, { .King, col });

      if !ok  {
         fmt.eprintf("failed to find %v King\n", col);
         release_board(&board);

         return false;
      }
   }

   return true;
}


release_game :: proc(using self: ^Game)
{
   release_board(&board);
   delete(moves);
}

// add a possible player move
append_move :: proc(using self: ^Game, a, b: Point)
{
   move: Move;
   init_move(&move, &self.board, a, b);

   if safe_move(&move, self) {
      append(&moves, move);
   }
}


select_piece :: proc(using self: ^Game, point: Point, piece: Piece)
{
   if piece.type == .Border || piece.type == .None do return;

   collect_moves(self, point);
   selected = point;
}


deselect_piece :: proc(using self: ^Game)
{
   invalidate_point(&selected);
   clear(&moves);
}


select_cell :: proc(using self: ^Game, point: Point)
{
   // selected invalid cell
   if !is_valid(&board, point) do return;

   piece := get_piece(&board, point);
   // if there is no piece selected
   if !is_valid(&board, selected) { select_piece(self, point, piece); return; }

   // if it is the same exact cell
   if point_eq(selected, point) { deselect_piece(self); return; }

   selected_piece := get_piece(&board, selected);
   // if it was an enemy piece selected just pick another one
   if selected_piece.color != player { select_piece(self, point, piece); return; }

   // if selected pice is not a viable hit target (friendly or not in the move-list)
   move, found := find_move(self, point);
   if !found { select_piece(self, point, piece); return; }

   // TODO: mb indicate that this is enemy turn
   if turn != player { select_piece(self, point, piece); return; }
   
   process_move(self, &move);
}


find_move :: proc(using self: ^Game, point: Point) -> (Move, bool)
{
   for &move in moves {
      if point_eq(move.to, point) do return move, true;
   }

   return {}, false;
}


// process and apply selected move to the game
process_move :: proc(using self: ^Game, move: ^Move)
{
   apply_move(move, self);
   append(&history, move^);
   self.state  = move.upgrade ? .PawnUpgrade : .SwitchingTurns;
   clear(&moves);
}


has_moves :: proc(using self: ^Game) -> bool 
{
   for i in 0 ..< board.height {

      j := even(i) ? 1 : 0;
      for j = j; j < len(board.cells[i]); j += 2 {
         
         piece := get_piece(&board, {j, i});
         if piece.color != player do continue;

         collect_moves(self, {j, i});
         if len(moves) == 0 do continue; 

         clear(&moves); 
         return true;
      }
   }

   return false;
}


last_move :: proc(using self: ^Game) -> ^Move
{
   if len(history) == 0 do return nil;
   return &history[len(history)-1];
}


reset_game :: proc(using self: ^Game, side: PieceColor, cells: [][]Piece) -> bool
{
   release_game(self);
   moves = nil; history = nil;

   return init_game(self, side, cells);
}
