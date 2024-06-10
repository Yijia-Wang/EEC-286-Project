 `timescale 1ns / 1ps

module INST_MEM_tb;

    reg [31:0] PC;
    reg reset;
    wire [31:0] Instruction_Code;
    
    INST_MEM memory (
        .PC(PC), 
        .reset(reset), 
        .Instruction_Code(Instruction_Code)
    );
    
    task flip_bit;
        input [31:0] addr;
        input [2:0] bit_pos;
        begin
            #1 memory.Memory[addr] = memory.Memory[addr] ^ (1 << bit_pos);
        end
    endtask
    
    initial begin
        PC = 0;
        reset = 0;
        
        reset = 1;
        #10;
        reset = 0;
        
        $display("Checking original instructions:");
        PC = 0; #10 $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        PC = 4; #10 $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        PC = 8; #10 $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        PC = 12; #10 $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        PC = 16; #10 $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        PC = 20; #10 $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        PC = 24; #10 $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        PC = 28; #10 $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        
        $display("Introducing bit flips:");
        
        flip_bit(3, 0);
        PC = 0; #10 $display("After bit flip at Memory[3] bit 0:");
        $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        
        flip_bit(6, 3);
        PC = 4; #10 $display("After bit flip at Memory[6] bit 3:");
        $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        
        flip_bit(9, 5);
        PC = 8; #10 $display("After bit flip at Memory[9] bit 5:");
        $display("PC: %d, Instruction: %h", PC, Instruction_Code);

        flip_bit(14, 7);
        PC = 12; #10 $display("After bit flip at Memory[14] bit 7:");
        $display("PC: %d, Instruction: %h", PC, Instruction_Code);
        
        $finish;
    end
endmodule
