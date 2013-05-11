\ FSM
\
\ ---------------------------------------------------\
\     (c) Copyright 2001  Julian V. Noble.           \
\       Permission is granted by the author to       \
\       use this software for any application pro-   \
\       vided this copyright notice is preserved.    \
\ ---------------------------------------------------\
                   
\ ---------------------------------------------------\
\ Code to create state machines from                 \
\ tabular representations                            \
\ ---------------------------------------------------\

: || ' , ' , ;             \ add two xt's to data field

: WIDE 0 ;                 \ aesthetic, initial state = 0

: FSM:   ( width 0 -- )  CREATE   ,  ,  ;

: ;FSM DOES>              ( col# adr -- )
         DUP >R  2@  *  + ( -- col#+width*state )
         2*  2+  CELLS    ( -- offset-to-action)
         R@ +             ( -- x offset-to-action handk ) 
         DUP >R           ( -- offset-to-action)
         @ EXECUTE        ( ? )
         R> CELL+         ( -- offset-to-update)
         @ EXECUTE        ( -- state')
         R> !   ;         \ update state

\ set fsm's state, as in:  0 >state fsm-name
: >STATE ( state "fsm-name" -- )  
    ' >BODY 
    POSTPONE LITERAL POSTPONE !  ; IMMEDIATE   ( state "fsm-name" --)

\ query current state, as in:  state: fsm-name
: STATE: ( "fsm-name" -- state)
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
\ etc..

\ ---------------------------------------------------\
\ Example for track section TS-I                     \
\ ---------------------------------------------------\

\ Determine the machine input condition for the event
: [TS-I.feed] ( c -- n )
    dup  [char] f = 1 and      \ ts free event      -> 1
    swap [char] o = 2 and +    \ ts occupied event  -> 2
;                              \ other event        -> 0

: [TS-I.0>1] ( -- ) ." section was freed" drop ;
: [TS-I.0>2] ( -- ) ." section was occupied" drop ;
: [TS-I.1>2] ( -- ) ." section was occupied" drop ;
: [TS-I.2>1] ( -- ) ." section was freed" drop ;

\ Create a finite state machine with 3 states and 3 inputs
\ and define its action table. Each entry in the action table
\ consists of the pair: { word_to_be_executed next_state_number }
\ 3 WIDE means 3 events to be treated.
3 WIDE FSM: [TS-I]
\       ----------------- FSM EVENT TABLE --------------------
\       || other event? || ts free event?   || ts occ event?
\ state:--------------- --------------------------------------
  ( 0 ) || drop  >0     || [TS-I.0>1]   >1  || [TS-I.0>2]   >2  \ Initial State   
  ( 1 ) || drop  >1     || drop         >1  || [TS-I.1>2]   >2  \ Track Section Free State
  ( 2 ) || drop  >2     || [TS-I.2>1]   >1  || drop         >2  \ Track Section Occupied State
;FSM                                                                          


\ ---------------------------------------------------\ 
\ test the machine                                   \ 
\ ---------------------------------------------------\ 
: test ( -- | test the fsm )
    0 >state [TS-I]    \ set initial the state to zero
    begin
      cr ." state=" STATE: [TS-I] . cr
      key dup 13 <> over 10 <> and
    while
      dup
      [TS-I.feed]      \ prepare one event
      [TS-I]           \ execute the state machine
    repeat 
    drop ;

page
S" test the machine:" type cr 
test
cr cr .s bye

