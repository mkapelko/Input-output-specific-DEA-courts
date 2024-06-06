$OFFSYMXREF OFFSYMLIST

OPTIONS SYSOUT=OFF, SOLPRINT=OFF;
SET I        Index of variables                /1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20/
    K        Index number of firms             /1*1565/
    A        Index outputs                      /1*3/
    V        Index inputs                       /1*7/
    KN(K)                                      /1*1565/


ALIAS(K,KK);
ALIAS (K,KT);

PARAMETERS
DAT(K,I)    Variables from data set
Q(K,A)      Output
X(K,V)      Inputs


DQ(K,A)      Direction outputs
DX(K,V)      Direction inputs

;

$INCLUDE "C:\GAMS PLIKI4\datadirav2024.DAT";


VARIABLES OBJ       Objective
;

Q(K,"1")    = DAT(K,"1");
Q(K,"2")    = DAT(K,"2");
Q(K,"3")    = DAT(K,"3");
X(K,"1")  = DAT(K,"4");
X(K,"2")  = DAT(K,"5");
X(K,"3")  = DAT(K,"6");
X(K,"4")  = DAT(K,"7");
X(K,"5")  = DAT(K,"8");
X(K,"6")  = DAT(K,"9");
X(K,"7")  = DAT(K,"10");







DQ(K,"1")  = DAT(K,"11");
DQ(K,"2")  = DAT(K,"12");
DQ(K,"3")  = DAT(K,"13");
DX(K,"1")  = DAT(K,"14");
DX(K,"2")  = DAT(K,"15");
DX(K,"3")  = DAT(K,"16");
DX(K,"4")  = DAT(K,"17");
DX(K,"5")  = DAT(K,"18");
DX(K,"6")  = DAT(K,"19");
DX(K,"7")  = DAT(K,"20");


POSITIVE VARIABLES
L1(K,KK)         Intensity variables


BETA1(KT)        Output1 technical inefficiency
BETA2(KT)        Output2 technical inefficiency
BETA3(KT)        Output3 technical inefficiency
BETA4(KT)        Input1 technical inefficiency
BETA5(KT)        Input2 technical inefficiency
BETA6(KT)        Input3 technical inefficiency
BETA7(KT)        Input4 technical inefficiency
BETA8(KT)        Input5 technical inefficiency
BETA9(KT)        Input6 technical inefficiency
BETA10(KT)       Input7 technical inefficiency



;

EQUATIONS
    OBJECTIVE      Objective function
    OQ1(K)          Output1 constraint
    OQ2(K)          Output2 constraint
    OQ3(K)          Output3 constraint
    OX1(K)         Input1 constraint
    OX2(K)         Input2 constraint
    OX3(K)         Input3 constraint
    OX4(K)         Input4 constraint
    OX5(K)         Input5 constraint
    OX6(K)         Input6 constraint
    OX7(K)         Input7 constraint



LVAR1(KT)      Intensity variables


;
OBJECTIVE .. OBJ =E= SUM(KT,BETA1(KT)+BETA2(KT) + BETA3(KT)+BETA4(KT)+BETA5(KT) + BETA6(KT)+BETA7(KT)+BETA8(KT) + BETA9(KT)+ BETA10(KT));


OQ1(KT)      .. -Q(KT,"1")  - BETA1(KT)*DQ(KT,"1") + SUM(KN,L1(KT,KN)*Q(KN,"1"))    =G= 0;
OQ2(KT)      .. -Q(KT,"2")  - BETA2(KT)*DQ(KT,"2") + SUM(KN,L1(KT,KN)*Q(KN,"2"))    =G= 0;
OQ3(KT)      .. -Q(KT,"3")  - BETA3(KT)*DQ(KT,"3") + SUM(KN,L1(KT,KN)*Q(KN,"3"))    =G= 0;
OX1(KT)     .. -X(KT,"1")  + BETA4(KT)*DX(KT,"1") + SUM(KN,L1(KT,KN)*X(KN,"1"))   =L= 0;
OX2(KT)     .. -X(KT,"2")  + BETA5(KT)*DX(KT,"2") + SUM(KN,L1(KT,KN)*X(KN,"2"))   =L= 0;
OX3(KT)     .. -X(KT,"3")  + BETA6(KT)*DX(KT,"3") + SUM(KN,L1(KT,KN)*X(KN,"3"))   =L= 0;
OX4(KT)     .. -X(KT,"4") + BETA7(KT)*DX(KT,"4") + SUM(KN,L1(KT,KN)*X(KN,"4"))   =L= 0;
OX5(KT)     .. -X(KT,"5") + BETA8(KT)*DX(KT,"5") + SUM(KN,L1(KT,KN)*X(KN,"5"))   =L= 0;
OX6(KT)     .. -X(KT,"6") + BETA9(KT)*DX(KT,"6") + SUM(KN,L1(KT,KN)*X(KN,"6"))   =L= 0;
OX7(KT)     .. -X(KT,"7")  + BETA10(KT)*DX(KT,"7") + SUM(KN,L1(KT,KN)*X(KN,"7"))   =L= 0;


LVAR1(KT)   .. SUM(KN,L1(KT,KN)) =E= 1;



MODEL BASIC /OBJECTIVE, OQ1, OQ2, OQ3, OX1, OX2,OX3,OX4,OX5,OX6,OX7, LVAR1/;


Solve BASIC maximizing OBJ using LP;


DISPLAY BETA1.L, BETA2.L, BETA3.L, BETA4.L, BETA5.L, BETA6.L, BETA7.L, BETA8.L, BETA9.L, BETA10.L;

FILE RESULTS /'C:\GAMS PLIKI4\resultsdatadirav2024c.PUT'/;


PUT RESULTS;

PUT "  BETA1        BETA2  BETA3 BETA4 BETA5 BETA6 BETA7 BETA8 BETA9 BETA10  "/
LOOP (KT, PUT BETA1.L(KT):15:6 BETA2.L(KT):15:6 BETA3.L(KT):15:6  BETA4.L(KT):15:6 BETA5.L(KT):15:6 BETA6.L(KT):15:6 BETA7.L(KT):15:6 BETA8.L(KT):15:6 BETA9.L(KT):15:6 BETA10.L(KT):15:6 /;);
