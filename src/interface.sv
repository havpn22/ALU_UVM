`include "defines.sv"

interface alu_interface(input bit clk, reset, ce);
        //logic reset;
        //logic ce;
        logic [`DATA_WIDTH-1:0] opa, opb;
        logic cin;
        logic mode;
        logic [`CMD_WIDTH-1:0] cmd;
        logic [1:0] inp_valid;
        logic [`DATA_WIDTH:0] res;
        logic cout;
        logic oflow;
        logic e;
        logic g;
        logic l;
        logic err;

        clocking drv_cb @(posedge clk);
                default input #0 output #0;
                output opa, opb, cin, mode, inp_valid, cmd;
                input reset;
        endclocking

        clocking mon_cb @(posedge clk);
                default input #0 output #0;
                input res, oflow, cout, g, l, e, err;
                input opa, opb, cin, mode, inp_valid, cmd;
        endclocking

        clocking ref_cb @(posedge clk);
                default input #0 output #0;
                input ce, reset, clk;
        endclocking

        modport drv_m(clocking drv_cb);
        modport mon_m(clocking mon_cb);
        modport ref_m(clocking ref_cb);

        property VERIFY_RESET;
                @(posedge clk) reset |=> (res === 9'bzzzzzzzzz && err === 1'bz && e === 1'bz && g === 1'bz && l === 1'bz && cout === 1'bz && oflow === 1'bz);
        endproperty

        assert property(VERIFY_RESET) $info($time, "passed");else $info($time, "ERROR");


        // CLOCK EN check


        property CE_ASSERT;
                @(posedge clk) !(ce) |-> ##[1:$] (ce);
        endproperty

        assert property(CE_ASSERT) $info("CLK_EN PASSEED");
        else
                $info("CLK_EN FAILED");

        // property for 16 cycle err
        property TIMEOUT_16Clk;
                @(posedge clk) disable iff(reset)(ce && (inp_valid == 2'b01 || inp_valid == 2'b10)) |-> !(inp_valid == 2'b11) [*16] |-> ##1 err;

        endproperty

        assert property (TIMEOUT_16Clk) $info("passed");
         else
            $info("failed");

        // validity

        property VALID_INPUTS_CHECK;
                @(posedge clk) disable iff(reset) ce |-> not($isunknown({opa,opb,inp_valid,cin,mode,cmd}));
        endproperty

        assert property(VALID_INPUTS_CHECK) $info("inputs valid");
        else
                $info("inputs not valid");

        property ROTATE_OP_CHECK;
                @(posedge clk) disable iff(reset) (ce && (mode == 0) && (cmd == 12 || cmd == 13) && opb >= 16) |=> err;
        endproperty

        assert property(ROTATE_OP_CHECK) $info("ERR SET FOR OPB > 16");
        else
                $warning("ERR NOT SET FOR OPB > 16");

endinterface
