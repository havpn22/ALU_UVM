`include "defines.sv"

class alu_scoreboard extends uvm_scoreboard;

        `uvm_component_utils(alu_scoreboard)

        uvm_analysis_imp#(alu_sequence_item, alu_scoreboard) scoreboard_imp;

        virtual alu_interface vif;
        alu_sequence_item m_item;
        alu_sequence_item r_item;

        alu_sequence_item scb_q[$];

        int s_amt;

        function new(string name = "alu_scoreboard", uvm_component parent);
                super.new(name, parent);
                `uvm_info("SCOREBOARD", "Inside constructor", UVM_MEDIUM)
                scoreboard_imp = new("scoreboard_imp", this);
                r_item = new();
                m_item = new();
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                `uvm_info("SCOREBOARD", "Build Phase", UVM_MEDIUM)

                if(!(uvm_config_db#(virtual alu_interface)::get(this, "*", "vif", vif)))
                        `uvm_error(get_type_name(),"Failed to get VIF")
        endfunction

        task calculate(alu_sequence_item r_item);
                if(vif.ref_cb.reset)begin
                        r_item.res = {`DATA_WIDTH{1'bz}};
                        r_item.cout = 1'bz;
                        r_item.oflow = 1'bz;
                        r_item.e = 1'bz;
                        r_item.g = 1'bz;
                        r_item.l = 1'bz;
                        r_item.err = 1'bz;
                end

                else if(vif.ref_cb.ce) begin
                        r_item.res = {`DATA_WIDTH{1'bz}};
                        r_item.cout = 1'bz;
                        r_item.oflow = 1'bz;
                        r_item.e = 1'bz;
                        r_item.g = 1'bz;
                        r_item.l = 1'bz;
                        r_item.err = 1'bz;

                        if(r_item.mode == 1) begin
                                case(r_item.inp_valid)
                                        2'b00: begin
                                                r_item.res = 0;
                                                r_item.err = 1;
                                        end
                                        2'b01: begin
                                                case(r_item.cmd)
                                                        4'b0100: begin
                                                                r_item.res = r_item.opa + 1;
                                                                r_item.cout = r_item.res[`DATA_WIDTH];
                                                        end
                                                        4'b0101: begin
                                                                r_item.res = r_item.opa - 1;
                                                                r_item.oflow = r_item.res[`DATA_WIDTH];
                                                        end
                                                        default: begin
                                                                r_item.res = 0;
                                                                r_item.err = 1;
                                                        end
                                                endcase
                                        end
                                        2'b10: begin
                                                case(r_item.cmd)
                                                        4'b0110: begin
                                                                r_item.res = r_item.opb + 1;
                                                                r_item.cout = r_item.res[`DATA_WIDTH];
                                                        end
                                                        4'b0111: begin
                                                                r_item.res = r_item.opb - 1;
                                                                r_item.oflow = r_item.res[`DATA_WIDTH];
                                                        end
                                                        default: begin
                                                                r_item.res = 0;
                                                                r_item.err = 1;
                                                        end
                                                endcase
                                        end
                                        2'b11: begin
                                                case(r_item.cmd)
                                                        4'b0000: begin
                                                                r_item.res = r_item.opa + r_item.opb;
                                                                r_item.cout = r_item.res[`DATA_WIDTH];
                                                        end
                                                        4'b0001: begin
                                                                r_item.res = r_item.opa - r_item.opb;
                                                                r_item.oflow = (r_item.opa < r_item.opb) ? 1 : 0;
                                                        end
                                                        4'b0010: begin
                                                                r_item.res = r_item.opa + r_item.opb + r_item.cin;
                                                                r_item.cout = r_item.res[`DATA_WIDTH];
                                                        end
                                                        4'b0011: begin
                                                                r_item.res = r_item.opa - r_item.opb - r_item.cin;
                                                                r_item.oflow = (r_item.opa < r_item.opb) ? 1 : 0;
                                                        end
                                                        4'b0100: begin
                                                                r_item.res = r_item.opa + 1;
                                                                r_item.cout = r_item.res[`DATA_WIDTH];
                                                        end
                                                        4'b0101: begin
                                                                r_item.res = r_item.opa - 1;
                                                                r_item.oflow = (r_item.opa < 1) ? 1 : 0;
                                                        end
                                                        4'b0110: begin
                                                                r_item.res = r_item.opb + 1;
                                                                r_item.cout = r_item.res[`DATA_WIDTH];
                                                        end
                                                        4'b0111: begin
                                                                r_item.res = r_item.opb - 1;
                                                                r_item.oflow = (r_item.opb < 1) ? 1 : 0;
                                                        end
                                                        4'b1000: begin
                                                                if(r_item.opa > r_item.opb)
                                                                        r_item.g = 1;
                                                                else if(r_item.opa < r_item.opb)
                                                                        r_item.l = 1;
                                                                else
                                                                        r_item.e = 1;
                                                        end
                                                        4'b1001: begin
                                                                r_item.res = (r_item.opa + 1) * (r_item.opb + 1);
                                                        end
                                                        4'b1010: begin
                                                                r_item.res = (r_item.opa << 1) * r_item.opb;
                                                        end
                                                        default: begin
                                                                r_item.res = 0;
                                                                r_item.err = 1;
                                                        end
                                                endcase
                                        end
                                        default: begin
                                                r_item.res = 0;
                                                r_item.err = 1;
                                        end
                                endcase
                        end

                        else begin
                                case(r_item.inp_valid)
                                        2'b00: begin
                                                r_item.res = 0;
                                                r_item.err = 1;
                                        end
                                        2'b01: begin
                                                case(r_item.cmd)
                                                        4'b0110: begin
                                                                r_item.res = {1'b0, ~r_item.opa};
                                                        end
                                                        4'b1000: begin
                                                                r_item.res = {1'b0, r_item.opa >> 1};
                                                        end
                                                        4'b1001: begin
                                                                r_item.res = {1'b0, r_item.opa << 1};
                                                        end
                                                        default: begin
                                                                r_item.res = 0;
                                                                r_item.err = 1;
                                                        end
                                                endcase
                                        end
                                        2'b10: begin
                                                case(r_item.cmd)
                                                        4'b0111: begin
                                                                r_item.res = {1'b0, ~r_item.opb};
                                                        end
                                                        4'b1010: begin
                                                                r_item.res = {1'b0, r_item.opb >> 1};
                                                        end
                                                        4'b1011: begin
                                                                r_item.res = {1'b0, r_item.opb << 1};
                                                        end
                                                        default: begin
                                                                r_item.res = 0;
                                                                r_item.err = 1;
                                                        end
                                                endcase
                                        end
                                        2'b11: begin
                                                case(r_item.cmd)
                                                        4'b0000: begin
                                                                r_item.res = {1'b0, r_item.opa & r_item.opb};
                                                        end
                                                        4'b0001: begin
                                                                r_item.res = {1'b0, ~(r_item.opa & r_item.opb)};
                                                        end
                                                        4'b0010: begin
                                                                r_item.res = {1'b0, r_item.opa | r_item.opb};
                                                        end
                                                        4'b0011: begin
                                                                r_item.res = {1'b0, ~(r_item.opa | r_item.opb)};
                                                        end
                                                        4'b0100: begin
                                                                r_item.res = {1'b0, r_item.opa ^ r_item.opb};
                                                                end
                                                        4'b0101: begin
                                                                r_item.res = {1'b0, ~(r_item.opa ^ r_item.opb)};
                                                        end
                                                        4'b0110: begin
                                                                r_item.res = {1'b0, ~r_item.opa};
                                                        end
                                                        4'b0111: begin
                                                                r_item.res = {1'b0, ~r_item.opb};
                                                        end
                                                        4'b1000: begin
                                                                r_item.res = {1'b0, r_item.opa >> 1};
                                                        end
                                                        4'b1001: begin
                                                                r_item.res = {1'b0, r_item.opa << 1};
                                                        end
                                                        4'b1010: begin
                                                                r_item.res = {1'b0, r_item.opb >> 1};
                                                        end
                                                        4'b1011: begin
                                                                r_item.res = {1'b0, r_item.opb << 1};
                                                        end
                                                        4'b1100: begin
                                                                r_item.err = (r_item.opb[7] | r_item.opb[6] | r_item.opb[5] | r_item.opb[4]);
                                                                s_amt = r_item.opb[`N-1:0];
                                                                if(s_amt == 0) begin
                                                                        r_item.res = r_item.opa;
                                                                end
                                                                else begin
                                                                        r_item.res = (r_item.opa << s_amt ) | (r_item.opa >> (`DATA_WIDTH - s_amt));
                                                                end
                                                        end
                                                        4'b1101: begin
                                                                r_item.err = (r_item.opb[7] | r_item.opb[6] | r_item.opb[5] | r_item.opb[4]);
                                                                s_amt = r_item.opb[`N-1:0];
                                                                if(s_amt == 0) begin
                                                                        r_item.res = r_item.opa;
                                                                end
                                                                else begin
                                                                        r_item.res = (r_item.opa >> s_amt ) | (r_item.opa << (`DATA_WIDTH - s_amt));
                                                                end
                                                        end
                                                        default: begin
                                                                r_item.res = 0;
                                                                r_item.err = 1;
                                                        end
                                                endcase
                                        end
                                        default: begin
                                                r_item.res = 0;
                                                r_item.err = 1;
                                        end
                                endcase
                        end
                end
        endtask

        function void write(alu_sequence_item item);
                $display("Received at Scoreboard");
                scb_q.push_back(item);
        endfunction


        task run_phase(uvm_phase phase);
                int match = 0;
                int mismatch = 0;
                repeat(1) @(vif.ref_cb);
                //r_item = alu_sequence_item::type_id::create("r_item");
                forever begin
                        wait(scb_q.size > 0);
                        m_item = scb_q.pop_front();

                        r_item.copy(m_item);

                        calculate(r_item);
                        `uvm_info(get_type_name(), $sformatf("Reference Model: res = %0d, cout = %0d, oflow = %0d, e = %0d, g = %0d, l = %0d, err = %0d", r_item.res, r_item.cout, r_item.oflow, r_item.e, r_item.g, r_item.l, r_item.err), UVM_MEDIUM)
                        if(m_item.compare(r_item)) begin
                                `uvm_info(get_type_name(), $sformatf("------------------PASS----------------"), UVM_MEDIUM)
                                $display("");
                                match++;
                        end
                        else begin
                                `uvm_info(get_type_name(), $sformatf("------------------FAIL----------------"), UVM_MEDIUM)
                                $display("");
                                mismatch++;
                        end
                        `uvm_info(get_type_name(), $sformatf("Total number of MATCH = %0d and MISMATCH = %0d", match, mismatch), UVM_MEDIUM)
                        $display("-----------------------------------------------------------------------------------------------------");
                end
        endtask
endclass
