{ ====================================================================
stacks.4th
Simple memory based stacks

Copyright (C) 2001 FORTH, Inc.   <br> Rick VanNorman  rvn@forth.com
Modified by Antonio Leal
==================================================================== }

OPTIONAL STACKS Define memory based stacks

{ --------------------------------------------------------------------
STACK creates a stack of N cells.

PUSH  puts the value X on top of the stack.

TOP  reads the top of the stack.

POP  discards the top number on the stack.

/STACK clears the stack.

EMPTY? checks if the stack has any data.
-------------------------------------------------------------------- }

: STACK ( n -- )  \ Usage: n STACK <name>
   CREATE   HERE ,  CELLS ALLOT ;

: PUSH ( x stack -- ) \ place a cell in the stack
   CELL OVER +! @ ! ;

: TOP ( stack -- x ) \ get a copy of top of stack
   @ @ ;

: /DROP ( stack -- )  \ delete top of stack
   DUP DUP @ = NOT IF  -CELL SWAP +!  THEN ;

: /STACK ( stack -- )  \ clear the stack
   DUP ! ;

: EMPTY? ( stack -- flag ) \ returns true if stack is empty
   DUP @ = ;

: POP ( stack -- x ) \ TOP then /DROP
    DUP DUP EMPTY? NOT IF TOP SWAP /DROP ELSE DROP DROP THEN ;



\ ---------------------------------------------------\ 
\ test the stack                                     \
\ ---------------------------------------------------\
100 STACK s
page

: check-stack
    cr
    ." empty? returns -> "
    s empty? IF ." TRUE" ELSE ." FALSE" THEN cr .s
    cr ;

: test 
    5 s push s top . cr
    1 s push s top . cr
    756 s push s top . cr
    96 s push s top . cr
    31 s push s top . cr
    
    check-stack
    
    s pop . cr
    s pop . cr
    s pop . cr
    s pop . cr
    s pop . cr
    
    check-stack ;

test

cr .s bye

