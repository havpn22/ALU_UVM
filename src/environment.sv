class alu_env extends uvm_env;

        `uvm_component_utils(alu_env)

        alu_agent active_agent;
        alu_agent passive_agent;
        alu_scoreboard scoreboard;
        alu_coverage coverage;

        function new(string name = "alu_env", uvm_component parent);
                super.new(name, parent);
                `uvm_info("ENVI", "Inside constructor", UVM_MEDIUM)
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                `uvm_info("ENVI", "Build Phase", UVM_MEDIUM)

                active_agent = alu_agent::type_id::create("active_agent", this);
                passive_agent = alu_agent::type_id::create("passive_agent", this);
                scoreboard = alu_scoreboard::type_id::create("scoreboard", this);
                coverage = alu_coverage::type_id::create("coverage", this);
        endfunction

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                `uvm_info("ENVI", "Connect Phase", UVM_MEDIUM)

                active_agent.mon.mon_score_port.connect(scoreboard.scoreboard_imp);

                active_agent.mon.mon_cov_port.connect(coverage.coverage_drv);
                agent.mon.mon_cov_port.connect(coverage.coverage_mon);
        endfunction
endclass
