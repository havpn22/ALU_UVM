class alu_test extends uvm_test;

        `uvm_component_utils(alu_test)

        alu_env env;
        alu_sequence seq;

        function new(string name = "alu_test", uvm_component parent);
                super.new(name, parent);
                `uvm_info("TEST", "Inside constructor", UVM_MEDIUM)
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                `uvm_info("TEST", "Build Phase", UVM_MEDIUM)

                env = alu_env::type_id::create("env", this);
                uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agent", "is_active", UVM_ACTIVE);
                uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agent", "is_active", UVM_PASSIVE);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                `uvm_info("TEST", "Connect Phase", UVM_MEDIUM)
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                seq = alu_sequence::type_id::create("seq");
                seq.start(env.agent.seqr);
                phase.drop_objection(this);
        endtask
endclass

class arith_single_test extends alu_test;;
        `uvm_component_utils(arith_single_test)

        function new(string name = "arith_single_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
                arith_single seq1;
                phase.raise_objection(this);
                seq1 = arith_single::type_id::create("seq1");
                seq1.start(env.agent.seqr);
                phase.drop_objection(this);
        endtask
endclass

class logic_single_test extends alu_test;
        `uvm_component_utils(logic_single_test)

        function new(string name = "logic_single_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
                logic_single seq2;
                phase.raise_objection(this);
                seq2 = logic_single::type_id::create("seq2");
                seq2.start(env.agent.seqr);
                phase.drop_objection(this);
        endtask
endclass

class arith_two_test extends alu_test;
        `uvm_component_utils(arith_two_test)

        function new(string name = "arith_two_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
                arith_two seq3;
                phase.raise_objection(this);
                seq3 = arith_two::type_id::create("seq3");
                seq3.start(env.agent.seqr);
                phase.drop_objection(this);
        endtask
endclass

class logic_two_test extends alu_test;
        `uvm_component_utils(logic_two_test)

        function new(string name = "logic_two_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
                logic_two seq4;
                phase.raise_objection(this);
                seq4 = logic_two::type_id::create("seq4");
                seq4.start(env.agent.seqr);
                phase.drop_objection(this);
        endtask
endclass

class regression_test extends alu_test;
        `uvm_component_utils(regression_test)

        function new(string name = "regression_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
                regression_sequence seq_reg;
                phase.raise_objection(this);
                on_sequence::type_id::create("seq_reg");
                seq_reg.start(env.agent.seqr);
                phase.drop_objection(this);
        endtask
endclass


