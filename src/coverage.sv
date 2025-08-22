`uvm_analysis_imp_decl(_mon_cg)
`uvm_analysis_imp_decl(_drv_cg)

class alu_coverage extends uvm_component;

        `uvm_component_utils(alu_coverage);

        uvm_analysis_imp_mon_cg#(alu_sequence_item, alu_coverage) coverage_mon;
        uvm_analysis_imp_drv_cg#(alu_sequence_item, alu_coverage) coverage_drv;

        alu_sequence_item item_drv;
        alu_sequence_item item_mon;

        covergroup drv_cg;
                c1: coverpoint item_drv.opa{ bins b1 = {[0:255]};}
                c2: coverpoint item_drv.opb{ bins b2 = {[0:255]};}
                c3: coverpoint item_drv.cin;
                c4: coverpoint item_drv.mode;
                c5: coverpoint item_drv.inp_valid;
                c6: coverpoint item_drv.cmd;
                c7: cross c6, c4;
                c8: cross c5, c4;
                c9: cross c6, c5;
        endgroup

        covergroup mon_cg;
                c1: coverpoint item_mon.res{ bins b1 = {0};
                                                bins b2 = {511};
                                        }
                c2: coverpoint item_mon.g{ bins b2 = {1};}
                c3: coverpoint item_mon.l{ bins b3 = {1};}
                c4: coverpoint item_mon.e{ bins b4 = {1};}
                c5: coverpoint item_mon.oflow;
                c6: coverpoint item_mon.cout;
                c7: coverpoint item_mon.err;
        endgroup

        function new(string name = "alu_coverage", uvm_component parent);
                super.new(name, parent);
                coverage_mon = new("coverage_mon", this);
                coverage_drv = new("coverage_drv", this);
                drv_cg = new();
                mon_cg = new();
        endfunction

        function void write_drv_cg(alu_sequence_item req);
                item_drv = req;
                drv_cg.sample();
        endfunction

        function void write_mon_cg(alu_sequence_item req);
                item_mon = req;
                mon_cg.sample();
        endfunction
endclass
