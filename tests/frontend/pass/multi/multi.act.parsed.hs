Main [Contract (Definition (AlexPn 15 1 16) "A" constructor() [] (Creates [AssignVal (StorageVar (AlexPn 58 5 9) uint256 "x") (IntLit (AlexPn 63 5 14) 0)]) [] []) [],Contract (Definition (AlexPn 81 7 16) "B" constructor() [] (Creates [AssignVal (StorageVar (AlexPn 124 11 9) uint256 "y") (IntLit (AlexPn 129 11 14) 0),AssignVal (StorageVar (AlexPn 136 12 6) A "a") (ECreate (AlexPn 148 12 18) "A" [])]) [] []) [Transition (AlexPn 153 14 1) "remote" "B" remote(uint256 z) [Iff (AlexPn 201 17 1) [EEq (AlexPn 218 18 14) (EnvExp (AlexPn 208 18 4) Callvalue) (IntLit (AlexPn 221 18 17) 0)]] (Direct (Post [Rewrite (EField (AlexPn 236 21 5) (EVar (AlexPn 235 21 4) "a") "x") (EUTEntry (EVar (AlexPn 242 21 11) "z"))] Nothing)) [],Transition (AlexPn 245 23 1) "multi" "B" multi(uint256 z) [Iff (AlexPn 291 26 1) [EEq (AlexPn 308 27 14) (EnvExp (AlexPn 298 27 4) Callvalue) (IntLit (AlexPn 311 27 17) 0)]] (Direct (Post [Rewrite (EVar (AlexPn 325 30 4) "y") (IntLit (AlexPn 330 30 9) 1),Rewrite (EField (AlexPn 336 31 5) (EVar (AlexPn 335 31 4) "a") "x") (EUTEntry (EVar (AlexPn 342 31 11) "z"))] Nothing)) []]]
