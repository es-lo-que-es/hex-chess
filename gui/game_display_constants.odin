package hexchess_gui

import "core:fmt"
import "core:math"

import "vendor:sdl2"
import logic "../logic"


GameDisplayConstants :: struct {

   piece_offset: i32,
   hex_rect:     sdl2.Rect,
   a, b, c:      sdl2.Point,

   step_x:       i32,
   step_y:       i32,
   side:         i32,
};


even_out :: proc(num: i32) -> i32
{
   return num & 1 != 0 ? num + 1 : num;
}


even :: #force_inline proc(#any_int num: int) -> bool 
{
    return num & 1 == 0;
}


odd :: #force_inline proc(#any_int num: int) -> bool 
{
    return num & 1 == 1;
}


calc_hexagon_size :: proc(using self: ^GameDisplay)
{
   side_w := f32(rect.w) / (f32(game.board.max_width) * 1.5 + 0.5);
   side_h := f32(rect.h) / ((f32(game.board.height) / 2.0 + 0.5) * 1.73);

   cons.side = i32(min(side_w, side_h));

   cons.hex_rect.h = even_out(i32(f32(cons.side) * 1.73));
   cons.hex_rect.w = cons.side * 2;
}


// actual width and height are calculated by the following formulas
// w := side * (board.max_width * 1.5 + 0.5)
// h := cell.height * (board.height / 2 + 0.5)
// but since i use integers and have to even out my iteration steps i calc it with steps instead

center_grid_rect :: proc(using self: ^GameDisplay)
{
   cons.step_y = cons.hex_rect.h / 2;
   cons.step_x = even_out(cons.side * 3);

   board_height := cons.step_y * (i32(game.board.height) + 1); 
   board_width := i32(f32(cons.step_x) * (f32(game.board.max_width) * 0.5 + 0.17));

   rect.y = (rect.h - board_height) / 2;
   rect.x = (rect.w - board_width) / 2;

   rect.h = board_height;
   rect.w = board_width;
}


calc_game_display_constants :: proc(using self: ^GameDisplay)
{
   calc_hexagon_size(self);
   center_grid_rect(self);

   cons.piece_offset = ( cons.hex_rect.w - cons.hex_rect.h ) / 2;

   // points for solving hexagon click
   cons.a = { cons.side / 2, 0 };
   cons.b = { 0, cons.step_y };
   cons.c = { cons.a.x, cons.step_y * 2 };
}


adjust_point :: proc(using self: ^GameDisplay, point: logic.Point) -> logic.Point
{
   point := point;
      
   if flipped {
      point.x = game.board.max_width - point.x - 1;
      point.y = game.board.height - point.y - 1;
   }

   return point;
}


cell_rect :: proc(using self: ^GameDisplay, point: logic.Point) -> sdl2.Rect
{
   point := adjust_point(self, point);

   r := cons.hex_rect;
   r.x += (cons.step_x / 2) * i32(point.x) + rect.x;
   r.y += cons.step_y * i32(point.y) + rect.y;

   return r;
}


piece_rect :: proc(using self: ^GameDisplay, point: logic.Point) -> sdl2.Rect
{
   r := cell_rect(self, point);
   
   r.x += cons.piece_offset;
   r.w = r.h;

   return r;
}


// determine position of 'c' relative to AB line
line_crossing :: proc(a, b, c: sdl2.Point) -> i32
{
   return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x); 
}


solve_triangle :: proc(using self: ^GameDisplay, y: f32, point: sdl2.Point, click: sdl2.Point) -> sdl2.Point
{
   // precise rectangle start cordinates
   rx := point.x * (cons.step_x / 2);
   ry := point.y * cons.step_y;

   // middle point
   b: sdl2.Point = { rx, ry + cons.b.y };
   //determine if it is lower or upper triangle
   if y - math.floor(y) < 0.5 {
      a: sdl2.Point = { rx + cons.a.x, ry };
      if line_crossing(a, b, click) > 0 do return { point.x - 1, point.y - 1 };
   } else {
      c: sdl2.Point = { rx + cons.c.x, ry + cons.c.y };
      if line_crossing(b, c, click) > 0 do return { point.x - 1, point.y + 1 };
   }
   
   return point;
}


click_index :: proc(using self: ^GameDisplay, click: sdl2.Point) -> logic.Point
{
   click := click;
   click.x -= rect.x;
   click.y -= rect.y; 

   if flipped {
      click.x = rect.w - click.x;
      click.y = rect.h - click.y;
   }
   // rectangle cordinates
   x := f32(click.x) / (f32(cons.step_x) / 2);
   // adjust even columns for y offset
   mod_y := even(i32(x)) ? click.y + cons.step_y : click.y;
   y := f32(mod_y) / f32(cons.step_y * 2);

   p: sdl2.Point = { i32(x), i32(y) };
   // adjust fo 'skip-cells' in the layout
   p.y = p.y * 2 + (even(p.x) ? -1 : 0);

   // determine if it is a triangle part and solve it
   if x - math.floor(x) < 0.34 do p = solve_triangle(self, y, p, click);

   return { int(p.x), int(p.y) };
}

// at this point i think it would be easier to do a circle and just tell user to fuck off if he clicks out of the radius
