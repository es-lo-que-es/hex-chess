package hexchess_logic

//       WHITE   BLACK
// color  0x00    0x01

//        NONE  BORDER  PAWN   ROOK   KING  QUEEN  KNIGHT BISHOP 
// type   0x00   0x01   0x02   0x03   0x04  0x05    0x06   0x07

PieceEnum :: enum u32 {
   Wb = 0x00000007, Bb = 0x00010007,
   Wh = 0x00000006, Bh = 0x00010006,
   Wq = 0x00000005, Bq = 0x00010005,
   Wk = 0x00000004, Bk = 0x00010004,
   Wr = 0x00000003, Br = 0x00010003,
   Wp = 0x00000002, Bp = 0x00010002,
   No = 0,          Bd = 1,
}

DEFAULT_BOARD_ARR : [][]PieceEnum = {

   { .Bd, .Bd, .Bd, .Bd, .Bd, .Bb, .Bd, .Bd, .Bd, .Bd, .Bd },
   { .Bd, .Bd, .Bd, .Bd, .Bq, .No, .Bk, .Bd, .Bd, .Bd, .Bd },
   { .Bd, .Bd, .Bd, .Bh, .No, .Bb, .No, .Bh, .Bd, .Bd, .Bd },
   { .Bd, .Bd, .Br, .No, .No, .No, .No, .No, .Br, .Bd, .Bd },
   { .Bd, .Bp, .No, .No, .No, .Bb, .No, .No, .No, .Bp, .Bd },
   { .No, .No, .Bp, .No, .No, .No, .No, .No, .Bp, .No, .No },
   { .No, .No, .No, .Bp, .No, .No, .No, .Bp, .No, .No, .No },
   { .No, .No, .No, .No, .Bp, .No, .Bp, .No, .No, .No, .No },
   { .No, .No, .No, .No, .No, .Bp, .No, .No, .No, .No, .No },
   { .No, .No, .No, .No, .No, .No, .No, .No, .No, .No, .No },
   { .No, .No, .No, .No, .No, .No, .No, .No, .No, .No, .No },
   { .No, .No, .No, .No, .No, .No, .No, .No, .No, .No, .No },
   { .No, .No, .No, .No, .No, .No, .No, .No, .No, .No, .No },
   { .No, .No, .No, .No, .No, .No, .No, .No, .No, .No, .No },
   { .No, .No, .No, .No, .No, .Wp, .No, .No, .No, .No, .No },
   { .No, .No, .No, .No, .Wp, .No, .Wp, .No, .No, .No, .No },
   { .No, .No, .No, .Wp, .No, .No, .No, .Wp, .No, .No, .No },
   { .No, .No, .Wp, .No, .No, .No, .No, .No, .Wp, .No, .No },
   { .Bd, .Wp, .No, .No, .No, .Wb, .No, .No, .No, .Wp, .Bd },
   { .Bd, .Bd, .Wr, .No, .No, .No, .No, .No, .Wr, .Bd, .Bd },
   { .Bd, .Bd, .Bd, .Wh, .No, .Wb, .No, .Wh, .Bd, .Bd, .Bd },
   { .Bd, .Bd, .Bd, .Bd, .Wq, .No, .Wk, .Bd, .Bd, .Bd, .Bd },
   { .Bd, .Bd, .Bd, .Bd, .Bd, .Wb, .Bd, .Bd, .Bd, .Bd, .Bd },

};


DEFAULT_BOARD := transmute([][]Piece) DEFAULT_BOARD_ARR;
