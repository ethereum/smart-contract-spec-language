[Transition "frob" "Vat" frob(bytes32 i, address u, address v, address w, int256 dink, int256 dart) [IffIn (AlexPn 546 20 1) uint256 [EntryExp (AlexPn 572 22 5) "urns" [EntryExp (AlexPn 577 22 10) "i" [],EntryExp (AlexPn 580 22 13) "u" [],EAdd (AlexPn 587 22 20) (EntryExp (AlexPn 583 22 16) "ink" []) (EntryExp (AlexPn 589 22 22) "dink" [])],EntryExp (AlexPn 598 23 5) "urns" [EntryExp (AlexPn 603 23 10) "i" [],EntryExp (AlexPn 606 23 13) "u" [],EAdd (AlexPn 613 23 20) (EntryExp (AlexPn 609 23 16) "art" []) (EntryExp (AlexPn 615 23 22) "dart" [])],EntryExp (AlexPn 624 24 5) "ilks" [EntryExp (AlexPn 629 24 10) "i" [],EAdd (AlexPn 639 24 20) (EntryExp (AlexPn 632 24 13) "Art" []) (EntryExp (AlexPn 641 24 22) "dart" [])],EMul (AlexPn 671 25 26) (EntryExp (AlexPn 651 25 6) "ilks" [EntryExp (AlexPn 656 25 11) "i" [],EAdd (AlexPn 663 25 18) (EntryExp (AlexPn 659 25 14) "Art" []) (EntryExp (AlexPn 665 25 20) "dart" [])]) (EntryExp (AlexPn 673 25 28) "ilks" [EntryExp (AlexPn 678 25 33) "i" [],EntryExp (AlexPn 681 25 36) "rate" []]),EAdd (AlexPn 697 26 12) (EntryExp (AlexPn 690 26 5) "dai" [EntryExp (AlexPn 694 26 9) "w" []]) (EntryExp (AlexPn 700 26 15) "ilks" [EntryExp (AlexPn 705 26 20) "i" [],EMul (AlexPn 713 26 28) (EntryExp (AlexPn 708 26 23) "rate" []) (EntryExp (AlexPn 715 26 30) "dart" [])]),EAdd (AlexPn 730 27 10) (EntryExp (AlexPn 725 27 5) "debt" []) (EntryExp (AlexPn 733 27 13) "ilks" [EntryExp (AlexPn 738 27 18) "i" [],EMul (AlexPn 746 27 26) (EntryExp (AlexPn 741 27 21) "rate" []) (EntryExp (AlexPn 748 27 28) "dart" [])])],IffIn (AlexPn 755 29 1) int256 [EntryExp (AlexPn 780 31 5) "ilks" [EntryExp (AlexPn 785 31 10) "i" [],EntryExp (AlexPn 788 31 13) "rate" []],EntryExp (AlexPn 797 32 5) "ilks" [EntryExp (AlexPn 802 32 10) "i" [],EMul (AlexPn 810 32 18) (EntryExp (AlexPn 805 32 13) "rate" []) (EntryExp (AlexPn 812 32 20) "dart" [])]],Iff (AlexPn 818 34 1) [EEq (AlexPn 836 35 15) (EnvExp (AlexPn 826 35 5) Callvalue) (IntLit (AlexPn 839 35 18) 0),EEq (AlexPn 850 36 10) (EntryExp (AlexPn 845 36 5) "live" []) (IntLit (AlexPn 853 36 13) 1),EntryExp (AlexPn 859 37 5) "ilks" [EntryExp (AlexPn 864 37 10) "i" [],ENeq (AlexPn 872 37 18) (EntryExp (AlexPn 867 37 13) "rate" []) (IntLit (AlexPn 876 37 22) 0)],EOr (AlexPn 892 38 15) (ELEQ (AlexPn 887 38 10) (EntryExp (AlexPn 882 38 5) "dart" []) (IntLit (AlexPn 890 38 13) 0)) (EMul (AlexPn 917 38 40) (EntryExp (AlexPn 897 38 20) "ilks" [EntryExp (AlexPn 902 38 25) "i" [],EAdd (AlexPn 909 38 32) (EntryExp (AlexPn 905 38 28) "art" []) (EntryExp (AlexPn 911 38 34) "dart" [])]) (EntryExp (AlexPn 919 38 42) "ilks" [EntryExp (AlexPn 924 38 47) "i" [],ELEQ (AlexPn 932 38 55) (EntryExp (AlexPn 927 38 50) "rate" []) (EntryExp (AlexPn 935 38 58) "ilks" [EntryExp (AlexPn 940 38 63) "i" [],EAnd (AlexPn 948 38 71) (EntryExp (AlexPn 943 38 66) "line" []) (EAdd (AlexPn 957 38 80) (EntryExp (AlexPn 952 38 75) "debt" []) (EntryExp (AlexPn 959 38 82) "ilks" [EntryExp (AlexPn 964 38 87) "i" [],ELEQ (AlexPn 979 38 102) (EMul (AlexPn 972 38 95) (EntryExp (AlexPn 967 38 90) "rate" []) (EntryExp (AlexPn 974 38 97) "dart" [])) (EntryExp (AlexPn 982 38 105) "line" [])]))])])),EOr (AlexPn 1004 39 17) (ELEQ (AlexPn 998 39 11) (EntryExp (AlexPn 993 39 6) "dart" []) (IntLit (AlexPn 1001 39 14) 0)) (EAnd (AlexPn 1062 39 75) (EMul (AlexPn 1030 39 43) (EntryExp (AlexPn 1010 39 23) "ilks" [EntryExp (AlexPn 1015 39 28) "i" [],EAdd (AlexPn 1022 39 35) (EntryExp (AlexPn 1018 39 31) "Art" []) (EntryExp (AlexPn 1024 39 37) "dart" [])]) (EntryExp (AlexPn 1032 39 45) "ilks" [EntryExp (AlexPn 1037 39 50) "i" [],ELEQ (AlexPn 1045 39 58) (EntryExp (AlexPn 1040 39 53) "rate" []) (EntryExp (AlexPn 1048 39 61) "ilks" [EntryExp (AlexPn 1053 39 66) "i" [],EntryExp (AlexPn 1056 39 69) "line" []])])) (ELEQ (AlexPn 1096 39 109) (EAdd (AlexPn 1073 39 86) (EntryExp (AlexPn 1068 39 81) "debt" []) (EntryExp (AlexPn 1075 39 88) "ilks" [EntryExp (AlexPn 1080 39 93) "i" [],EMul (AlexPn 1088 39 101) (EntryExp (AlexPn 1083 39 96) "rate" []) (EntryExp (AlexPn 1090 39 103) "dart" [])])) (EntryExp (AlexPn 1099 39 112) "line" []))),EOr (AlexPn 1136 40 31) (EAnd (AlexPn 1121 40 16) (ELEQ (AlexPn 1116 40 11) (EntryExp (AlexPn 1111 40 6) "dart" []) (IntLit (AlexPn 1119 40 14) 0)) (EGEQ (AlexPn 1130 40 25) (EntryExp (AlexPn 1125 40 20) "dink" []) (IntLit (AlexPn 1133 40 28) 0))) (ELEQ (AlexPn 1181 40 76) (EMul (AlexPn 1165 40 60) (EntryExp (AlexPn 1142 40 37) "urns" [EntryExp (AlexPn 1147 40 42) "i" [],EntryExp (AlexPn 1150 40 45) "u" [],EAdd (AlexPn 1157 40 52) (EntryExp (AlexPn 1153 40 48) "art" []) (EntryExp (AlexPn 1159 40 54) "dart" [])]) (EntryExp (AlexPn 1167 40 62) "ilks" [EntryExp (AlexPn 1172 40 67) "i" [],EntryExp (AlexPn 1175 40 70) "rate" []])) (EMul (AlexPn 1209 40 104) (EntryExp (AlexPn 1186 40 81) "urns" [EntryExp (AlexPn 1191 40 86) "i" [],EntryExp (AlexPn 1194 40 89) "u" [],EAdd (AlexPn 1201 40 96) (EntryExp (AlexPn 1197 40 92) "ink" []) (EntryExp (AlexPn 1203 40 98) "dink" [])]) (EntryExp (AlexPn 1211 40 106) "ilks" [EntryExp (AlexPn 1216 40 111) "i" [],EntryExp (AlexPn 1219 40 114) "spot" []]))),EOr (AlexPn 1256 41 31) (EAnd (AlexPn 1241 41 16) (ELEQ (AlexPn 1236 41 11) (EntryExp (AlexPn 1231 41 6) "dart" []) (IntLit (AlexPn 1239 41 14) 0)) (EGEQ (AlexPn 1250 41 25) (EntryExp (AlexPn 1245 41 20) "dink" []) (IntLit (AlexPn 1253 41 28) 0))) (EOr (AlexPn 1272 41 47) (EEq (AlexPn 1262 41 37) (EntryExp (AlexPn 1260 41 35) "u" []) (EnvExp (AlexPn 1265 41 40) Caller)) (EEq (AlexPn 1290 41 65) (EntryExp (AlexPn 1275 41 50) "can" [EntryExp (AlexPn 1279 41 54) "u" [],EnvExp (AlexPn 1282 41 57) Caller]) (IntLit (AlexPn 1293 41 68) 1))),EOr (AlexPn 1313 43 17) (ELEQ (AlexPn 1307 43 11) (EntryExp (AlexPn 1302 43 6) "dink" []) (IntLit (AlexPn 1310 43 14) 0)) (EOr (AlexPn 1329 43 33) (EEq (AlexPn 1319 43 23) (EntryExp (AlexPn 1317 43 21) "v" []) (EnvExp (AlexPn 1322 43 26) Caller)) (EEq (AlexPn 1347 43 51) (EntryExp (AlexPn 1332 43 36) "Can" [EntryExp (AlexPn 1336 43 40) "v" [],EnvExp (AlexPn 1339 43 43) Caller]) (IntLit (AlexPn 1350 43 54) 1))),EOr (AlexPn 1369 44 17) (EGEQ (AlexPn 1363 44 11) (EntryExp (AlexPn 1358 44 6) "dart" []) (IntLit (AlexPn 1366 44 14) 0)) (EOr (AlexPn 1385 44 33) (EEq (AlexPn 1375 44 23) (EntryExp (AlexPn 1373 44 21) "w" []) (EnvExp (AlexPn 1378 44 26) Caller)) (EEq (AlexPn 1403 44 51) (EntryExp (AlexPn 1388 44 36) "Can" [EntryExp (AlexPn 1392 44 40) "w" [],EnvExp (AlexPn 1395 44 43) Caller]) (IntLit (AlexPn 1406 44 54) 1)))]] (Direct (Post (Just [Constant (Entry (AlexPn 1423 48 5) "urns" [EntryExp (AlexPn 1428 48 10) "i" [],EntryExp (AlexPn 1431 48 13) "u" [],EImpl (AlexPn 1438 48 20) (EntryExp (AlexPn 1434 48 16) "ink" []) (EntryExp (AlexPn 1441 48 23) "urns" [EntryExp (AlexPn 1446 48 28) "i" [],EntryExp (AlexPn 1449 48 31) "u" [],EAdd (AlexPn 1456 48 38) (EntryExp (AlexPn 1452 48 34) "ink" []) (EntryExp (AlexPn 1458 48 40) "dink" [])])]),Constant (Entry (AlexPn 1467 49 5) "urns" [EntryExp (AlexPn 1472 49 10) "i" [],EntryExp (AlexPn 1475 49 13) "u" [],EImpl (AlexPn 1482 49 20) (EntryExp (AlexPn 1478 49 16) "art" []) (EntryExp (AlexPn 1485 49 23) "urns" [EntryExp (AlexPn 1490 49 28) "i" [],EntryExp (AlexPn 1493 49 31) "u" [],EAdd (AlexPn 1500 49 38) (EntryExp (AlexPn 1496 49 34) "art" []) (EntryExp (AlexPn 1502 49 40) "dart" [])])]),Constant (Entry (AlexPn 1511 50 5) "ilks" [EntryExp (AlexPn 1516 50 10) "i" [],EImpl (AlexPn 1526 50 20) (EntryExp (AlexPn 1519 50 13) "Art" []) (EntryExp (AlexPn 1529 50 23) "ilks" [EntryExp (AlexPn 1534 50 28) "i" [],EAdd (AlexPn 1541 50 35) (EntryExp (AlexPn 1537 50 31) "Art" []) (EntryExp (AlexPn 1543 50 37) "dart" [])])]),Rewrite (Entry (AlexPn 1552 51 5) "gem" [EntryExp (AlexPn 1556 51 9) "i" [],EntryExp (AlexPn 1559 51 12) "v" []]) (ESub (AlexPn 1582 51 35) (EntryExp (AlexPn 1570 51 23) "gem" [EntryExp (AlexPn 1574 51 27) "i" [],EntryExp (AlexPn 1577 51 30) "v" []]) (EntryExp (AlexPn 1584 51 37) "dink" [])),Rewrite (Entry (AlexPn 1593 52 5) "dai" [EntryExp (AlexPn 1597 52 9) "w" []]) (EAdd (AlexPn 1618 52 30) (EntryExp (AlexPn 1611 52 23) "dai" [EntryExp (AlexPn 1615 52 27) "w" []]) (EntryExp (AlexPn 1620 52 32) "ilks" [EntryExp (AlexPn 1625 52 37) "i" [],EMul (AlexPn 1633 52 45) (EntryExp (AlexPn 1628 52 40) "rate" []) (EntryExp (AlexPn 1635 52 47) "dart" [])])),Rewrite (Entry (AlexPn 1644 53 5) "debt" []) (EAdd (AlexPn 1669 53 30) (EntryExp (AlexPn 1662 53 23) "debt" []) (EntryExp (AlexPn 1671 53 32) "ilks" [EntryExp (AlexPn 1676 53 37) "i" [],EMul (AlexPn 1684 53 45) (EntryExp (AlexPn 1679 53 40) "rate" []) (EntryExp (AlexPn 1686 53 47) "dart" [])]))]) [] Nothing)) Nothing]
