OPENQASM 2.0;
include "qelib1.inc";
// HHL for diagonal 2x2 system A=diag(1,2), b=|0>
// clk[0..1]: clock register (QPE), sys[0]: system (b), anc[0]: ancilla
qreg clk[2];
qreg sys[1];
qreg anc[1];
creg c[1];
// b is already |0> (eigenstate of A with eigenvalue 1)
// QPE: encode eigenvalue of A for |0>
h clk[0]; h clk[1];
// Controlled-U: A = diag(1,2); U|0> = e^{2*pi*i*1/2}|0> (eigenvalue 1 -> phase 1/2)
// Controlled-phase for eigenvalue 1: phase = 1/(2*2) = 1/4 per clock step
cu1(3.141592653589793) clk[1],sys[0];
cu1(1.5707963267948966) clk[0],sys[0];
// Inverse QFT on clock
h clk[0];
cu1(-1.5707963267948966) clk[1],clk[0];
h clk[1];
// Ancilla rotation conditioned on eigenvalue: C/lambda
// For clock = |01> (lambda=1): Ry(pi) on ancilla
x clk[0];
cry(3.141592653589793) clk[0],anc[0];
x clk[0];
// For clock = |10> (lambda=2): Ry(pi/2) on ancilla
cry(1.5707963267948966) clk[1],anc[0];
// Inverse QPE (uncompute clock)
h clk[1];
cu1(1.5707963267948966) clk[1],clk[0];
h clk[0];
cu1(-3.141592653589793) clk[1],sys[0];
cu1(-1.5707963267948966) clk[0],sys[0];
// Post-select on ancilla = |1>
measure anc[0] -> c[0];
