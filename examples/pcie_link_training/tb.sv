

`include "uvm_macros.svh"
package my_test_pkg;
    import uvm_pkg::*;
    import pcie_link_training_pkg::*;

    /*class my_driver extends uvm_driver;
        `uvm_component_utils(my_driver)
        function new(string name , uvm_component parent);
            super.new(name,parent);
        endfunction
    endclass /**/

    class my_sequencer extends uvm_sequencer;
        `uvm_component_utils(my_sequencer)

        // cheating, no drivers
        virtual interface pcie_itf vif;

        function new(string name , uvm_component parent);
            super.new(name,parent);
        endfunction

        task m_set_state(pcie_link_training_state_t state);
            vif.master_state = state;
        endtask

        task m_request_state(pcie_link_training_state_t state);
            vif.master_request = state;
            vif.req           <= 1;
            @(posedge vif.clock);
            while (! vif.gnt ) @(posedge vif.clock);
            vif.req           <= 0;
        endtask

        task m_get_response(ref pcie_link_training_state_t state);
            while (! vif.gnt ) @(posedge vif.clock);
            state = vif.slave_response;
        endtask

        task s_set_state(pcie_link_training_state_t state);
            vif.slave_state = state;
        endtask


        task s_get_state_request(ref pcie_link_training_state_t state);
            @(posedge vif.clock);
            while ( vif.req !== 1 ) @(posedge vif.clock);
            state = vif.master_request;
        endtask

        task s_set_state_response(pcie_link_training_state_t state);
            while (vif.req !==1 ) @(posedge vif.clock);
            waitstates(0,5);
            vif.gnt <= 1;
            vif.slave_response <= state;
            @(posedge vif.clock);
            vif.gnt <= 0;
        endtask


        task waitstates(int unsigned min, max=min);
            int unsigned ws = 0;
            void'(std::randomize(ws) with { ws inside {[min:max]}; });
            repeat(ws) @(posedge vif.clock);
        endtask

    endclass

    class my_agent extends uvm_agent;
        `uvm_component_utils(my_agent)

        virtual interface pcie_itf vif;
        my_sequencer sequencer;
        //my_driver    driver;

        function new(string name , uvm_component parent);
            super.new(name,parent);
            sequencer = my_sequencer ::type_id::create("my_sequencer",this);
            //driver    = my_driver    ::type_id::create("my_driver"   ,this);
        endfunction

        function void connect_phase(uvm_phase phase);
            if ( !uvm_config_db#(virtual interface pcie_itf)::exists(this,"","vif") ) 
                `uvm_fatal("F_NOVIF","Expecting to get a 'vif' from uvm_config_db !!!")

            uvm_config_db#(virtual interface pcie_itf)::get(this,"","vif",vif);
            sequencer.vif = vif;
        endfunction


    endclass


    class my_master_sequence extends pcie_link_training_sequence;
        `uvm_object_utils(my_master_sequence)
        `uvm_declare_p_sequencer(my_sequencer)

        int nr_goto_done = 0;
        int nr_iter = 0;

        function new(string name="my_master_sequence");
            super.new(name);
        endfunction

        task state_body(pcie_link_training_state_t state);
            p_sequencer.m_set_state(state);
            `uvm_info("MASTER",$sformatf("Setting state to %s",state.name),UVM_LOW)
            p_sequencer.waitstates(5,10);
        endtask

        task Detect_to_Polling_body();
            p_sequencer.m_request_state(Polling);
        endtask

        task Polling_to_Detect_body();
            p_sequencer.m_request_state(Detect);
        endtask

        task Polling_to_Configuration_body();
            p_sequencer.m_request_state(Configuration);
        endtask

        task Configuration_to_L0_body();
            p_sequencer.m_request_state(L0);
        endtask

        task Configuration_to_Detect_body();
            p_sequencer.m_request_state(Detect);
        endtask

        task Configuration_to_Recovery_body();
            p_sequencer.m_request_state(Recovery);
        endtask


        // When Reaching L0, the slave will tell us where to go.
        task L0_body();
            pcie_link_training_state_t response;
            p_sequencer.m_request_state(UNKNOWN);
            p_sequencer.m_get_response(response);
            goto(response);
        endtask

        /*
        task L0_to_L0s_body();
            p_sequencer.m_request_state(L0s);
        endtask

        task L0_to_L1_body();
            p_sequencer.m_request_state(L1);
        endtask

        task L0_to_L2_body();
            p_sequencer.m_request_state(L2);
        endtask

        task L0_to_Recovery_body();
            p_sequencer.m_request_state(Recovery);
        endtask
        */

        task L0s_to_L0_body();
            p_sequencer.m_request_state(L0);        
        endtask

        task L0s_to_Recovery_body();
            p_sequencer.m_request_state(Recovery);
        endtask

        task L1_to_Recovery_body();
            p_sequencer.m_request_state(Recovery);
        endtask

        task L2_to_Detect_body();
            p_sequencer.m_request_state(Detect);
        endtask

        task Recovery_to_Configuration_body();
            p_sequencer.m_request_state(Configuration);
        endtask

        task Recovery_to_L0_body();
            p_sequencer.m_request_state(L0);
        endtask

        task Recovery_to_Detect_body();
            p_sequencer.m_request_state(Detect);
        endtask

        task completion_body();
            super.completion_body();
            $display("completion_body() - called");
        endtask 

    endclass 

    
    class my_slave_sequence extends pcie_link_training_sequence;
        `uvm_object_utils(my_slave_sequence)
        `uvm_declare_p_sequencer(my_sequencer)

        int nr_goto_done = 0;
        int nr_iter = 0;

        function new(string name="my_slave_sequence");
            super.new(name);
        endfunction

        task state_body(pcie_link_training_state_t state);
            `uvm_info("SLAVE",$sformatf("Setting state to %s",state.name),UVM_LOW)
            p_sequencer.s_set_state(state);
        endtask

        task Detect_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(req);
            goto(req);
        endtask

        task Polling_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(req);
            goto(req);
        endtask

        task Configuration_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(req);
            goto(req);
        endtask


        // In L0, the slave decides
        task L0_body();
            
            weight[L0][Recovery] = 0;
        endtask
        
        task L0_to_L0s_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(L0s);
            p_sequencer.waitstates(1);
        endtask

        task L0_to_L1_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(L1);
            p_sequencer.waitstates(1);
        endtask

        task L0_to_L2_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(L2);
            p_sequencer.waitstates(1);
        endtask

        task L0_to_Recovery_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(Recovery);
            p_sequencer.waitstates(1);
        endtask



        task L0s_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(req);
            goto(req);
        endtask

        task L1_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(req);
            goto(req);
        endtask

        task L2_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(req);
            goto(req);
        endtask

        task Recovery_body();
            pcie_link_training_state_t req;
            p_sequencer.s_get_state_request(req);
            p_sequencer.s_set_state_response(req);
            goto(req);
        endtask


        task completion_body();
            super.completion_body();
            $display("completion_body() - called");
        endtask 

    endclass 

    class my_test extends uvm_test;
        `uvm_component_utils(my_test)

        my_agent m_agt;
        my_agent s_agt;

        function new(string name , uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            m_agt = my_agent::type_id::create("m_agt",this);
            s_agt = my_agent::type_id::create("s_agt",this);
        endfunction

        task run_phase(uvm_phase phase);
            my_master_sequence seq1 = new();
            my_slave_sequence seq2 = my_slave_sequence::type_id::create("seq2");

            phase.raise_objection(this);

            void'(seq1.randomize());
            void'(seq2.randomize());

            fork
                seq1.start(this.m_agt.sequencer);
                seq2.start(this.s_agt.sequencer);
            join_any
            
            #1ns;
            
            phase.drop_objection(this);

        endtask

    endclass
endpackage

interface pcie_itf(input logic clock);
    import pcie_link_training_pkg::*;
    pcie_link_training_state_t master_state;
    pcie_link_training_state_t slave_state;

    pcie_link_training_state_t master_request;
    pcie_link_training_state_t slave_response;

    logic req;
    logic gnt;
endinterface



module tb();

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import my_test_pkg::*;

    logic clock;

    pcie_itf pcie_itf(.*);
    
    
    initial begin 
        uvm_config_db#(virtual interface pcie_itf)::set(null,"uvm_test_top.m_agt","vif",pcie_itf);
        uvm_config_db#(virtual interface pcie_itf)::set(null,"uvm_test_top.s_agt","vif",pcie_itf);
        uvm_pkg::run_test("my_test");
    end


    // clockgen
    initial begin 
        clock <= 0;
        pcie_itf.gnt <= 0;
        forever begin 
            #10ns;
            clock <= ~clock;
        end
    end

endmodule