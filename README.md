![License: AEDVICES-SE-v1.0](https://img.shields.io/badge/license-AEDVICES--SE--v1.0-blue)

SystemVerilog Graph
===================

* Tool to edit test Graphs and generate SystemVerilog graph randsequence
* Tool to run randsequence efficiently

User Guide
==========

for full step-by-step tutorial, see:

* [doc/ugrasp.md](doc/ugrasp.md) 




Concepts
==========


Inputs:

* CSV File with state, next_state columns
* Graph defined as a Graphviz file (TBD)
* Graphical User Interface to generate the Graphviz

Outputs:

* A UVM Sequence, using randsequence which:
    * use ransequence to implement the graph
    * has action functions and tasks for each:
        * nodes
        * edges
    * has constrainable weight for each edge
    * reduces weight of the eidge when they are executed, accelerating the overall graph coverage closure
    * has state and transition coverage
    * stops when a maximum number of iterations is reached
    * stops when coverage is 100%
    * allow users to extend the class and implement each action and call UVM sequences.


Example:
========

CSV File
```
state,next_state
A,A
A,B
A,C
B,B
B,C
B,D
IDLE,A
IDLE,B
C,A
C,IDLE
D,B
D,IDLE
```

or
GraphViz
```dot
digraph FSM {
    
    node [shape=elipse];    
    rank=max;
    IDLE;

    rank=med;
    // --selections--
    A -> {A B C};
    B -> {B C D};
    IDLE -> {A B};
    C    -> {A IDLE };
    D    -> {B IDLE };

}
````

![Initial Graph](examples/completeness/graph_simple.svg)



is converted to a sequence handling all possible states and transitions.




TODOs:
======

- Custom base sequence, instead of only "uvm_sequence"
- Custom name for **starting** node and for **completion** task
- Check conflict names with internal functions and tasks
- Multi-Layered sequence scenarios within the same package, taking several inputs.
- DPI calls to enable advanced graph search algorithms.
- Input Formats:
    - .dot / graphviz
    - PSS ?
- Output Formats:
    - Markdown documentation .md files
    - SVG and PNG directly calling graphviz


