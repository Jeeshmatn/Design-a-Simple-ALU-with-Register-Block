module top(
input Write_Enable,
input Reg_Select,
input [7:0]Data_In,
input  [2:0] ALU_OP,
output  [7:0]ALU_Out,
output  carry
    );
    
 wire [7:0]Reg1_Out;
 wire [7:0]Reg2_Out;
    
 Register Regmod(  .Write_Enable(Write_Enable) ,  .Reg_Select(Reg_Select)  , .Data_In(Data_In) , .Reg1_Out(Reg1_Out),
 .Reg2_Out(Reg2_Out) );   
 
 ALU ALUmod( .A(Reg1_Out), .B(Reg2_Out),  .ALU_OP(ALU_OP) ,  .ALU_Out(ALU_Out) , .carry(carry)  );
 
  
endmodule
