\ linked list 
\
\ ---------------------------------------------------\
\     (c) Copyright 2013 Antonio Leal                \
\ ---------------------------------------------------\

\ ---------------------------------------------------\
\ Code to manage linked lists                        \
\ ---------------------------------------------------\

: NEW-NODE ( val -- a )
        HERE >R 
          , \ VALUE 
        0 , \ POINTER TO NEXT 
        R> ; 

: NODE-VAL     ( a -- v  ) @ ; 
: NODE-NEXT    ( a -- nn ) CELL+ @ ; 
: NODE-NEXT-SET ( nn a -- ) CELL+ ! ; 

: ADD-NODE ( nn l -- l' ) 
        DUP @ 0= IF \ empty list 
                ! 
        ELSE \ non empty list 
                2DUP @ SWAP NODE-NEXT-SET 
                ! 
        THEN ; 

: NODE-FIND-LAST ( a -- a' ) \ precond: a non zero 
        BEGIN DUP NODE-NEXT DUP WHILE NIP REPEAT DROP ; 

: ADD-AFTER-NODE ( nn l -- l' ) 
        DUP @ 0= IF \ empty list 
                ! 
        ELSE \ non empty list 
                @ NODE-FIND-LAST NODE-NEXT-SET 
        THEN ; 

: SHOW-LIST ( a -- ) 
        @ DUP 0= IF \ empty list 
                DROP 
                ." {}" 
        ELSE \ non empty list 
                ." { " 
                BEGIN DUP NODE-VAL . NODE-NEXT DUP 0= UNTIL DROP 
                ." }" 
        THEN ; 

: IS-LIST-EMPTY? ( a -- f ) @ 0= ;
    
: CLEAR-LIST ( a -- ) 0 swap ! ;
    
\ ---------------------------------------------------\ 
\ test the example list                              \
\ ---------------------------------------------------\

variable a \ the example list 

page 
\ .( Linked list example ) cr cr 
\ 
\ .( Add to front of list ) cr 
\ 0 a ! \ empty list 
\ a SHOW-LIST cr 
\ 
\ : test1 ( -- ) 10 0 do 
\                 \ 100 random 1+ NEW-NODE \ some random value 0..99 
\                 i NEW-NODE \ some random value 0..99 
\                 a ADD-NODE \ add it to the list 
\                 a SHOW-LIST cr \ lets see the list 
\         loop ; test1 
\ 
\ cr .( Add end of list ) cr 
\ 0 a ! \ empty list 
\ a SHOW-LIST cr 
\ 
\ : test2 ( -- ) 10 0 do 
\                 \ 100 random 1+ NEW-NODE 
\                 i NEW-NODE 
\                 a ADD-AFTER-NODE 
\                 a SHOW-LIST cr 
\         loop ; test2 

\ 0 a ! \ empty list 


\ a CLEAR-LIST


S" Is the list empty? -> " type a IS-LIST-EMPTY? . cr
a SHOW-LIST cr cr

S" Adding some nodes" type cr
10 NEW-NODE a ADD-AFTER-NODE
13 NEW-NODE a ADD-AFTER-NODE
1 NEW-NODE a ADD-AFTER-NODE
1033 NEW-NODE a ADD-AFTER-NODE
a SHOW-LIST cr cr

: iterate ( -- )
        a @ BEGIN DUP NODE-VAL . cr NODE-NEXT DUP 0= UNTIL DROP ;
iterate

cr
S" Is the list empty? -> " type a IS-LIST-EMPTY? . cr

.( The end. ) cr cr 
.s bye

