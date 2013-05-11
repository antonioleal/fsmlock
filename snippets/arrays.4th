\ ---------------------------------------------------\ 
\ Simple arrays                                       \
\ ---------------------------------------------------\


: Array                   \ size -- ; [child] n -- addr ; cell array
  Create                  \ create data word
    cell *                \ calculate size
    Here over erase       \ clear memory
    allot                 \ allocate space
  Does>                   \ run time gives address of data
    Swap cell * +         \ index in
  ;

: 2Array                  \ n1 n2 -- ; [child] n1 n2 -- addr ; 2-D array
  Create                  \ create data word
    Over ,                \ save width for run-time
    cell * *              \ calculate size
    Here over erase       \ clear memory
    allot                 \ reserve n cells
  Does>                   \ run time gives address of data
    Dup @ Rot * Rot + 1+
    cell * +
  ;

: Message-array           \ len mesgs -- ; [child] n -– addr
\ generate an array for mesgs messages of size len
    Create                \ create data word
      Over ,              \ save the size of the array
      *                   \ calculate space needed          
      Here over erase     \ clear memory                              
      allot               \ reserve space for it                    
    Does>                 \ run time gives address of data            
      Dup @               \ get length  
      Rot *               \ calculate offset                        
      +                   \ add to base               
      cell +              \ skip length                   
  ; 

\ ---------------------------------------------------\ 
\ test the example list                              \
\ ---------------------------------------------------\


page 
1000 array bb

: fill-array 40 1 do 10000 I / I bb ! loop ;
: print-array 42 0 do I bb @ . loop ;
fill-array


123 0 bb !
456 1 bb !

\ 0 bb @ . cr
\ 1 bb @ . cr

print-array
cr
cr



: traverse-array-of-addresses
    0
    begin 2dup cell * + @ \ 0<>
    while 2dup cell * + @ . 1+ 
    repeat drop ;
bb traverse-array-of-addresses

cr
.s
bye



\ REQUIRES singlestep
\ [DEBUG
\ word to be debugged
\ DEBUG]
\ bb DEBUG traverse-array-of-addresses
