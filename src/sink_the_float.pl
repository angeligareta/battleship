setColumnNumber(NewCN):-
                (retractall(columnNumber(_)) ; true), !,
                asserta(columnNumber(NewCN)).

setShipWidth(NewWidth):-
            (retractall(shipWidth(_)) ; true),
            asserta(shipWidth(NewWidth)).

showSeparator(0, _):- nl.
showSeparator(Acc, Symbol):- Acc >= 0, put(Symbol), Acc1 is Acc-1, showSeparator(Acc1, Symbol).
            
showWelcomeMessage:- write("¡BIENVENIDO A HUNDIR LA FLOTA!"), nl, showSeparator(30, '-').

readDifficulty:- write("Introduce dificultad del juego:  (1 -> Fácil, 2 -> Medio, 3-> Difícil)"), nl,
                 get_char(DFChar), get_char(_), name(DFChar, [DFChar2]), DF is DFChar2 - 48,
                 checkUnderCN(DF),
                 InverseDF is 4-DF,
                 setShipWidth(InverseDF).
                 
initializeAttempts:- shipWidth(DF),
                     columnNumber(CN),
                     ( (DF is 1, AN is CN*CN*0.6, RoundedAN is ceiling(AN), asserta(attemptNumber(RoundedAN))) ; true ),
                     ( (DF is 2, AN is CN*CN*0.4, RoundedAN is ceiling(AN), asserta(attemptNumber(RoundedAN))) ; true ),
                     ( (DF is 3, AN is CN*CN*0.2, RoundedAN is ceiling(AN), asserta(attemptNumber(RoundedAN))) ; true ).

decreaseAttempts:- attemptNumber(AN), AN is 1, false.                   
decreaseAttempts:- attemptNumber(AN), AN > 1,
                   AN1 is AN-1,
                   retractall(attemptNumber(_)),
                   asserta(attemptNumber(AN1)).
                   
increaseAttempts:- attemptNumber(AN),
                   AN1 is AN+1,
                   retractall(attemptNumber(_)),
                   asserta(attemptNumber(AN1)).
                     
showAttempts:- attemptNumber(AN),
               showSeparator(32, 'x'),
               write("Número de aciertos restantes: "), print(AN), nl,
               showSeparator(32, 'x').
            
readColumnNumber:-
            write("Introduce número de columnas:  (Máximo 9)"), nl,
            get_char(CNChar), get_char(_), name(CNChar, [CNChar2]), CN is CNChar2 - 48,
            CN \== 0, 
            (checkUnder(CN, 9), setColumnNumber(CN), showSeparator(41, '-');
            write("Número de columnas erróneo:  (Máximo 9)"), nl, false).
            
            
checkUnder(Number, Limit):- Number =< Limit, Number > 0.
           
checkUnderCN(Number):-
           columnNumber(CN),
           checkUnder(Number, CN).

        
mergeList([], L2, L2).
mergeList([H1|T1], L2, [H1|NewList]):- mergeList(T1, L2, NewList).

initializeBoard(0, []).
initializeBoard(ACC, [❔|T]):-
               ACC \== 0,
               ACC1 is ACC-1,
               initializeBoard(ACC1, T).
               
transform2VectorPosition([XPos,YPos], Pos):- 
                 columnNumber(CN),
                 Pos is (YPos - 1)*CN + XPos.
                 
                 
ifElse(Condition, IF, ELSE, Result):-
      Condition -> Result = IF; Result = ELSE.
      
                 
getRandomNeighbour([RandomPosX, RandomPosY], Neighbour):-
                   columnNumber(CN),
                   
                   LeftElement is RandomPosX-1,
                   (LeftElement < 1; append([], [[LeftElement, RandomPosY]], L1)),
                   (LeftElement >= 1; append([], [], L1)),
                   
                   RightElement is RandomPosX+1,
                   (RightElement > CN; append(L1, [[RightElement, RandomPosY]], L2)),
                   (RightElement =< CN; append(L1, [], L2)),
                   
                   TopElement is RandomPosY-1, 
                   (TopElement < 1; append(L2, [[RandomPosX, TopElement]], L3)),
                   (TopElement >= 1; append(L2, [], L3)),
                   
                   BottomElement is RandomPosY+1,
                   (BottomElement > CN; append(L3, [[RandomPosX, BottomElement]], RandomList)),
                   (BottomElement =< CN; append(L3, [], RandomList)),
                   
                   random_member(Neighbour, RandomList).
                   

getNeighbourInLine([PosX1, PosY1], [PosX2, PosY2], NeighbourInLine):-
                    columnNumber(CN),
                    
                    ( PosX1 is PosX2, % Match the X axis.
                      (PosY1 < PosY2, (PosY2+1 =< CN, Next is PosY2+1, append([[PosX1, Next]], [], L1) ; append([], [], L1)),
                                      (PosY1-1 >= 1 , Before is PosY1-1, append(L1, [[PosX1, Before]], L2) ; append(L1, [], L2))
                      ;
                      PosY1 > PosY2, (PosY1+1 =< CN,  Next is PosY1+1, append([[PosX1, Next]], [], L1) ; append([], [], L1)),
                                      (PosY2-1 >= 1 , Before is PosY2-1, append(L1, [[PosX1, Before]], L2) ; append(L1, [], L2)))
                    ;
                    ( PosY1 is PosY2, % Match the Y axis.
                      (PosX1 < PosX2, (PosX2+1 =< CN, Next is PosX2+1, append([[Next, PosY1]], [], L1) ; append([], [], L1)),
                                      (PosX1-1 >= 1 , Before is PosX1-1, append(L1, [[Before, PosY1]], L2) ; append(L1, [], L2))
                      ;
                      PosX1 > PosX2, (PosX1+1 =< CN,  Next is PosX1+1, append([[Next, PosY1]], [], L1) ; append([], [], L1)),
                                      (PosX2-1 >= 1 , Before is PosX2-1, append(L1, [[Before, PosY1]], L2) ; append(L1, [], L2)))
                    ; append([], [], L2) )
                    ),
                    
                    random_member(NeighbourInLine, L2).
                    
               
initializePositions(Positions):- 
                   columnNumber(CN),
                   random_between(1, CN, RandomPosX),
                   random_between(1, CN, RandomPosY),
                   
                   transform2VectorPosition([RandomPosX, RandomPosY], RandomPos),
                   mergeList([], [RandomPos], ReturnPositions), % Uno el primero
                   shipWidth(Width),
                   (Width is 1, mergeList(ReturnPositions, [], Positions) ; true),
                   
                   (Width is 2, getRandomNeighbour([RandomPosX, RandomPosY], RandomNeighbourPair),
                                transform2VectorPosition(RandomNeighbourPair, RandomNeighbour),
                                mergeList(ReturnPositions, [RandomNeighbour], Positions) ; true),
                   
                   (Width is 3, getRandomNeighbour([RandomPosX, RandomPosY], RandomNeighbourPair),
                                transform2VectorPosition(RandomNeighbourPair, RandomNeighbour),
                                mergeList(ReturnPositions, [RandomNeighbour], PositionsAux),
                                getNeighbourInLine([RandomPosX, RandomPosY], RandomNeighbourPair, NeighbourInLinePair),
                                transform2VectorPosition(NeighbourInLinePair, NeighbourInLine),
                                mergeList(PositionsAux, [NeighbourInLine], Positions) ; true).
                   

play:- showWelcomeMessage,
       readColumnNumber,
       readDifficulty,
       initializeAttempts,
       columnNumber(CN),
       TotalElements is CN * CN,
       initializeBoard(TotalElements, Board), !,
       initializePositions(Positions), !,
       startGame(Board, Positions).

startGame(Board, []):- showBoard(Board), write('¡Hundido!'), nl.
startGame(Board, Positions):- 
        Positions \== [],
        showAttempts,
        showBoard(Board), !, % Neccesary cut or Prolog will redo getPosition to get a new one.
        getPosition(Pos), % We can't pass a empty board because we will have to return it with another value
        updateBoard(Board, Pos, 1, [], NewUpdatedBoard, Positions, NewPositions), !,
        (decreaseAttempts, startGame(NewUpdatedBoard, NewPositions) ; write('¡Has perdido!')).


showBoardAcc([], _).
showBoardAcc([H|T], Acc):- 
            columnNumber(CN), 
            print(H), put(' '),
            ((Acc mod CN) =:= 0) 
            -> nl,
            Row is (Acc/CN) + 1,
            ( (Acc is CN*CN) ; write(' '), write(Row), write('  ') ),
            Acc1 is Acc+1, 
            showBoardAcc(T, Acc1)
            ;
            Acc1 is Acc+1,
            showBoardAcc(T, Acc1).

showTitleBoard(Acc):- columnNumber(CN), Acc is CN*CN, nl.
showTitleBoard(Acc):- 
              columnNumber(CN),
              Acc < CN*CN,
              Column is (Acc/CN) + 1,
              ( \+ (0 is (Acc mod CN)) ; write(Column), put(' ') ),  % \+ == is not
              Acc1 is Acc+1, 
              showTitleBoard(Acc1).

showBoard(Board):- write('F|C '), showTitleBoard(0), write(' 1  '), showBoardAcc(Board, 1).


getPosition(Pos):- % Pos is x+y
        showSeparator(32, '-'),
        columnNumber(CN),
        write("Introduce posición entre 1 y "), print(CN), nl,
        write("Número Fila: "), nl,
        get_char(YPosChar), get_char(_), name(YPosChar, [Y]), YPos is Y - 48,
        write("Número Columna: "), nl,
        get_char(XPosChar), get_char(_), name(XPosChar, [X]), XPos is X - 48, % To cast the char to int, if not YPos would be '2' and failed in comparation.
        checkUnderCN(XPos), checkUnderCN(YPos),
        transform2VectorPosition([XPos,YPos], Pos).

updateBoard([], _, _, ACCBoard, UpdatedBoard, Positions, NewPositions):- UpdatedBoard = ACCBoard, NewPositions = Positions.

% If it's not in the position we remove the head and increase a position.
updateBoard([H|T], Pos, Acc, ACCBoard, UpdatedBoard, Positions, NewPositions):- 
        Acc \== Pos,
        mergeList(ACCBoard, [H], NewACCBoard),
        Acc1 is Acc+1,
        updateBoard(T, Pos, Acc1, NewACCBoard, NewUpdatedBoard, Positions, NewPositions),
        UpdatedBoard = NewUpdatedBoard.
        
% If it's in the position we add the boat.
updateBoard([H|T], Pos, Acc, ACCBoard, UpdatedBoard, Positions, NewPositions):- 
        Acc is Pos,
        memberchk(Pos, Positions) 
        -> % IF
        increaseAttempts,
        write("¡Tocado!"), nl,
        delete(Positions, Pos, UpdatedPositions),
        mergeList(ACCBoard, [🚢], NewACCBoard),
        Acc1 is Acc+1,
        updateBoard(T, Pos, Acc1, NewACCBoard, NewUpdatedBoard, UpdatedPositions, NewPositions),
        UpdatedBoard = NewUpdatedBoard
        ; % ELSE
        ((H \== o); mergeList(ACCBoard, [H], NewACCBoard)), % If is touched, we don't write water.
        ((H = o); mergeList(ACCBoard, [🌊], NewACCBoard)),
        Acc1 is Acc+1,
        updateBoard(T, Pos, Acc1, NewACCBoard, NewUpdatedBoard, Positions, NewPositions),
        UpdatedBoard = NewUpdatedBoard.