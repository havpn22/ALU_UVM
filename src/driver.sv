`include "defines.sv"

class alu_driver extends uvm_driver #(alu_sequence_item);

        `uvm_component_utils(alu_driver)

        virtual alu_interface vif;

        //alu_sequence_item item;

        function new(string name = "alu_driver", uvm_component parent);
                super.new(name, parent);
                `uvm_info("DRIVER", "Inside constructor",UVM_MEDIUM)
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                `uvm_info("DRIVER", "Build Phase", UVM_MEDIUM)

                if(!(uvm_config_db#(virtual alu_interface)::get(this, "*", "vif", vif))) begin
                        `uvm_error(get_type_name(), "Failed to get VIF")
                end
        endfunction

        task drive();
                vif.drv_cb.opa <= item.opa;
                vif.drv_cb.opb <= item.opb;
                vif.drv_cb.cin <= item.cin;
                vif.drv_cb.mode <= item.mode;
                vif.drv_cb.inp_valid <= item.inp_valid;
                vif.drv_cb.cmd <= item.cmd;
        endtask

        task run_phase(uvm_phase phase);
                int count;
                int single_arith[] = {4, 5, 6, 7};
                int single_logic[] = {6, 7, 8, 9, 10, 11};

                //item = alu_sequence_item::type_id::create("item");

                repeat(3) @(vif.drv_cb);

                forever begin
                        seq_item_port.get_next_item(item);

                        //item.mode.rand_mode(1);
                        //item.cmd.rand_mode(1);
                        if(item.inp_valid == 2'b11 || item.inp_valid == 2'b00) begin
                                drive();

                                `uvm_info(get_type_name(), $sformatf("Values from driver: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                $display("");
                                //repeat(1) @(vif.drv_cb);
                                if(item.mode == 1 && (item.cmd == 9 || item.cmd == 10))
                                        repeat(2) @(vif.drv_cb);
                                else
                                        repeat(1) @(vif.drv_cb);
                        end

                        else if(item.mode == 1 && item.cmd inside {single_arith}) begin
                                drive();

                                `uvm_info(get_type_name(), $sformatf("Values from driver: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                $display("");
                                repeat(1) @(vif.drv_cb);
                        end

                        else if(item.mode == 0 && item.cmd inside {single_logic}) begin
                                drive();

                                `uvm_info(get_type_name(), $sformatf("Values from driver: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                $display("");
                                repeat(1) @(vif.drv_cb);
                        end

                        else begin
                                drive();

                                `uvm_info(get_type_name(), $sformatf("Values from driver: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                $display("");
                                item.cmd.rand_mode(0);
                                item.mode.rand_mode(0);

                                for(int i = 0; i < 16; i++) begin
                                        count++;
                                        repeat(1) @(vif.drv_cb);
                                        item.randomize();
                                        drive();

                                        `uvm_info(get_type_name(), $sformatf("Values from driver: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d", item.mode, item.inp_valid, item.cmd, item.opa, item.opb, item.cin), UVM_MEDIUM)
                                        $display("");
                                        if(item.inp_valid == 2'b11) begin
                                                //repeat(1) @(vif.drv_cb);
                                                break;
                                        end
                                end
                                if(count == 16) begin
                                        `uvm_error("DRIVER", "Cannot put 2'b11 for two operand operation")
                                        $display("");
                                        repeat(1) @(vif.drv_cb);
                                end
                        end

                        item.mode.rand_mode(1);
                        item.cmd.rand_mode(1);

                        if(item.mode == 1 && (item.cmd == 9 || item.cmd == 10))
                                repeat(2) @(vif.drv_cb);
                        else
                                repeat(1) @(vif.drv_cb);

                        seq_item_port.item_done();
                end
        endtask
endclass
                          
