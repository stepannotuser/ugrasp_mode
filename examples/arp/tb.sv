

package arp_test_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import arp_pkg::*;

    class my_arp_sequence#(PER_INSTANCE_COVERAGE=1) extends arp_sequence;
        `uvm_object_utils(my_arp_sequence)

        int nr_goto_done = 0;

        function new(string name="my_arp_sequence");
            super.new(name);

            cg.transitions.option.weight = 10;
            cg.states.option.at_least = 1000;
        endfunction

        task state_body(arp_state_t state);
            $display("state = %s",state.name);
        endtask

        task   Idle_to_RequestAddress_body();
            $display("Idle_to_RequestAddress_body() - called");
        endtask

        task transition_body(arp_state_t src,dst);
            $display("src=%s -> dst=%s",src.name,dst.name);
        endtask
        task RequestAddress_body();
            $display("RequestAddress_body() - called");
            if ( nr_goto_done < 249 ) begin 
                goto(AssignAddress);
                nr_goto_done += 1;
            end

        endtask

        task completion_body();
            $display("completion_body() - called");
        endtask 

    endclass 


    class arp_sequencer extends uvm_sequencer;
        `uvm_component_utils(arp_sequencer)
        function new(string name , uvm_component parent);
            super.new(name,parent);
        endfunction
    endclass

    class arp_test extends uvm_test;
        `uvm_component_utils(arp_test)

        arp_sequencer sqr;

        function new(string name , uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            sqr = arp_sequencer::type_id::create("sqr",this);
        endfunction

        task run_phase(uvm_phase phase);
            my_arp_sequence#(0) seq1 = new("arp");
            my_arp_sequence#(0) seq2 = new("arp");
            phase.raise_objection(this);

            void'(seq1.randomize());
            seq1.start(this.sqr);
            
            #1ns;
            
            void'(seq2.randomize());
            seq2.start(this.sqr);

            phase.drop_objection(this);

        endtask

    endclass
endpackage


module tb();

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import arp_test_pkg::*;

    initial 
        uvm_pkg::run_test("arp_test");


endmodule