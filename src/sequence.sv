`include "defines.sv"

class alu_sequence extends uvm_sequence#(alu_sequence_item);
        `uvm_object_utils(alu_sequence)

        int single_arith[] = {4, 5, 6, 7};
        int single_logic[] = {6, 7, 8, 9, 10, 11};

        alu_sequence_item seq_item;

        function new(string name = "alu_sequence");
                super.new(name);
                `uvm_info("SEQUENCE", "Inside constructor", UVM_MEDIUM)
        endfunction

        virtual task body();
                `uvm_info("SEQUECNE", "Inside body task", UVM_MEDIUM)
                seq_item = alu_sequence_item::type_id::create("seq_item");
                repeat(`no_of_trans) begin
                        start_item(seq_item);
                        assert(seq_item.randomize());
                        `uvm_info(get_type_name(), $sformatf("SEQUENCE GENERATED: mode = %0d, inp_valid = %0d, cmd = %0d, opa = %0d, opb = %0d, cin = %0d",seq_item.mode, seq_item.inp_valid, seq_item.cmd, seq_item.opa, seq_item.opb, seq_item.cin), UVM_MEDIUM)
                        $display("");
                        finish_item(seq_item);
                        //get_response(seq_item);
                end
        endtask
endclass

class arith_single extends uvm_sequence#(alu_sequence_item);
        `uvm_object_utils(arith_single)
        //alu_sequence_item seq_item;

        function new(string name = "arith_single");
                super.new(name);
        endfunction

        task body();
                repeat(`no_of_trans) begin
                        `uvm_do_with(seq_item, {seq_item.mode == 1; seq_item.cmd inside {[4:7]}; seq_item.inp_valid == 2'b11;})
                end
        endtask
endclass

class logic_single extends uvm_sequence#(alu_sequence_item);
        `uvm_object_utils(logic_single)

        //alu_sequence_item seq_item;

        function new(string name = "logic_single");
                super.new(name);
        endfunction

        task body();
                repeat(`no_of_trans)begin
                        `uvm_do_with(seq_item, {seq_item.mode == 0; seq_item.cmd inside {[6:11]}; seq_item.inp_valid == 2'b11;})
                end
        endtask
endclass

class arith_two extends uvm_sequence#(alu_sequence_item);
        `uvm_object_utils(arith_two)

        //alu_sequence_item seq_item;

        function new(string name = "arith_two");
                super.new(name);
        endfunction

        task body();
                repeat(`no_of_trans)begin
                        `uvm_do_with(seq_item, {seq_item.mode == 1; seq_item.cmd inside {[0:3], [8:10]}; seq_item.inp_valid == 2'b11;})
                end
        endtask
endclass

class logic_two extends uvm_sequence#(alu_sequence_item);
        `uvm_object_utils(logic_two)

        //alu_sequence_item seq_item;

        function new(string name = "logic_two");
                super.new(name);
        endfunction

        task body();
                repeat(`no_of_trans)begin
                        `uvm_do_with(seq_item, {seq_item.mode == 0; seq_item.cmd inside {[0:5], 12, 13}; seq_item.inp_valid == 2'b11;})
                end
        endtask
endclass

class regression_sequence extends uvm_sequence#(alu_sequence_item);
        `uvm_object_utils(regression_sequence)

        alu_sequence seq;
        arith_single seq1;
        logic_single seq2;
        arith_two seq3;
        logic_two seq4;

        function new(string name = "regreesion_test");
                super.new(name);
                seq_item = new();
        endfunction

        virtual task body();
                `uvm_do(seq);
                `uvm_do(seq1);
                `uvm_do(seq2);
                `uvm_do(seq3);
                `uvm_do(seq4);
        endtask
endclass

endclass
