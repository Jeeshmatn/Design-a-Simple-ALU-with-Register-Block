module ALU(
input [7:0]A,
input [7:0]B,
input  [2:0] ALU_OP,
output reg [8:0]ALU_Out
    );
    
 always @(*)begin
 
     case(ALU_OP)
     
    3'b000:begin
    ALU_Out= A + B;
    end
    
     3'b001:begin
     ALU_Out= (A - B);
     end
     
     3'b010:begin
     ALU_Out= (A & B);
     end
     
     3'b011:begin
     ALU_Out= (A | B);
    end
    
     3'b100:begin 
    ALU_Out=(A ^ B);
    end
    
     3'b101:begin
    ALU_Out= (A << 1);
    end
    
    
     3'b110: begin
    ALU_Out= A;   
    end
    
    endcase
 end     
endmodule
