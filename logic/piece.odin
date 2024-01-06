package hexchess_logic


PieceColor :: enum u16 { White, Black };
PieceType  :: enum u16 { None, Border, Pawn, Rook, King, Queen, Knight, Bishop };


//       WHITE   BLACK
// color  0x00    0x01

//        NONE  BORDER  PAWN   ROOK   KING  QUEEN  KNIGHT BISHOP 
// type   0x00   0x01   0x02   0x03   0x04  0x05    0x06   0x07


Piece :: struct {
   type:  PieceType,
   color: PieceColor,
};


valid_piece :: proc(using self: Piece) -> bool
{
   if color < min(PieceColor) || color > max(PieceColor) do return false;
   if type < min(PieceType) || type > max(PieceType) do return false;

   return true;
}


piece_eq :: proc(a, b: Piece) -> bool 
{
   return a.type == b.type && a.color == b.color;
}


opposite_color :: #force_inline proc(col: PieceColor) -> PieceColor
{
   // !col would be nice but this not C :(
   return PieceColor ( int(col) ~ 1 );
}
