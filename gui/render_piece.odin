package hexchess_gui

import "../logic"
import "vendor:sdl2"


PIECE_TEXTURES : [len(logic.PieceType)*2]Texture = {
   .Cell, .Cell, .WhitePawn, .WhiteRook, .WhiteKing, .WhiteQueen, .WhiteKnight, .WhiteBishop,
   .Cell, .Cell, .BlackPawn, .BlackRook, .BlackKing, .BlackQueen, .BlackKnight, .BlackBishop,
};


render_piece :: proc(using self: logic.Piece, rect: ^sdl2.Rect)
{
   if type == .None || type ==.Border do return;

   index : int = color == .White ? int(type) : int(type) + len(logic.PieceType);
   t := globals.textures[PIECE_TEXTURES[index]];

   sdl2.RenderCopy(globals.renderer, t, nil, rect);
}
