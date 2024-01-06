package hexchess_gui

import "core:fmt"
import "vendor:sdl2"
import "vendor:sdl2/image"


Texture :: enum { 
   Cell, Avaliable,
   WhitePawn, BlackPawn,
   WhiteRook, BlackRook,
   WhiteKing, BlackKing,
   WhiteQueen, BlackQueen,
   WhiteKnight, BlackKnight,
   WhiteBishop, BlackBishop,
};


TEXTURE_PATH_ARR : [len(Texture)]cstring = { 
   "pics/cell.png", "pics/avaliable_cell.png",
   "pics/white_pawn.png", "pics/black_pawn.png",
   "pics/white_rook.png", "pics/black_rook.png",
   "pics/white_king.png", "pics/black_king.png",
   "pics/white_queen.png", "pics/black_queen.png",
   "pics/white_knight.png", "pics/black_knight.png",
   "pics/white_bishop.png", "pics/black_bishop.png",
};


TexturePack :: [len(Texture)]^sdl2.Texture;


// it doesnt have to be a pointer but since all the other inits take ptrs this one takes too
init_texture_pack :: proc(self: ^TexturePack) -> bool
{
   for texture in Texture {
      self[texture] = load_png_texture(TEXTURE_PATH_ARR[texture]);

      if self[texture] == nil {

         release_texture_pack(self);
         fmt.eprintln("init_texture_pack: ", sdl2.GetError());

         return false;
      }
   }

   return true;
}


release_texture_pack :: proc(self: ^TexturePack) 
{
   for texture in Texture {
      // passing nil pointer will change last error msg
      if self[texture] != nil {

         sdl2.DestroyTexture(self[texture]);
         self[texture] = nil;
      }
   }

}
