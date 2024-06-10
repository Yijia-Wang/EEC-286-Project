module CONTROL_tb();

    reg [6:0] funct7;
    reg [2:0] funct3;
    reg [6:0] opcode;
    wire [3:0] alu_control;
    wire regwrite_control;

    CONTROL control (
        .funct7(funct7),
        .funct3(funct3),
        .opcode(opcode),
        .alu_control(alu_control),
        .regwrite_control(regwrite_control)
    );


    // Define a task to inject stuck-at faults
    task inject_stuck_at_fault;
        input [6:0] f7;
        input [2:0] f3;
        input [6:0] op;
        input [3:0] expected_alu;
        input expected_regwrite;
        begin
            funct7 = f7;
            funct3 = f3;
            opcode = op;
            #100; 

            if (alu_control !== expected_alu || regwrite_control !== expected_regwrite) begin
                $display("Fault detected at Time: %0t, funct7: %b, funct3: %b, opcode: %b, Expected ALU Control: %b, Got: %b, Expected RegWrite: %b, Got: %b", 
			 $time, f7, f3, op, expected_alu, alu_control, expected_regwrite, regwrite_control);
            end
            else begin
                $display("Test passed at Time: %0t, funct7: %b, funct3: %b, opcode: %b, ALU Control: %b, RegWrite: %b",
                         $time, f7, f3, op, alu_control, regwrite_control);
            end
        end
    endtask

    initial begin
        funct7 = 7'b0;
        funct3 = 3'b0;
        opcode = 7'b0;

        // Monitor changes
        $monitor("Time: %0t, funct7: %b, funct3: %b, opcode: %b, alu_control: %b, regwrite_control: %b",
                 $time, funct7, funct3, opcode, alu_control, regwrite_control);

        //fault free
        inject_stuck_at_fault(7'b0000000, 3'b000, 7'b0110011, 4'b0010, 1); // ADD
        inject_stuck_at_fault(7'b0100000, 3'b000, 7'b0110011, 4'b0100, 1); // SUB
        inject_stuck_at_fault(7'b0000000, 3'b110, 7'b0110011, 4'b0001, 1); // OR
        inject_stuck_at_fault(7'b0000000, 3'b111, 7'b0110011, 4'b0000, 1); // AND

        // stuck-at-0 fault on funct3[0]
        funct3 = 3'b001;
        #1 funct3[0] = 1'b0;
        inject_stuck_at_fault(7'b0000000, funct3, 7'b0110011, 4'b0011, 1); // SLL (expected failure, it is ADD)

        // stuck-at-1 fault on funct3[0]
        funct3 = 3'b001;
        #1 funct3[0] = 1'b1;
        inject_stuck_at_fault(7'b0000000, funct3, 7'b0110011, 4'b0011, 1); // SLL (expected pass)

        $finish;
    end

endmodule
