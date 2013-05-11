\ Timers
\
\ ---------------------------------------------------\
\     (c) Copyright 2013  Antonio Leal               \
\ ---------------------------------------------------\

\ ---------------------------------------------------\
\ Code to manage timers in SwiftForth                \
\ ---------------------------------------------------\

variable t COUNTER t !  \ initialise the t counter

: TMR-START ( n t -- ) swap COUNTER + swap ! ; \ set t with the target count of n miliseconds
: TMR-TEST ( t -- f ) @ EXPIRED ;         \ return true if the n miliseconds from the TMR-START have expired
: TMR-REMAIN ( t -- ) @ COUNTER - MS ;    \ use after a TMR-START to sleep remaining time n in miliseconds.
: TMR-PRINT ( t -- ) dup TMR-TEST IF drop ." NOT COUNTING" ELSE ." COUNTING [ " @ COUNTER - . ." ]" THEN ;


\ ---------------------------------------------------\ 
\ test the t timer                                   \
\ ---------------------------------------------------\ 

: test-the-t-timer ( -- | test the t timer )
    begin
      key dup 13 <> over 10 <> and
    while
      [char] s = IF cr ." starting to count" cr 5000 t TMR-START THEN
      t TMR-PRINT cr
    repeat drop ;

page
S" test the t timer:" type cr 
test-the-t-timer
cr cr .s bye
