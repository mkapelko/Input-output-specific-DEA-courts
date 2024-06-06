$OFFSYMXREF OFFSYMLIST
OPTIONS SYSOUT=OFF, SOLPRINT=OFF;

SET I           Index variables data set            /1*10/
    T           INDEX number of firms               /1*1565/
    A           Index all inputs                    /1*7/
    B           Index all outputs                   /1*3/
    FT1(T)      INDEX year t                        /1*1565/
    TN1(T)                                          /1*1565/
    TELLER1     INDEX                               /1*1565/

ALIAS(T,FT);

PARAMETERS
    DAT(T,I)    Variables from data set
    Q(T,B)        Output
    X(T,A)      Inputs
    GX(T,A)     Directional distance vector for inputs
    GY(T,B)     Directional distance vector for outputs
    TELLER
    DC11(T,A)   D value constant returns 1 firms and 1 technology
    DV11(T,A)   D value variable returns 1 firms and 1 technology
    DCO11(T,B)   D value constant returns 1 firms and 1 technology
    DVO11(T,B)   D value variable returns 1 firms and 1 technology

;
$INCLUDE "C:\GAMS PLIKI4\regionalloadwccallyears.DAT";

VARIABLES OBJ       Objective
;

Q(T,"1")      = DAT(T,"1");
Q(T,"2")      = DAT(T,"2");
Q(T,"3")      = DAT(T,"3");
X(T,"1")      = DAT(T,"4");
X(T,"2")      = DAT(T,"5");
X(T,"3")      = DAT(T,"6");
X(T,"4")      = DAT(T,"7");
X(T,"5")      = DAT(T,"8");
X(T,"6")      = DAT(T,"9");
X(T,"7")      = DAT(T,"10");
GX(T,A)       = X(T,A);
GY(T,B)       = Q(T,B);

POSITIVE VARIABLES
          THETA1(FT1,A) period 1 firms and period 1 technology
          THETA2(FT1,B) period 1 firms and period 1 technology
          L(T,FT)      Weight lambda
;

EQUATIONS
    OBJECTIVE11       Objective function
    OC11(FT1,B)       Output constraint
    OV11(FT1,A)       Input constraint
    LVAR11(FT1)       Lambda constraint

;


*PERIOD 1 FIRMS AND PERIOD 1 TECHNOLOGY
OBJECTIVE11(FT1) $(ORD(FT1)=TELLER) .. OBJ =E= SUM(A,THETA1(FT1,A))+SUM(B,THETA2(FT1,B));
OC11(FT1,B)   $(ORD(FT1)=TELLER)   .. Q(FT1,B) - SUM(TN1,L(FT1,TN1)*Q(TN1,B)) +THETA2(FT1,B)*GY(FT1,B) =L= 0;
OV11(FT1,A) $(ORD(FT1)=TELLER)  .. -X(FT1,A) + THETA1(FT1,A)*GX(FT1,A) + SUM(TN1,L(FT1,TN1)*X(TN1,A))  =L= 0;
LVAR11(FT1) $(ORD(FT1)=TELLER) .. SUM(TN1,L(FT1,TN1)) =E= 1;


MODEL dyna11 /OBJECTIVE11, OC11, OV11/;

Loop(TELLER1,
TELLER = ORD(TELLER1);
Solve dyna11 maximizing OBJ using LP;

);

DC11(FT1,A) = THETA1.L(FT1,A);
DCO11(FT1,B) = THETA2.L(FT1,B);
MODEL dynavrs11 /OBJECTIVE11, OC11, OV11, LVAR11/;


Loop(TELLER1,
TELLER = ORD(TELLER1);
Solve dynavrs11 maximizing OBJ using LP;

);

DV11(FT1,A) = THETA1.L(FT1,A);
DVO11(FT1,B) = THETA2.L(FT1,B);


FILE RESULTS1 /'C:\GAMS PLIKI4\resultsregionalloadwccallyearsinput.dat'/;
PUT RESULTS1;
PUT "  DC11_1    DC11_2    DC11_3  DC11_4    DC11_5    DC11_6   DC11_7      DV11_1    DV11_2    DV11_3 DV11_4    DV11_5    DV11_6  DV11_7      "/
LOOP (FT1, PUT DC11(FT1,"1"):10:6 DC11(FT1,"2"):10:6 DC11(FT1,"3"):10:6 DC11(FT1,"4"):10:6 DC11(FT1,"5"):10:6 DC11(FT1,"6"):10:6 DC11(FT1,"7"):10:6  DV11(FT1,"1"):10:6 DV11(FT1,"2"):10:6 DV11(FT1,"3"):10:6 DV11(FT1,"4"):10:6 DV11(FT1,"5"):10:6 DV11(FT1,"6"):10:6 DV11(FT1,"7"):10:6 /;);


FILE RESULTS2 /'C:\GAMS PLIKI4\resultsregionalloadwccallyearsoutput.dat'/;
PUT RESULTS2;
PUT "  DCO11_1    DCO11_2    DCO11_3    DVO11_1    DVO11_2    DVO11_3"/
LOOP (FT1, PUT DCO11(FT1,"1"):10:6 DCO11(FT1,"2"):10:6 DCO11(FT1,"3"):10:6 DVO11(FT1,"1"):10:6  DVO11(FT1,"2"):10:6  DVO11(FT1,"3"):10:6/;);
