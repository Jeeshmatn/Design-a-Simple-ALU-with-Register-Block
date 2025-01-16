# Design-a-Simple-ALU-with-Register-Block
Design a Simple ALU with Register Block
Specifications:
	1. ALU Block:
		○ Accepts two 8-bit inputs (A and B) and a 3-bit control signal (ALU_OP).
		○ Performs the following operations based on ALU_OP:
			§ 000: Addition (A + B)
			§ 001: Subtraction (A - B)
			§ 010: AND operation (A & B)
			§ 011: OR operation (A | B)
			§ 100: XOR operation (A ^ B)
			§ 101: Logical left shift of A by 1 (A << 1)
			§ 110: Logical right shift of A by 1 (A >> 1)
			§ 111: Pass-through A (Out = A).
		○ Outputs an 8-bit result (ALU_Out) and a 1-bit carry/borrow (Carry).
	2. Register Block:
		○ Contains two 8-bit registers (Reg1 and Reg2).
		○ Inputs:
			§ Write_Enable: A 1-bit signal to enable writing to the registers.
			§ Reg_Select: A 1-bit signal to select which register to write (0 for Reg1, 1 for Reg2).
			§ Data_In: 8-bit data to be written into the selected register.
		○ Outputs:
			§ Reg1_Out: Current value of Reg1.
			§ Reg2_Out: Current value of Reg2.
	3. Top-Level Module:
		○ Instantiates the ALU block and the Register block.
		○ Connects outputs of the register block (Reg1_Out, Reg2_Out) as inputs to the ALU (A, B).
		○ Includes control signals to test all operations.
Additional Details:
	• Use behavioral modeling for the ALU logic and the register write operation.
	• Simulate the design to verify:
		○ Data can be written to and read from the registers correctly.
		○ ALU performs all specified operations as expected.
![image](https://github.com/user-attachments/assets/b01c0c64-be06-4efc-b72d-42d206306ff4)

