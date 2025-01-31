FA
*****LIBRARY*****
.lib	'mm018.l'	tt

*****PARAMETERS*****
.param	vdd=1.8

.param Wmin=220n
.param Lmin=180n

.param t=20p
	
*****2-INPUT NAND GATE*****
.SUBCKT	NAND_2_INPUT a b out 
M1 p1 b 0 0 nmos L=Lmin W='2*Wmin'
M2 out a p1 0 nmos L=Lmin W='2*Wmin'
M3 out a DD DD pmos L=Lmin W='2*Wmin'
M4 out b DD DD pmos L=Lmin W='2*Wmin'
Vsupply	DD	0	vdd
.ENDS NAND_2_INPUT


*****FA*****
.SUBCKT	FA A B Cin S Cout 
X1 A B p1 NAND_2_INPUT 
X2 A p1 p2 NAND_2_INPUT 
X3 B p1 p3 NAND_2_INPUT 
X4 p2 p3 p4 NAND_2_INPUT 
X5 p4 Cin p5 NAND_2_INPUT 
X6 p4 p5 p6 NAND_2_INPUT 
X7 p5 Cin p7 NAND_2_INPUT 
X8 p6 p7 S NAND_2_INPUT
X9 p1 p5 Cout NAND_2_INPUT  
.ENDS FA


*****CIRCUIT*****
X1 A B Cin S Cout FA

	
*****Input for wave form:
*VinA A 0 Pulse 0 vdd 0 t t 13n 26n
VinA A 0 PWL 0ns 0, '30n-t' 0, '30n' vdd
VinB B 0 PWL 0ns 0, '20n-t' 0, '20n' vdd, '40n-t' vdd, '40n' 0
VinCin Cin 0 PWL 0ns 0, '10n-t' 0, '10n' vdd, '50n-t' vdd, '50n' 0

.measure	tran	tdelay1  trig	V(Cin)	td=9n	val='vdd/2'	cross=1
+targ	V(S)	td=9n	val='vdd/2'	cross=1	

.measure	tran	tdelay2  trig	V(A)	td=29n	val='vdd/2'	cross=1
+targ	V(S)	td=29n	val='vdd/2'	cross=1	

.measure	tran	tdelay3  trig	V(Cin)	td=49n	val='vdd/2'	cross=1
+targ	V(S)	td=49n	val='vdd/2'	cross=1	
.option	post=2
.tran 1p 100n

.end
