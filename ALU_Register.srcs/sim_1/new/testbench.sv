class transaction;
  bit Write_Enable;
  rand bit Reg_Select;
  rand bit [7:0]Data_In;
  bit  [2:0] ALU_OP;
  bit [8:0]ALU_Out;
  
  
endclass

interface top_if;
  logic Write_Enable;
  logic Reg_Select;
  logic [7:0]Data_In;
  logic [2:0] ALU_OP;
  logic [8:0]ALU_Out;
  
endinterface

class generator;
  transaction trans;
  mailbox #(transaction) mbx;
  event drv_done;    // Event to indicate driver is done
  
  function new(mailbox #(transaction) mbx, event drv_done);
    this.mbx = mbx;
    this.drv_done = drv_done;
    trans = new();
  endfunction
  
  task run();
    trans.Write_Enable = 1;
    trans.ALU_OP = 3'b000;
    for (int i=0; i<10; i++) begin
      trans.randomize();
      mbx.put(trans);
      $display("[GEN] DATA SEND TO DRV Write_Enable :%0d \t Reg_Select :%0d \t \
               Data_In:%0d \t ALU_OP: %0d \t ALU_Out:%0d ", 
               trans.Write_Enable, trans.Reg_Select, trans.Data_In, 
               trans.ALU_OP, trans.ALU_Out);
      @(drv_done);  // Wait for driver to complete
    end
  endtask
endclass

class driver;
  virtual top_if tif;
  transaction data;
  mailbox #(transaction) mbx;
  event drv_done;
  event mon_done;    // Event to indicate monitor can sample
  event sco_done;
  
  function new(mailbox #(transaction) mbx, event drv_done, event mon_done, event sco_done);
    this.mbx = mbx;
    this.drv_done = drv_done;
    this.mon_done = mon_done;
    this.sco_done = sco_done;
  endfunction
  
  task run();
    ->mon_done; // Add initial event trigger before the loop starts
    for (int i=0; i<10; i++) begin
      mbx.get(data);
      tif.Write_Enable = data.Write_Enable;
      tif.Reg_Select = data.Reg_Select;
      tif.Data_In = data.Data_In;
      tif.ALU_OP = data.ALU_OP;
      tif.ALU_Out = data.ALU_Out;
      
      $display("[DRV] DATA RCVD FROM GEN Write_Enable :%0d \t Reg_Select :%0d \t \
               Data_In:%0d \t ALU_OP: %0d \t ALU_Out:%0d ", 
               data.Write_Enable, data.Reg_Select, data.Data_In, 
               data.ALU_OP, data.ALU_Out);
      
      #1; // Small delay to ensure interface signals are stable
      ->mon_done;    // Trigger monitor to sample
      @(sco_done);   // Wait for scoreboard to complete
      ->drv_done;    // Signal generator that driver is done
    end
  endtask
endclass

class monitor;
  transaction trans;
  virtual top_if tif;
  mailbox #(transaction) mbx1;
  event mon_done;
  event sco_done;    // Event to indicate scoreboard is done
  
  function new(mailbox #(transaction) mbx1, event mon_done, event sco_done);
    this.mbx1 = mbx1;
    this.mon_done = mon_done;
    this.sco_done = sco_done;
    trans = new();
  endfunction
  
  task run();
    forever begin // Change to forever loop
      @(mon_done);   // Wait for driver to update interface
      
      trans.Write_Enable = tif.Write_Enable;
      trans.Reg_Select = tif.Reg_Select;
      trans.Data_In = tif.Data_In;
      trans.ALU_OP = tif.ALU_OP;
      trans.ALU_Out = tif.ALU_Out;
      
      mbx1.put(trans);
      $display("[MON] DATA SEND TO SCO Write_Enable :%0d \t Reg_Select :%0d \t \
               Data_In:%0d \t ALU_OP: %0d \t ALU_Out:%0d ", 
               trans.Write_Enable, trans.Reg_Select, trans.Data_In, 
               trans.ALU_OP, trans.ALU_Out);
    end
  endtask
endclass

class scoreboard;
  transaction received_trans;
  mailbox #(transaction) mbx1;
  event sco_done;
  
  function new(mailbox #(transaction) mbx1, event sco_done);
    this.mbx1 = mbx1;
    this.sco_done = sco_done;
  endfunction
  
  task run();
    forever begin
      mbx1.get(received_trans);
      $display("[SCO] DATA RCVD FROM MON Write_Enable :%0d \t Reg_Select :%0d \t \
               Data_In:%0d \t ALU_OP: %0d \t ALU_Out:%0d ", 
               received_trans.Write_Enable, received_trans.Reg_Select, 
               received_trans.Data_In, received_trans.ALU_OP, 
               received_trans.ALU_Out);
      ->sco_done;    // Signal completion
    end
  endtask
endclass

// Testbench module modifications
module tb;
  top_if tif();
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  event drv_done;
  event mon_done;
  event sco_done;
  
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbx1;
  
  top dut(tif.Write_Enable, tif.Reg_Select, tif.Data_In, tif.ALU_OP, tif.ALU_Out);
  
  initial begin
    mbx = new();
    mbx1 = new();
    
    gen = new(mbx, drv_done);
    drv = new(mbx, drv_done, mon_done, sco_done);
    mon = new(mbx1, mon_done, sco_done);
    sco = new(mbx1, sco_done);
    
    drv.tif = tif;
    mon.tif = tif;
  end
  
  initial begin
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_none
    #1000;
    $finish();
  end
endmodule