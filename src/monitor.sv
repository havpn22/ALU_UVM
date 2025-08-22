`include "defines.sv"

class alu_monitor extends uvm_monitor;

        `uvm_component_utils(alu_monitor)

        virtual alu_interface mon_vif;

        uvm_analysis_port#(alu_sequence_item)mon_score_port;
        uvm_analysis_port#(alu_sequence_item)mon_cov_port;

        alu_sequence_item item;

        function new(string name = "alu_monitor", uvm_component parent);
                super.new(name, parent);
                `uvm_info("MONITOR", "Inside constructor", UVM_MEDIUM)
                mon_score_port = new("mon_score_port", this);
                mon_cov_port = new("mon_cov_port", this);
                item = new();
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                `uvm_info("MONITOR", "Build Phase", UVM_MEDIUM)

                if(!(uvm_config_db#(virtual alu_interface)::get(this, "", "vif", mon_vif))) begin
                        `uvm_fatal("MONITOR", "Failed to get VIF")LU_DESIGN #(parameter DW = 8, CW = 4)(INP_VALID,OPA,OPB,CIN,CLK,RST,CMD,CE,MODE,COUT,OFLOW,RES,G,E,L,ERR);

        task monitor_op();
                item.res = mon_vif.mon_cb.res;
                item.cout = mon_vif.mon_cb.cout;
                item.oflow = mon_vif.mon_cb.oflow;
                item.g = mon_vif.mon_cb.g;
                item.l = mon_vif.mon_cb.l;
                item.e = mon_vif.mon_cb.e;
                item.err = mon_vif.mon_cb.err;

                item.mode = mon_vif.mon_cb.mode;
                item.cmd = mon_vif.mon_cb.cmd;
                item.inp_valid = mon_vif.mon_cb.inp_valid;
                item.opa = mon_vif.mon_cb.opa;
                item.opb = mon_vif.mon_cb.opb;
                item.cin = mon_vif.mon_cb.cin;
        endtask
        task run_phase(uvm_phase phase);
                int single_arith[] = {4, 5, 6, 7};
                int single_logic[] = {6, 7, 8, 9, 10, 11};

                int count;
                //item = alu_sequence_item::type_id::create("item");
                $display("Res = %0d, cout = %0d, oflow = %0d, e = %0d, g = %0d, l = %0d, err= %0d", mon_vif.mon_cb.res, mon_vif.mon_cb.cout, mon_vif.mon_cb.oflow, mon_vif.mon_cb.e, mon_vif.mon_cb.g, mon_vif.mon_cb.l, mon_vif.mon_cb.err);
                //monitor_op();
                //mon_cov_port.write(item);

                repeat(4) @(mon_vif.mon_cb);
                forever begin
                        monitor_op();
                        mon_cov_port.write(item);
                        if(item.inp_valid == 2'b11 || item.inp_valid == 2'b00) begin
                                if(item.mode == 1 && (item.cmd == 9 || item.cmd == 10)) begin
                                        repeat(2) @(mon_vif.mon_cb);
                                        monitor_op();
                                        mon_cov_port.write(item);
                                        `uvm_info(get_type_name(), $sformatf("Monitor output: res = %0d, cout = %0d, oflow = %0d, g = %0d, l = %0d, e = %0d, err = %0d", item.res, item.cout, item.oflow, item.g, item.l, item.e, item.err), UVM_MEDIUM)
                                        $display("");
                                        `uvm_info(get_type_name(), $sformatf("Monitor inputs: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                        $display("");
                                end
                                else begin
                                        repeat(1) @(mon_vif.mon_cb);
                                        monitor_op();
                                        mon_cov_port.write(item);
                                        `uvm_info(get_type_name(), $sformatf("Monitor output: res = %0d, cout = %0d, oflow = %0d, g = %0d, l = %0d, e = %0d, err = %0d", item.res, item.cout, item.oflow, item.g, item.l, item.e, item.err), UVM_MEDIUM)
                                        $display("");
                                        `uvm_info(get_type_name(), $sformatf("Monitor inputs: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                        $display("");
                                end
                        end

                        else if(item.mode == 1 && (item.inp_valid inside {single_arith})) begin
                                repeat(1) @(mon_vif.mon_cb);
                                monitor_op();
                                mon_cov_port.write(item);
                                `uvm_info(get_type_name(), $sformatf("Monitor output: res = %0d, cout = %0d, oflow = %0d, g = %0d, l = %0d, e = %0d, err = %0d", item.res, item.cout, item.oflow, item.g, item.l, item.e, item.err), UVM_MEDIUM)
                                $display("");
                                `uvm_info(get_type_name(), $sformatf("Monitor inputs: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                $display("");
                        end

                        else if(item.mode == 0 && (item.inp_valid inside {single_logic})) begin
                                repeat(1) @(mon_vif.mon_cb);
                                monitor_op();
                                mon_cov_port.write(item);
                                `uvm_info(get_type_name(), $sformatf("Monitor output: res = %0d, cout = %0d, oflow = %0d, g = %0d, l = %0d, e = %0d, err = %0d", item.res, item.cout, item.oflow, item.g, item.l, item.e, item.err), UVM_MEDIUM)
                                $display("");
                                `uvm_info(get_type_name(), $sformatf("Monitor inputs: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                $display("");
                        end

                        else begin
                                for(int i = 0; i < 16; i++) begin
                                        count++;
                                        repeat(1) @(mon_vif.mon_cb);
                                        monitor_op();
                                        mon_cov_port.write(item);

                                        if(item.inp_valid == 2'b11) begin
                                                monitor_op();
                                                mon_cov_port.write(item);
                                                `uvm_info(get_type_name(), $sformatf("Monitor output: res = %0d, cout = %0d, oflow = %0d, g = %0d, l = %0d, e = %0d, err = %0d", item.res, item.cout, item.oflow, item.g, item.l, item.e, item.err), UVM_MEDIUM)
                                                $display("");
                                                `uvm_info(get_type_name(), $sformatf("Monitor inputs: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                                $display("");
                                                break;
                                        end
                                end
                        end

                        mon_score_port.write(item);

                        if(item.mode == 1 && (item.cmd == 9 || item.cmd == 10))
                                repeat(2) @(mon_vif.mon_cb);
                        else
                                repeat(1) @(mon_vif.mon_cb);

                end
        endtask
endclass
