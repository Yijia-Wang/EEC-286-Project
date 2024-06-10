module ALU_tb;

    reg [31:0] in1;
    reg [31:0] in2;
    reg [3:0] alu_control;
    wire [31:0] alu_result;
    wire zero_flag;
    reg clk;


    ALU alu (
        .in1(in1), 
        .in2(in2), 
        .alu_control(alu_control), 
        .alu_result(alu_result), 
        .zero_flag(zero_flag)
    );


    always begin
        #5 clk = ~clk;
    end

    task delay_fault(input [31:0] a, input [31:0] b, input [3:0] control);
    begin
        #3 in1 = a;
        #2 in2 = b;
        #1 alu_control = control;
    end
    endtask

    initial begin
        in1 = 0;
        in2 = 0;
        alu_control = 0;

        #20;

        // delay faults
        delay_fault(32'h00000001, 32'h00000001, 4'b0000); // AND operation
        #20;
        delay_fault(32'h00000001, 32'h00000001, 4'b0001); // OR operation
        #20;
        delay_fault(32'h00000001, 32'h00000001, 4'b0010); // ADD operation
        #20;
        delay_fault(32'h00000003, 32'h00000001, 4'b0100); // SUB operation
        #20;
        delay_fault(32'h00000001, 32'h00000002, 4'b1000); // SLT operation
        #20;
        delay_fault(32'h00000001, 32'h00000001, 4'b0011); // SLL operation
        #20;
        delay_fault(32'h00000004, 32'h00000001, 4'b0101); // SRL operation
        #20;
        delay_fault(32'h00000002, 32'h00000003, 4'b0110); // MUL operation
        #20;
        delay_fault(32'h00000001, 32'h00000001, 4'b0111); // XOR operation
        #20;

        $finish;
    end
endmodule
