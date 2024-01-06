package hexchess

import "core:fmt"

import gui "gui"
import logic "logic"



start_one_player_game :: proc(using self: ^HexChess)
{
   col := main_menu.color_switch.selected;

   // TODO: add a popup on failure, it is unlikely to happen but anyway
   logic.reset_game(&game, col, logic.DEFAULT_BOARD);
   gui.reset_game_display(&game_display, &game);
   game.player = .White;

   display = &game_display;
}


handle_one_player_game :: proc(using self: ^HexChess)
{
   if game.state == .SwitchingTurns do one_player_game_turn_switch(self);
}


one_player_game_turn_switch :: proc(using self: ^HexChess)
{
   game.player = logic.opposite_color(game.player);
   game.turn = logic.opposite_color(game.turn);

   if logic.has_moves(&game) {
      game.state = .Ongoing;
      return;
   }
   
   checked := logic.in_danger(&game.board, game.king_pos[game.player], game.player);

   // NOTE: do a proper pop-up
   if checked do fmt.println(game.player, "player lost!");
   else do fmt.println("it's a draw!");

   display = &main_menu;
}  


end_one_player_game :: proc(using self: ^HexChess)
{
   display = &main_menu;
}
