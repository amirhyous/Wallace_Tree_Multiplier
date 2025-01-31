Multiplier
*****LIBRARY*****
.lib	'mm018.l'	tt

*****PARAMETERS*****
.param	vdd=1.8

.param Wmin=220n
.param Lmin=180n

.param t=20p


*****INVERTER GATE*****
.SUBCKT	INV	Vin	Vout
M1	Vout	Vin	0	0	nmos L=Lmin	W=Wmin
M2	Vout	Vin	DD	DD	pmos L=Lmin	W='2*Wmin'
Vsupply	DD	0	vdd
.ENDS	INV	

*****2-INPUT NAND GATE*****
.SUBCKT	NAND_2_INPUT a b out 
M1 p1 b 0 0 nmos L=Lmin W='2*Wmin'
M2 out a p1 0 nmos L=Lmin W='2*Wmin'
M3 out a DD DD pmos L=Lmin W='2*Wmin'
M4 out b DD DD pmos L=Lmin W='2*Wmin'
Vsupply	DD	0	vdd
.ENDS NAND_2_INPUT

*****2-INPUT AND GATE*****
.SUBCKT	AND_2_INPUT a b out 
M1 p1 b 0 0 nmos L=Lmin W='2*Wmin'
M2 outb a p1 0 nmos L=Lmin W='2*Wmin'
M3 outb a DD DD pmos L=Lmin W='2*Wmin'
M4 outb b DD DD pmos L=Lmin W='2*Wmin'
X1 outb out INV
Vsupply	DD	0	vdd
.ENDS AND_2_INPUT

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

*****HA*****
.SUBCKT	HA A B S Cout 
X1 A B p1 NAND_2_INPUT 
X2 A p1 p2 NAND_2_INPUT 
X3 B p1 p3 NAND_2_INPUT 
X4 p2 p3 p4 NAND_2_INPUT 
X6 p4 DD p6 NAND_2_INPUT 
X8 p6 DD S NAND_2_INPUT
X9 p1 DD Cout NAND_2_INPUT  
Vsupply	DD	0	vdd
.ENDS HA

*****CIRCUIT*****
XP00 a0 b0 p00 AND_2_INPUT
XP01 a1 b0 p01 AND_2_INPUT
XP02 a2 b0 p02 AND_2_INPUT
XP03 a3 b0 p03 AND_2_INPUT
XP10 a0 b1 p10 AND_2_INPUT
XP11 a1 b1 p11 AND_2_INPUT
XP12 a2 b1 p12 AND_2_INPUT
XP13 a3 b1 p13 AND_2_INPUT
XP20 a0 b2 p20 AND_2_INPUT
XP21 a1 b2 p21 AND_2_INPUT
XP22 a2 b2 p22 AND_2_INPUT
XP23 a3 b2 p23 AND_2_INPUT
XP30 a0 b3 p30 AND_2_INPUT
XP31 a1 b3 p31 AND_2_INPUT
XP32 a2 b3 p32 AND_2_INPUT
XP33 a3 b3 p33 AND_2_INPUT

X01 p01 p10 s01 c01 HA
X02 p11 p02 p20 s02 c02 FA
x03 p03 p12 p21 s03 c03 FA
x04 p13 p22 s04 c04 HA

X11 c01 s02 s11 c11 HA
X12 s03 p30 c02 s12 c12 FA
x13 c03 p31 s04 s13 c13 FA
x14 c04 p32 p23 s14 c14 FA

X21 c11 s12 s21 c21 HA
X22 c12 s13 c21 s22 c22 FA
x23 c13 s14 c22 s23 c23 FA
x24 p33 c14 c23 s24 c24 FA


*****Input for wave form:
*VinA A 0 Pulse 0 vdd 0 t t 13n 26n
VinA0 a0 0 PWL 0ns vdd
VinA1 a1 0 PWL 0ns vdd
VinA2 a2 0 PWL 0ns 0, '20n-t' 0, '20n' vdd
VinA3 a3 0 PWL 0ns vdd

VinB0 b0 0 PWL 0ns 0, '40n-t' 0, '40n' vdd
VinB1 b1 0 PWL 0ns vdd
VinB2 b2 0 PWL 0ns 0, '40n-t' 0, '40n' vdd
VinB3 b3 0 PWL 0ns 0, '20n-t' 0, '20n' vdd


.measure	tran	tdelay1	trig	V(a2)	td=19n	val='vdd/2'	cross=1
+targ	V(c24)	td=19n	val='vdd/2'	cross=1	

.measure	tran	tdelay2	trig	V(b0)	td=39n	val='vdd/2'	cross=1
+targ	V(s24)	td=39n	val='vdd/2'	cross=1	

.option	post=2
.tran 1p 100n

.end
