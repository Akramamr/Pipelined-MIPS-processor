module alu (input      [31:0] a, b,
            input      [4:0]  shamt,
            input      [3:0]  alucontrol,
            output reg [31:0] result,
            output            zero,
            output            overflow);

  wire [31:0] sum  = a + b;
  wire [31:0] diff = a - b;

  always @(*)
    case (alucontrol)
      4'b0000: result = a & b;
      4'b0001: result = a | b;
      4'b0010: result = sum;
      4'b0011: result = a ^ b;
      4'b0100: result = ~(a | b);
      4'b0101: result = {31'b0, a < b};                    // SLTU
      4'b0110: result = diff;
      4'b0111: result = {31'b0, $signed(a) < $signed(b)};  // SLT
      4'b1000: result = b << shamt;                        // SLL
      4'b1001: result = b >> shamt;                        // SRL
      4'b1010: result = $signed(b) >>> shamt;              // SRA
      4'b1011: result = b << a[4:0];                       // SLLV
      4'b1100: result = b >> a[4:0];                       // SRLV
      4'b1101: result = $signed(b) >>> a[4:0];             // SRAV
      4'b1110: result = {b[15:0], 16'b0};                  // LUI
      default: result = 32'bx;
    endcase

  assign zero = (result == 32'b0);

  assign overflow = (alucontrol == 4'b0010) ? (~(a[31] ^ b[31]) & (a[31] ^ sum[31]))
                  : (alucontrol == 4'b0110) ? ( (a[31] ^ b[31]) & (a[31] ^ diff[31]))
                  : 1'b0;
endmodule