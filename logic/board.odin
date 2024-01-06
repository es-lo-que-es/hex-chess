package hexchess_logic

import "core:fmt"
import "core:slice"


Board :: struct {
   cells:      [][]Piece,
   height:     int,
   max_width:  int,
};


find_max_width :: proc(cells: [][]Piece) -> int
{
   max_width := 0;
   for row in cells {
      if len(row) > max_width do max_width = len(row);
   }

   return max_width;
}


init_board :: proc(using self: ^Board, cell_arr: [][]Piece) -> bool
{
   height = len(cell_arr);
   max_width = find_max_width(cell_arr);

   if max_width == 0 {
      fmt.eprintln("cannot create an empty board");
      return false;
   }

   cells = make([][]Piece, height);

   if cells == nil {
      fmt.eprintln("init_board: bad alloc"); 
      return false;
   }

   for i in 0 ..< len(cells) {
      cells[i] = slice.clone(cell_arr[i]);

      if cells[i] == nil {
         fmt.eprintln("init_board: slice.clone failed");
         release_board(self);

         return false;
      }
   }
   
   return true;
}


release_board :: proc(using self: ^Board)
{
   for i in 0 ..< height do delete(cells[i]);
   delete(cells);
}  


is_valid :: proc(using self: ^Board, point: Point) -> bool
{
   if point.y >= height || point.y < 0 do return false;
   if point.x >= len(cells[point.y]) || point.x < 0 do return false;
   
   return true;
}


set_piece :: proc(using self: ^Board, point: Point, piece: Piece)
{
   assert(is_valid(self, point));
   cells[point.y][point.x] = piece;
}


get_piece :: proc(using self: ^Board, point: Point) -> Piece
{
   assert(is_valid(self, point));
   return cells[point.y][point.x];
}


move_piece :: proc(using self: ^Board, a, b: Point)
{
   set_piece(self, b, get_piece(self, a));
   set_piece(self, a, { .None, .White });
}


find_piece :: proc(using self: ^Board, piece: Piece) -> (Point, bool)
{
   for i in 0 ..< height {
      for k := even(i) ? 1 : 0; k < len(cells[i]); k+=2 {
         if piece_eq(cells[i][k], piece) do return { k, i }, true;
      }
   }

   return { 0, 0 }, false;
}


@(private)
even :: #force_inline proc(#any_int num: int) -> bool 
{
    return num & 1 == 0;
}


// TODO: replace it with something more flexible, like memoryzing starting pawn pos or smth
can_charge :: proc(point: Point, col: PieceColor) -> bool
{
   if col == .White do return point.y == abs(point.x - 5) + 14;
   return point.y == -abs(point.x - 5) + 8;
}
