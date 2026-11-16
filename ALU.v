// 32-bit MIPS ALU. a = rs, b = rt/immediate, shamt = instr[10:6]
module alu (input      [31:0] a, b,
            input      [4:0]  shamt,
            input      [3:0]  alucontrol,
            output reg [31:0] result,
            output            zero,
            output            sign,
            output            overflow);

  wire [31:0] sum  = a + b;
  wire [31:0] diff = a - b;

  always @(*)
    case (alucontrol)
      4'b0000: result = a & b;                                         // AND
      4'b0001: result = a | b;                                         // OR
      4'b0010: result = sum;                                           // ADD (also lw/sw address)
      4'b0011: result = a ^ b;                                         // XOR
      4'b0100: result = ~(a | b);                                      // NOR
      4'b0101: result = {31'b0, a < b};                                // SLTU: unsigned a < b -> 0/1
      4'b0110: result = diff;                                          // SUB (beq uses this)
      4'b0111: result = {31'b0, (a[31] != b[31]) ? a[31] : (a < b)};  // SLT: signed a < b -> 0/1
      4'b1000: result = b << shamt;                                    // SLL: shift left, fill 0
      4'b1001: result = b >> shamt;                                    // SRL: shift right, fill 0
      4'b1010: result = ({{32{b[31]}}, b} >> shamt);                   // SRA: shift right, fill sign bit
      4'b1011: result = b << a[4:0];                                   // SLLV: amount from rs
      4'b1100: result = b >> a[4:0];                                   // SRLV
      4'b1101: result = ({{32{b[31]}}, b} >> a[4:0]);                  // SRAV
      4'b1110: result = {b[15:0], 16'b0};                              // LUI: immediate to upper half
      default: result = 32'bx;
    endcase

  assign zero = (result == 32'b0);   // result is all zeros (beq: a - b == 0)
  assign sign = result[31];          // result is negative

  // signed overflow, ADD/SUB only
  assign overflow = (alucontrol == 4'b0010) ? (~(a[31] ^ b[31]) & (a[31] ^ sum[31]))   // same-sign inputs, different-sign result
                  : (alucontrol == 4'b0110) ? ( (a[31] ^ b[31]) & (a[31] ^ diff[31]))  // different-sign inputs, result sign != a
                  : 1'b0;
endmodule
