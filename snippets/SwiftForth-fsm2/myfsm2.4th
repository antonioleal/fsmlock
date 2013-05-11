\ -------------------------------------------------------------\
\ code to create state machines from tabular representations   \
\ -------------------------------------------------------------\

: || ' , ' , ;             \ add two xt's to data field
: WIDE 0 ;                 \ aesthetic, initial state = 0
: PERFORM @ EXECUTE  ;     \ alias

: FSM:   ( width 0 -- )  CREATE   ,  ,  ;

: ;FSM DOES>               ( col# adr -- )
         DUP >R  2@  *  + ( -- col#+width*state )
         2*  2+  CELLS    ( -- offset-to-action)
         R@ +             ( -- x offset-to-action handk ) 
         DUP >R           ( -- offset-to-action)
         PERFORM          ( ? )
         R> CELL+         ( -- offset-to-update)
         PERFORM          ( -- state')
         R> !   ;         \ update state



\ set fsm's state, as in:  0 >state fsm-name
: >state ( state "fsm-name -- )  
    ' >BODY 
    POSTPONE LITERAL POSTPONE !  ; IMMEDIATE   ( state "fsm-name" --)

\ query current state, as in:  state: fsm-name
: state: ( "fsm-name" -- state)
    ' >BODY                     \ get dfa
    POSTPONE LITERAL  POSTPONE @   ;   IMMEDIATE

\ these indicate state transitions in tabular representations        
0 CONSTANT >0  
1 CONSTANT >1  
2 CONSTANT >2  
3 CONSTANT >3
4 CONSTANT >4
5 CONSTANT >5
6 CONSTANT >6
7 CONSTANT >7

\ -------------------------------------------------------------\
\ Example                                                      \
\ -------------------------------------------------------------\

: digit? ( n -- flag ) [char] 0 [char] : within ;

: dp? ( n -- flag ) [char] . = ;

: minus? ( n -- flag ) [char] - = ;

: cat->col# ( c -- n )
    \ Determine the input condition for the entered character
    dup digit? 1 and    \ digit -> 1
    over minus? 2 and + \ -     -> 2
    swap dp? 3 and +    \ dp    -> 3
;                       \ other -> 0


\ Create a finite state machine with 3 states and 4 inputs
\ and define its action table. Each entry in the action table
\ consists of the pair: { word_to_be_executed next_state_number }
4 WIDE FSM: <Fixed.Pt#>
\                  character typed:
\       ||  other?    ||    num?   ||    minus? ||   dp?  
\ state:  ----------------------------------------------------
  ( 0 ) || drop  >0   || emit >1   || emit >1   || emit >2 
  ( 1 ) || drop  >1   || emit >1   || drop >1   || emit >2 
  ( 2 ) || drop  >2   || emit >2   || drop >2   || drop >2 
;FSM                                                      



: Getafix ( -- | allow user to enter valid fixed point number )
    0 >state <Fixed.Pt#>    \ initialize the state to zero
    begin
      cr ." state=" state: <Fixed.Pt#> . cr
      key dup 13 <> over 10 <> and
    while
      dup cat->col#     \ determine input condition 
      <Fixed.Pt#>       \ execute the state machine
    repeat 
    drop ;
