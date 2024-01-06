package hexchess

import "core:fmt"


main :: proc()
{  
   hex_chess: HexChess;

   ok := init_hex_chess(&hex_chess);

   if !ok  {
      fmt.eprintln("failed to init hex chess");
      return;
   };

   main_loop(&hex_chess);
   release_hex_chess(&hex_chess);

}
