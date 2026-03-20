UGRASP : UVM Graph Automated Sequence Producer
==============================================

Introduction
------------

Creating Complex Random Sequence Story in UVM doesn't have to be complex.
This script provides a simple, yet powerful, UVM sequence generation, allowing you to write
your sequence story as a graph, and implementing atomic sequences for each chapter of this story.

You can use it for Finite State Machine verification, but also for anything which requires you to 
create sequential actions and decisions based on a graph.

How it works ?
--------------

You provide your story as an input graph definining a step of your story (or a state of the FSM) and all the possible next steps (or states).
A parser will build a graph from this inputs and a generator will provide you with:
- A base sequence infrastucture that you have to inherit from:
    - with a randsequence graph template for random generation
    - with body() tasks for each step and transition of your story (or FSM)
    - some utility functions such as a goto() or a coverage closure exist condition.
- A Graphviz file is also generated for your documentations.

What remains to you:
--------------------

Once the code is generated you have to:

- Import the generated package in your UVM environment
- Create a class that inherit from the generated sequence
- Implement the *_body() tasks


What if I update the graph ?
----------------------------

No problem. Since you have inherited from the generated sequence, you are free to re-generate the package without modifying your code.

However, you'll have to update your code to take care of the changes.
- add the features that are new
- remove the features that have been removed from the main graph.
   - note that if you don't call the <strong>super.*_body()</strong> function of the parent class, you're code will still compile.


Using States and Edges
======================

By default, the graph will be randomly covered by the randsequence. 

Two types of *_body() tasks are provided:
- <strong>STATENAME</strong>_body() : which represents the nodes of the graph or the states of the FSM. 
- <strong>PREVSTATE</strong>\_to\_<strong>NEXTSTATE</strong>_body(): which reprensents the transitions from one state to the next. 

There are two possible strategies in using these:
- use these *_body() tasks to perform the actions that will trigger the design.
- use these *_body() tasks to perform the actions once the transition or state is reached by the design.

A recommended use of these tasks is to use the edge body() to implement the actions that will trigger the design to move to the decided next state, and use the state body() to implement reactive actions related to the design behavior or response. 
This eases the the actions (as we know the final destination) and allows to force the next decisions based on the design response while we are in a state condition.

Hence, we recommand to:
- <strong>PREVSTATE</strong>\_to\_<strong>NEXTSTATE</strong>_body() tasks maint to perform actions to change the state of the design<strong>NEXTSTATE</strong>.
- <strong>STATENAME</strong>_body() tasks maint to be used while inside the state <strong>STATENAME</strong> prior to decide where to move.
    - polling registers, wait for interrupts, wait for events, ... 
    - Reactive state transitions (depending on the design) shall call goto(), exclude_next(), include_next() from here.

   


For convenience, the sequence also provides the following generic tasks, which take the state as arguments.

```verilog
    extern virtual task          state_body(PACKAGENAME_state_t state); // called on any state
    extern virtual task          transition_body(PACKAGENAME_state_t src,dst); // called on any transition
    extern virtual task          include_next(PACKAGENAME_state_t state); // make the given state as parts of the possible choices
    extern virtual task          exclude_next(PACKAGENAME_state_t state); // remove the given state from possible choices
    extern virtual task          include_transition(PACKAGENAME_state_t src,dst); // make the given transition as parts of the possible choices
    extern virtual task          exclude_transition(PACKAGENAME_state_t src,dst); // remove the given transition from the possible choices
    extern virtual task          exit(); // exit on the next iteration
    extern virtual task          goto(PACKAGENAME_state_t state); // ensure the graph jumps to the given state
```

and each task is provided with its companion functions:

```verilog
    *_pre_body()
    *_post_body()
```


Generation Example:
===================

    ugrasp --help
    ugrasp -in_csv pcie_link_polling.csv \
            -out_dir pcie_link_polling_pkg/src/sv \
            -classname pcie_link_polling \
            -gen_uvm \
            -first_state Entry_from_Detect \
            -per_instance no \
            -gen_dot \
            -gen_dot_full

This takes the input file *pcie_link_polling.csv* to generate the results in the directory *pcie_link_polling_pkg/src/sv*. It generates the full UVM package.

In this example, the graph is defined in *pcie_link_polling.csv* and starts with Entry_from_Detect.

In same cases, you don't care which first state you should enter in. For this, you can specify multiple first_states using a comma separated list

    ugrasp ... \
        -first_state Entry_from_Detect,Entry_from_Error


Usage Example:
==============


```verilog
    class my_master_sequence extends pcie_link_training_sequence;
        `uvm_object_utils(my_master_sequence)
        `uvm_declare_p_sequencer(my_sequencer)

        constraint my_cfg {
            max_iter == 100; // exit after 100 iterations
            initial_edge_weight == 100; // all edges have a weight of 100 by default
            weight[Polling_Active][Polling_Compliance] == 1000; // Increase probability to take that route
        }

        function new(string name="my_master_sequence");
            super.new(name);
        endfunction

        // Called when a sequence state is reached
        task state_body(pcie_link_training_state_t state);
            `uvm_info("MASTER",$sformatf("Setting state to %s",state.name),UVM_LOW)
        endtask

        // Perform the polling action on the edge from Detect to Polling
        task Detect_to_Polling_body();
            `uvm_do(polling_seq);
        endtask

        // Perform the polling action on the edge from anything to Polling
        // WARNING: since Detect_to_Polling_body() is also used the action will run twice !!!
        //          so it's either one approach or the other.
        task transition_body(pcie_link_training_state_t src,dst);
            if ( dst == Polling )
                `uvm_do(polling_seq);
        endtask 

        //...

        // Once Polling is reached, we run a subsequence which will tell us where to go then
        task polling_body();
            pcie_training_polling_seq seq = new();
            void'(seq.randomize());
            seq.start();
            if ( seq.state == exit_to_detect )
                goto(Detect);
            else
                goto(Configuration);
            endtask

        // Called once we complete.
        task completion_body();
            super.completion_body();
            $display("completion_body() - called");
        endtask 

    endclass
```



