//`include "defines.sv"

class alu_agent extends uvm_agent;

        `uvm_component_utils(alu_agent)

        alu_driver drv;
        alu_monitor mon;
        alu_sequencer seqr;

        function new(string name = "alu_agent", uvm_component parent);
                super.new(name, parent);
                `uvm_info("AGENT", "Inside constructor", UVM_MEDIUM)
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                `uvm_info("AGENT", "Build Phase", UVM_MEDIUM)
                if(get_is_active() == UVM_ACTIVE) begin
                        drv = alu_driver::type_id::create("drv", this);
                        mon = alu_monitor::type_id::create("mon", this);
                end
                seqr = alu_sequencer::type_id::create("seqr", this);
        endfunction

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                `uvm_info("AGENT", "Connect Phase", UVM_MEDIUM)
                if(get_is_active() == UVM_ACTIVE)
                        drv.seq_item_port.connect(seqr.seq_item_export);
        endfunction
endclass
