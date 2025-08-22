`include "uvm_macros.svh"
`include "interface.sv"
`include "alu.v"
//`include "alu_pkg.sv"

import uvm_pkg ::*;
import alu_pkg ::*;

module top;

        bit clk, reset, ce;

        always #10 clk = ~clk;

        alu_interface intf(clk, reset, ce);

        ALU_DESIGN dut(.CLK(clk),
                .RST(reset),
                .OPA(intf.opa),
                .OPB(intf.opb),
                .CIN(intf.cin),
                .CE(ce),
                .INP_VALID(intf.inp_valid),
                .MODE(intf.mode),
                .CMD(intf.cmd),
                .RES(intf.res),
                .COUT(intf.cout),
                .OFLOW(intf.oflow),
                .E(intf.e),
                .G(intf.g),
                .L(intf.l),
                .ERR(intf.err));

        initial  begin
                uvm_config_db #(virtual alu_interface)::set(null, "*", "vif", intf);
        end

        initial begin
                run_test("alu_test");
        end

        initial begin
                clk = 0;
                reset = 0;
                #5;
                ce = 0;
                reset = 1;
                #10;
                ce = 1;
                #20;
                reset = 0;
        end

        /*initial begin
                #5000;
                $finish;
        end*/
endmodule

