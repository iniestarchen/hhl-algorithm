# HHL Algorithm (2×2 Linear System)

> **Category**: simulation &nbsp;|&nbsp; **Difficulty**: advanced &nbsp;|&nbsp; **Qubits**: 4 &nbsp;|&nbsp; **Gates**: 18 &nbsp;|&nbsp; **Depth**: 12

The HHL algorithm solves sparse linear systems Ax=b exponentially faster than classical algorithms in certain regimes. It applies QPE to encode eigenvalues λ, performs a conditional rotation 1/λ on an ancilla, then uncomputes with inverse QPE. Post-selecting ancilla=|1⟩ yields |x⟩ ∝ A⁻¹|b⟩. For A=diag(1,2) with eigenvalues 1 and 2, b=|0⟩ is an eigenstate so x=A⁻¹b=|0⟩. This circuit is a pedagogical 4-qubit simplification.

## Expected Output

Post-select ancilla=1 to obtain |x⟩ ∝ A⁻¹|b⟩

## Circuit

The OpenQASM 2.0 circuit is in [`circuit.qasm`](./circuit.qasm).

```
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
```

## Tags

`hhl` `linear-systems` `quantum-simulation` `exponential-speedup`

## References

- [Harrow, Hassidim, Lloyd (2009). Quantum Algorithm for Linear Systems of Equations. PRL 103, 150502](https://doi.org/10.1103/PhysRevLett.103.150502)

## License

MIT — part of the [OpenQC Algorithm Catalog](https://github.com/openqc-algorithms).
