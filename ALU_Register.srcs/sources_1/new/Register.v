module Register(
input Write_Enable,
input Reg_Select,
input [7:0]Data_In,
output wire [7:0]Reg1_Out,
output wire [7:0]Reg2_Out

    );
    
    
 reg [7:0]reg1 = 0;
 reg [7:0]reg2 = 0;
    
 always @ (*)begin
     if(Write_Enable==1)begin
        if(Reg_Select==0)begin
            reg1=Data_In;
        end
        else begin
            reg2=Data_In;
        end
      end
  end  
    
 assign Reg1_Out=reg1;
 assign Reg2_Out=reg2;
    
endmodule
