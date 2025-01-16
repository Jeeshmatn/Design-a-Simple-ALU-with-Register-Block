module tb;

reg Write_Enable;
reg Reg_Select;
reg [7:0]Data_In;
reg  [2:0] ALU_OP;
wire  [7:0]ALU_Out;
wire  carry;
    
    
top uut(  .Write_Enable(Write_Enable) ,  .Reg_Select(Reg_Select)  , .Data_In(Data_In) ,
          .ALU_OP(ALU_OP) ,  .ALU_Out(ALU_Out) , .carry(carry) );   
    
initial begin

    Write_Enable=1; Reg_Select=0;Data_In=8'd21;ALU_OP=3'b000;
    #10;
    Write_Enable=1; Reg_Select=0;Data_In=8'd32;ALU_OP=3'b001;
    #10;
     Write_Enable=1; Reg_Select=1;Data_In=8'd7;ALU_OP=3'b001;
    #10;
    Write_Enable=1; Reg_Select=1;Data_In=8'd7;ALU_OP=3'b000;
    #10;
    $finish();  
end    

initial begin

    $monitor( " Write_Enable :%0d , Reg_Select :%0d ,Data_In :%0d ,ALU_OP:%0d ,ALU_Out :%0d " ,
    Write_Enable , Reg_Select  ,Data_In  ,ALU_OP  , ALU_Out  );
    
end


endmodule