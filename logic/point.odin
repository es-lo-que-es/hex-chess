package hexchess_logic


Point :: struct { x, y: int };


point_eq :: proc(a, b: Point) -> bool 
{
   return a.x == b.x && a.y == b.y;
}


DIRECTION_STEP : [len(Direction)]Point = { { 0, -2 }, { 1, -1 }, { 1, 1 }, { 0, 2 }, { -1, 1 }, { -1, -1 } };


move_point :: proc(board: ^Board, point: ^Point, dir: Direction) -> bool
{
   p := add_point(point^, DIRECTION_STEP[dir]);

   if !is_valid(board, p) || get_piece(board, p).type == .Border do return false;
   point^ = p;

   return true;
}


DIAGONAL_STEP : [len(Direction)]Point = { { 1, -3 }, { 2, 0 }, { 1, 3 }, { -1, 3 }, { -2, 0 }, { -1, -3 } };


move_dg :: proc(board: ^Board, point: ^Point, dir: Direction) -> bool
{
   p := add_point(point^, DIAGONAL_STEP[dir]);

   if !is_valid(board, p) || get_piece(board, p).type == .Border do return false;
   point^ = p;

   return true;
}


move_prev_dg :: proc(board: ^Board, point: ^Point, dir: Direction) -> bool
{
   return move_dg(board, point, dec(dir));
}


move_next_dg :: proc(board: ^Board, point: ^Point, dir: Direction) -> bool
{
   return move_dg(board, point, dir);
}


add_point :: proc(a, b: Point) -> Point
{
   return { a.x + b.x, a.y + b.y };
}


invalidate_point :: proc(using self: ^Point)
{
   self.x = -1;
}
