package hexchess_logic


Direction :: enum { Up, Ur, Dr, Down, Dl, Ul };


rev :: proc(dir: Direction) -> Direction
{
   return Direction((int(dir) + 3) % 6);
}


inc :: proc(dir: Direction) -> Direction
{
   return Direction((int(dir)+1) % 6);
}


dec :: proc(dir: Direction) -> Direction
{
   return Direction((int(dir)+5) % 6);
}
