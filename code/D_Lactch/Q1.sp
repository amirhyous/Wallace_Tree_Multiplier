D-Latch
*****LIBRARY*****
.lib	'mm018.l'	tt

*****PARAMETERS*****
.param	vdd=1.8

.param Wmin=220n
.param Lmin=180n

.param t=20p
.param tsu=0p
.param th=80p


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

*****D-LATCH*****
.SUBCKT	D_LATCH D E Q Qb 
X1 D Db0 INV
X2 D E p1 NAND_2_INPUT
X3 E Db0 p2 NAND_2_INPUT
X4 p1 Qb Q NAND_2_INPUT
X5 Q p2 Qb NAND_2_INPUT
.ENDS D_LATCH

*****CIRCUIT*****
X1 D clkb Q Qb D_LATCH 
X2 clk clkb INV
	
*****Input for wave form:
Vx clk 0 Pulse 0 vdd 0 t t 5n 10n
VinD D 0 Pulse 0 vdd 0 t t 13n 26n

*****Input for t-setup:
*Vx clk 0 Pulse 0 vdd 0 t t 5n 10n
*VinD D 0 PWL 0ns 0, '35n-t-tsu' 0, '35n-tsu' vdd, '35' vdd


*****Input for t-hold:
*Vx clk 0 Pulse vdd 0 0 t t 5n 10n
*VinD D 0 PWL 0ns 0, '35n-t' 0, 35n vdd, '35n+th-t' vdd, '35n+th' 0 


.option	post=2
.tran 1p 200n

.end
