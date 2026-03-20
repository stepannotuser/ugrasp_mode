## This file is part of the AEDVICES Simplified Edition.
##
## Copyright (c) 2025 AEDVICES Consulting SAS. All rights reserved.
##
## Licensed under the AEDVICES-SE-v1.0 (Public Use License - Simplified Edition).
## You may use, copy, and modify this file for personal/internal use only.
## Redistribution or commercial use is prohibited without a separate license.
##
## See LICENSE.txt or contact contact@aedvices.com for more information.
##


from py.generator.base_generator import base_generator 
import os


class uvm_sequence_generator(base_generator):
  def __init__(self):
    fname = "svgraph_sequence.sv"
    
    
  def generate(self,db,args):
    outdir    = "."        if args["out_dir"]   == None else args["out_dir"]
    classname = "svgraph"  if args["classname"] == None else args["classname"]
    first_state   = args["first_state"]
    no_covergroup = args["no_covergroup"]

    self.db        = db 
    self.classname = classname
    self.outdir    = outdir
    self.first_state = first_state
    self.no_covergroup  = no_covergroup
    self.sequence_item  = args["sequence_item"]
    self.import_package = args["import_package"]
    self.__START__  = args["pre_run_state_name"]  # Name of the start node
    self.__END__    = args["post_run_state_name"] # Name of the end

    if ( "per_instance" in args ):
      self.per_instance = args["per_instance"].lower()
    else:
      self.per_instance = None

    if ( not os.path.isdir(self.outdir) ):
      os.makedirs(self.outdir)

    # The main package
    f = self.open("_pkg.sv")
    self.write_package(f)
    f.close()

    # Types, mostly the state enumarated type
    f = self.open("_types.svh")
    self.write_types(f)
    f.close()


    # Reuse able coveragroups
    if not self.no_covergroup :
      f = self.open("_covergroups.svh")
      self.write_covergroups(f)
      f.close()

    # Base sequence definition
    f = self.open("_base_sequence.svh")
    self.write_base_class_definition(f)
    f.close()

    # Base sequence implementation
    f = self.open("_base_sequence.sv")
    self.write_base_class_implementation(f)
    f.close()

    # Main sequence Definition
    f = self.open("_sequence.svh")
    self.write_main_class_definition(f)
    f.close()

    # Main sequence implementation
    f = self.open("_sequence.sv")
    self.write_main_class_implementation(f)
    f.close()

    # Main sequence implementation
    f = self.open("_checker.svh")
    self.write_checker_decl(f)
    f.close()

    # Main sequence implementation
    f = self.open("_checker.sv")
    self.write_checker_imp(f)
    f.close()

  def open(self,suffix):
    """
      Open the file
    """
    # TODO: some precaution to check that PATH is valid
    fname = self.classname + suffix
    full_filename = os.path.join(os.path.abspath(self.outdir),fname)
    f = open(full_filename,"w")

    self.header(f,suffix)

    return f



  def write_package(self,file):
    """
      Package Content
    """
    self.write(file,0,f"package {self.classname}_pkg;\n\n")
    self.write(file,1,f"\n")
    self.write(file,1,f"`include \"uvm_macros.svh\"\n")
    self.write(file,1,f"import uvm_pkg::*;\n")

    if ( self.import_package != None and self.import_package.strip() != "" ):
      self.write(file,1,f"import " + self.import_package.strip() + "::*;\n")


    self.write(file,1,f"\n")
    self.write(file,1,f"`include \"{self.classname}_types.svh\"\n")
    if not self.no_covergroup :
      self.write(file,1,f"`include \"{self.classname}_covergroups.svh\"\n")
    self.write(file,1,f"\n")
    self.write(file,1,f"`include \"{self.classname}_base_sequence.svh\"\n")
    self.write(file,1,f"`include \"{self.classname}_sequence.svh\"\n")
    self.write(file,1,f"`include \"{self.classname}_checker.svh\"\n")
    self.write(file,1,f"\n")
    self.write(file,1,f"`include \"{self.classname}_base_sequence.sv\"\n")
    self.write(file,1,f"`include \"{self.classname}_sequence.sv\"\n")
    self.write(file,1,f"`include \"{self.classname}_checker.sv\"\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"endpackage : {self.classname}_pkg\n")
    self.write(file,0,f"\n")


  def write_types(self,file):
    """
      Type Declarations
    """
    self.write(file,0,f"// State Enumerated Type \n")
    self.write(file,0,f"typedef enum integer {{\n")
    self.write(file,1,f"UNKNOWN = 0    // Allows to handle coverage to unkown states in your monitors\n")
    for idx,state in enumerate(self.db):
      if idx == 0:
        self.write(file,1,f",{state.strip()} = 1\n")    
      else:
        self.write(file,1,f",{state.strip()}\n") 
    self.write(file,0,f"}} {self.classname}_state_t;\n\n")


  def write_covergroups(self,file):
    """
      Reusable covergroups
    """
    # Covergroup
    nr_transitions = 0
    for idx,state in enumerate(self.db):
      nr_transitions += len(self.db[state])

    self.write(file,0,"\n")
    self.write(file,0,"// Global Coverage is reached when all state and transitions are covered\n")
    if ( self.per_instance == "param" ):
      self.write(file,1,f"covergroup {self.classname}_cg (bit is_per_instance=1) with function sample({self.classname}_state_t current_state);\n")
    else:
      self.write(file,1,f"covergroup {self.classname}_cg with function sample({self.classname}_state_t current_state);\n")
    self.write(file,0,"\n")
    if ( self.per_instance == "param" ):
      self.write(file,2,"option.per_instance = is_per_instance;\n")
    elif ( self.per_instance == "yes" ):
      self.write(file,2,"option.per_instance = 1;\n")
    else:
      self.write(file,2,"option.per_instance = 0;\n")
    self.write(file,0,"\n")

    # State Coverage
    self.write(file,2,f"// State coverage\n")
    self.write(file,2,f"states : coverpoint current_state {{\n")
    self.write(file,3,f"option.goal     = 100;\n")
    self.write(file,3,f"option.weight   = {nr_transitions}; //< The weight is set to the number of transitions so that states have as much weight as the all transations together\n")
    self.write(file,3,f"option.at_least = 10;\n")
    self.write(file,3,f"bins state      [] = {{ ")
    for idx,state in enumerate(self.db):
      _state = state.strip()
      if self.__START__ != None and _state == self.__START__: # Ignore the extra start state from coverage as it is not recorded
        continue
      if idx == 0: 
        self.write(file,0,f"{_state}")    
      else:
        self.write(file,0,f",{_state}")
    self.write(file,0,f" }};\n")
    self.write(file,3,f"ignore_bins unknown = {{ UNKNOWN }};\n")
    self.write(file,2,f"}}\n\n")

    # Transition Coverage
    self.write(file,2,f"// Global Transition Coverage\n")
    self.write(file,2,f"transitions : coverpoint current_state {{\n")
    self.write(file,3,f"option.goal     = 100;\n")
    self.write(file,3,f"option.weight   = {nr_transitions}; //< The weight is set to the number of transitions so that states have as much weight as the all transations together\n")
    self.write(file,3,f"option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.\n")
    self.write(file,3,f"bins transition[] =\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      if self.__START__ != None and _start == self.__START__: # Ignore the extra start state from coverage as it is not recorded
        continue

      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        if self.__START__ != None and _end == self.__START__: # Ignore the extra start state from coverage as it is not recorded
          continue
        if idx == 0 and jdx==0:
          self.write(file,4,f" ({_start} => {_end})\n")    
        else:
          self.write(file,4,f",({_start} => {_end})\n")    
    self.write(file,0,f";")
    self.write(file,2,f"}}\n\n")

    # Transition Coverage - one coverpoint per edge
    self.write(file,4,f"// Individual Edge Coverpoints, allow fine grain objective setup\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      if self.__START__ != None and _start == self.__START__: # Ignore the extra start state from coverage as it is not recorded
        continue

      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        if self.__START__ != None and _end == self.__START__: # Ignore the extra start state from coverage as it is not recorded
          continue
        self.write(file,2,f"{_start}_to_{_end} : coverpoint current_state {{\n")
        self.write(file,3,f"option.goal     = 100;\n")
        self.write(file,3,f"option.weight   = 1;\n")
        self.write(file,3,f"option.at_least = 1; //< default objective is to cover every transition at least once. Can be overridden by users.\n")
        self.write(file,3,f"bins {_start}_to_{_end} = ( {_start} => {_end} ); \n")
        self.write(file,2,f"}}\n")
    
    self.write(file,0,f"\n")
    self.write(file,1,f"endgroup\n\n")



  def write_base_class_definition(self,file):
    """
      Base Class Declaration
    """
    uvm_sequence_name = "uvm_sequence"
    if ( self.sequence_item != None and self.sequence_item.strip() != "" ):
      uvm_sequence_name = "uvm_sequence#(" + self.sequence_item.strip() + ")"


    if ( self.per_instance == "param" ):
      self.write(file,0,f"class {self.classname}_base_sequence#(PER_INSTANCE_COVERAGE=1) extends {uvm_sequence_name};\n")
    else:
      self.write(file,0,f"class {self.classname}_base_sequence extends {uvm_sequence_name};\n")
    self.write(file,1,f"\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// protected internal variables\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"local     int unsigned local_curr_iter_idx = 0;  ///< Current Iteration Index. Incremented on each new state\n")
    self.write(file,1,f"protected int unsigned weight_end = 0;           ///< Exit criteria. When 0, no exit from normal flow is possible\n")
    self.write(file,1,f"protected bit          randomization_done = 0;   ///< Randomization done flag\n")     
    self.write(file,1,f"\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// public constrainable settings\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"rand int unsigned max_iter;                           ///< maximum number of iterations. When reached, the graph completes\n")
    self.write(file,1,f"rand int unsigned initial_edge_weight = 100;          ///< constrainable initial default weight for each edge\n")
    self.write(file,1,f"rand bit          coverage_closure_en = 0;            ///< constrainable coverage closure configuration. When 1, graph will exit when the coverage reaches 100%\n")
    self.write(file,1,f"rand int unsigned weight_default_decrement = 1;       ///< constrainable decrement of the weight of the edge each time it is executed\n")
    self.write(file,1,f"rand int unsigned coverage_default_edge_at_least = 1; ///< constrainable. Each edge should be covered at least this number of times\n")
    self.write(file,1,f"rand int unsigned weight[{self.classname}_state_t][{self.classname}_state_t]; //< constrainable weights for each possible edge. Initial value set to 'initial_edge_weight'\n\n")
    self.write(file,1,f"\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// Coverage\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"protected {self.classname}_state_t current_state;\n")
    self.write(file,1,f"protected {self.classname}_state_t previous_state;\n")
    if not self.no_covergroup :
      self.write(file,1,f"{self.classname}_cg cg;\n")
    self.write(file,1,f"extern virtual           function int          get_custom_coverage();\n")
    self.write(file,1,f"\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// GoTo & Edge Management\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"protected {self.classname}_state_t goto_next_state; // where to go\n")
    self.write(file,1,f"protected {self.classname}_state_t goto_from_state; // where from\n")
    self.write(file,1,f"protected int unsigned goto_saved_weight[{self.classname}_state_t]; // saved weight of the source before going\n")
    self.write(file,1,f"protected bit          goto_activated = 0; // got is activated\n")
    self.write(file,1,f"extern virtual protected function void prepare_context();\n")
    self.write(file,1,f"extern virtual           function void goto({self.classname}_state_t next);\n")
    
    self.write(file,1,f"extern virtual           function void exit();\n")
    self.write(file,1,f"extern virtual           function void exclude_next({self.classname}_state_t next);\n")
    self.write(file,1,f"extern virtual           function void include_next({self.classname}_state_t next,int unsigned _weight=initial_edge_weight);\n")
    self.write(file,1,f"extern virtual           function void exclude_edge({self.classname}_state_t src,dst);\n")
    self.write(file,1,f"extern virtual           function void include_edge({self.classname}_state_t src,dst,int unsigned _weight=initial_edge_weight);\n")

    self.write(file,1,f"extern virtual           function int unsigned get_current_iteration();\n")
    self.write(file,1,f"extern virtual           function {self.classname}_state_t get_current_state();\n")
    self.write(file,1,f"extern virtual           function {self.classname}_state_t get_previous_state();\n")

    self.write(file,1,f"\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"/// Constructor\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"extern function          new(string name=\"{self.classname}_base_sequence\");\n")
    self.write(file,1,f"extern function          void post_randomize();\n")
    self.write(file,1,f"\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// protected management functions and tasks\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"extern virtual protected function void         init_weight(int unsigned _w);\n")
    self.write(file,1,f"extern virtual protected function int unsigned get_uint_value(int unsigned value);\n")
    self.write(file,1,f"extern virtual protected function void         update_transition({self.classname}_state_t _src, _dst);\n")

    self.write(file,1,f"\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// default constraints\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"/* extern */ constraint svgraph_base_sequence_default_c;\n")
    self.write(file,1,f"\n")    
    self.write(file,1,f"`uvm_object_utils_begin({self.classname}_base_sequence)\n")
    self.write(file,2,f"`uvm_field_int(max_iter                 , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )\n") 
    self.write(file,2,f"`uvm_field_int(initial_edge_weight      , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )\n")  
    self.write(file,2,f"`uvm_field_int(coverage_closure_en      , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )\n")  
    self.write(file,2,f"`uvm_field_int(weight_default_decrement , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )\n")  
    self.write(file,2,f"`uvm_field_int(coverage_default_edge_at_least    , UVM_DEFAULT | UVM_DEC | UVM_NOCOMPARE )\n")  
    self.write(file,1,f"`uvm_object_utils_end\n")
    self.write(file,1,f"\n")
    self.write(file,0,f"endclass : {self.classname}_base_sequence\n")

  def write_base_class_implementation(self,file):
    """
      Base Class Implementation
    """
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"/// Constructor\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function {self.classname}_base_sequence::new(string name=\"{self.classname}_base_sequence\");\n")
    self.write(file,1,f"local_curr_iter_idx = 0;\n")
    self.write(file,1,f"weight_end = 0;\n")
    self.write(file,1,f"init_weight(initial_edge_weight);\n")
    if not self.no_covergroup :
      if ( self.per_instance == "param" ):
        self.write(file,1,f"cg = new(.is_per_instance(PER_INSTANCE_COVERAGE));\n")
      else:
        self.write(file,1,f"cg = new();\n")
    self.write(file,0,f"endfunction : new\n\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// configure the covergroup goals depending on constraint setup\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::post_randomize();\n")
    self.write(file,1,f"int unsigned _at_least_value = this.coverage_default_edge_at_least;\n")
    self.write(file,1,f"int unsigned _cover_weight   = 1;\n")
    self.write(file,1,f"foreach (weight[src,dst]) begin\n")
    self.write(file,2,f"// user made this edge as 0, so it's not a target\n")
    self.write(file,2,f"_at_least_value = (weight[src][dst] == 0) ? 1 : this.coverage_default_edge_at_least;\n")
    self.write(file,2,f"_cover_weight   = (weight[src][dst] == 0) ? 0 : 1;\n")
    self.write(file,0,f"\n")
    if not self.no_covergroup :
      self.write(file,2,f"// setup individual edge coverpoint target\n")
      self.write(file,2,f"case ({{src,dst}})\n")
      for idx,state in enumerate(self.db):
        _start = state.strip()
        if self.__START__ != None and _start == self.__START__: # Ignore the extra start state from coverage as it is not recorded
          continue
        for jdx,nextstate in enumerate(self.db[state]):
          _end   = nextstate.strip()
          if self.__START__ != None and _end == self.__START__: # Ignore the extra start state from coverage as it is not recorded
            continue
          self.write(file,3,f"{{{_start},{_end}}} : begin cg.{_start}_to_{_end}.option.weight = _cover_weight; cg.{_start}_to_{_end}.option.at_least = _at_least_value; end\n")    
      self.write(file,3,f"endcase\n")
    self.write(file,2,f"end\n")
    self.write(file,0,f"//\n")
    self.write(file,1,f"// Allow the body() to run. If not a fatal is triggered.\n")
    self.write(file,1,f"randomization_done = 1;\n")
    self.write(file,0,f"endfunction :  post_randomize\n\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// protected management functions and tasks\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"/// weight initialization, called by the constructor\n")
    self.write(file,0,f"/// Defined in the graph class as it requires the state to be defined.\n")
    self.write(file,0,f"/// Should be pure virtual but some tools don't like pure virtual UVM classes\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::init_weight(int unsigned _w);\n")
    self.write(file,1,f"{self.classname}_state_t src,dst; \n")
    self.write(file,1,f"if ( _w > 0 ) weight_end = 0 ;\n")
    self.write(file,1,f"else          weight_end = 100;\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        self.write(file,2,f"weight[{_start}][{_end}] = _w;\n")
    self.write(file,0,f"endfunction : init_weight\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// Value getter to be used in directed constraints\n")
    self.write(file,0,f"function int unsigned {self.classname}_base_sequence::get_uint_value(int unsigned value);\n")
    self.write(file,1,f"return value;\n")
    self.write(file,0,f"endfunction : get_uint_value\n\n")
    self.write(file,0,f"// curr_iter_idx getter\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function int unsigned {self.classname}_base_sequence::get_current_iteration();\n")
    self.write(file,1,f"return local_curr_iter_idx;\n")
    self.write(file,0,f"endfunction : get_current_iteration\n\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function {self.classname}_state_t {self.classname}_base_sequence::get_current_state();\n")
    self.write(file,1,f"return current_state;\n")
    self.write(file,0,f"endfunction : get_current_state\n")
    self.write(file,0,f"function {self.classname}_state_t {self.classname}_base_sequence::get_previous_state();\n")
    self.write(file,1,f"return previous_state;\n")
    self.write(file,0,f"endfunction : get_previous_state\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// Coverage\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"/// Users may override it to implement their own coverage\n")
    self.write(file,0,f"function int {self.classname}_base_sequence::get_custom_coverage();\n")
    self.write(file,1,f"return 100;\n")
    self.write(file,0,f"endfunction : get_custom_coverage\n\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// we need to perform some maintenance each time a transition is made\n")
    self.write(file,0,f"// cannot be in the base class because of the dependency on {self.classname}_state_t\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::update_transition({self.classname}_state_t _src, _dst);\n")
    self.write(file,1,f"previous_state = current_state;\n")
    self.write(file,1,f"current_state = _dst;\n")
    self.write(file,1,f"weight[_src][_dst] = weight[_src][_dst] > weight_default_decrement ? weight[_src][_dst] - weight_default_decrement : 1;\n")
    self.write(file,1,f"local_curr_iter_idx += 1;\n")
    if not self.no_covergroup :
      self.write(file,1,f"// Record coverage\n")
      self.write(file,1,f"cg.sample(current_state);\n")
      self.write(file,1,f"// End of seqquence exit criteria\n")
      self.write(file,1,f"if ( ( local_curr_iter_idx >= max_iter ) || \n")
      self.write(file,1,f"   ( coverage_closure_en && (cg.get_coverage() == 100 && get_custom_coverage() == 100) ) ) \n")
      self.write(file,1,f"begin \n")
      self.write(file,2,f"init_weight(0);\n")
      self.write(file,2,f"weight_end = 100;\n")
      self.write(file,1,f"end\n")
    self.write(file,0,f"endfunction : update_transition\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// GoTo & Edge Management\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::goto({self.classname}_state_t next);\n")
    self.write(file,1,f"goto_next_state = next; // where we are going\n")
    self.write(file,1,f"goto_from_state = current_state; // save the source\n")
    self.write(file,1,f"goto_saved_weight = weight[goto_from_state]; // save the weight of the source\n")
    self.write(file,1,f"foreach (goto_saved_weight[st]) begin\n")
    self.write(file,2,f"if ( st == goto_next_state )\n")
    self.write(file,3,f"goto_activated = 1;\n")
    self.write(file,2,f"else\n")
    self.write(file,3,f"weight[goto_from_state][st] = 0; // set all the destination to 0, except the one we are going to\n")
    self.write(file,1,f"end\n")
    self.write(file,1,f"if ( ! goto_activated ) begin \n")
    self.write(file,2,f"// we are actually not going anywhere\n")
    self.write(file,2,f"// restore the weights\n")
    self.write(file,2,f"weight[goto_from_state] = goto_saved_weight;\n")
    self.write(file,1,f"end\n")
    self.write(file,0,f"endfunction : goto\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::prepare_context();\n")
    self.write(file,1,f"if ( goto_activated ) begin \n")
    self.write(file,2,f"goto_activated = 0;\n")
    self.write(file,2,f"weight[goto_from_state] = goto_saved_weight;\n")
    self.write(file,1,f"end\n")
    self.write(file,0,f"endfunction : prepare_context\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::exit();\n")
    self.write(file,1,f"init_weight(0);\n")
    self.write(file,1,f"weight_end = 100;\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"endfunction : exit\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::exclude_next({self.classname}_state_t next);\n")
    self.write(file,1,f"if (next inside {{weight[current_state]}} )\n")
    self.write(file,2,f"weight[current_state][next] = 0;\n")
    self.write(file,1,f"else\n")
    self.write(file,2,f"`uvm_warning(\"INVALID_EDGE\",$sformatf(\"Invalid edge from %s to %s while trying to exclude the next state %s\",current_state,next,next))\n")
    self.write(file,0,f"endfunction : exclude_next\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::include_next({self.classname}_state_t next,int unsigned _weight=initial_edge_weight);\n")
    self.write(file,1,f"if (next inside {{weight[current_state]}} )\n")
    self.write(file,2,f"weight[current_state][next] = _weight;\n")
    self.write(file,1,f"else\n")
    self.write(file,2,f"`uvm_warning(\"INVALID_EDGE\",$sformatf(\"Invalid edge from %s to %s while trying to include the next state %s\",current_state,next,next))\n")
    self.write(file,0,f"endfunction : include_next\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::exclude_edge({self.classname}_state_t src,dst);\n")
    self.write(file,1,f"if (dst inside {{weight[src]}} )\n")
    self.write(file,2,f"weight[src][dst] = 0;\n")
    self.write(file,1,f"else\n")
    self.write(file,2,f"`uvm_warning(\"INVALID_EDGE\",$sformatf(\"Invalid edge from %s to %s while trying to include the next state %s\",src,dst,dst))\n")
    self.write(file,0,f"endfunction : exclude_edge\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function void {self.classname}_base_sequence::include_edge({self.classname}_state_t src,dst,int unsigned _weight=initial_edge_weight);\n")
    self.write(file,1,f"if (dst inside {{weight[src]}} )\n")
    self.write(file,2,f"weight[src][dst] = _weight;\n")
    self.write(file,1,f"else\n")
    self.write(file,2,f"`uvm_warning(\"INVALID_EDGE\",$sformatf(\"Invalid edge from %s to %s while trying to include the state %s\",src,dst,dst))\n")
    self.write(file,0,f"endfunction : include_edge\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// default constraints\n")
    self.write(file,0,f"// ----------------------------------------------\n")

    self.write(file,0,f"constraint {self.classname}_base_sequence::svgraph_base_sequence_default_c {{\n")
    self.write(file,1,f"weight_default_decrement < initial_edge_weight;\n\n")
    self.write(file,1,f"soft max_iter                 == 1_000; //< Maximum default number off iterations \n")
    self.write(file,1,f"soft coverage_closure_en      == 0;     //< Coverage Closure is disable by default\n")
    self.write(file,1,f"soft coverage_default_edge_at_least    == 1;     //< coverage_default_edge_at_least\n")
    self.write(file,1,f"soft initial_edge_weight      == 100;   //< Default Weight for each edge\n")
    self.write(file,1,f"soft weight_default_decrement == 1;     //< weight_default_decrement\n")
    self.write(file,0,f"}}\n")



  def write_main_class_definition(self,file):
    """
      Create the class
    """
    if ( self.per_instance == "param" ):
      self.write(file,0,f"class {self.classname}_sequence#(PER_INSTANCE_COVERAGE=1) extends {self.classname}_base_sequence#(.PER_INSTANCE_COVERAGE(PER_INSTANCE_COVERAGE));\n")
    else:
      self.write(file,0,f"class {self.classname}_sequence extends {self.classname}_base_sequence;\n")
    self.write(file,1,f"`uvm_object_utils({self.classname}_sequence)\n\n")

    self.write(file,1,f"// Constructor \n")
    self.write(file,1,f"extern function new(string name=\"{self.classname}_sequence\");\n")
    self.write(file,0,f"\n")

    self.write(file,1,f"// Default edge weight. Users may want to overconstrain in a child class\n")
    self.write(file,1,f"constraint {self.classname}_default_c {{\n")
    self.write(file,2,f"foreach (weight[src,dst]) {{\n")
    self.write(file,3,f"soft weight[src][dst] == get_uint_value(initial_edge_weight);\n")
    self.write(file,2,f"}}\n")
    self.write(file,1,f"}}\n")
    self.write(file,0,f"\n")

    # post randomize
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// Common body tasks\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// completion is called when the graph exists\n")
    self.write(file,1,f"extern virtual function void completion_pre_body(); \n")
    self.write(file,1,f"extern virtual task          completion_body(); \n")
    self.write(file,1,f"extern virtual function void completion_post_body();\n")
    self.write(file,0,f"\n")
    self.write(file,1,f"// state_body(state) is called in parallal to any <state>_body() task.\n")
    self.write(file,1,f"// this allows to handles states in a more generic way\n")
    self.write(file,1,f"extern virtual function void state_pre_body({self.classname}_state_t state);\n")    
    self.write(file,1,f"extern virtual task          state_body({self.classname}_state_t state);\n")    
    self.write(file,1,f"extern virtual function void state_post_body({self.classname}_state_t state);\n")    
    self.write(file,0,f"\n")
    self.write(file,1,f"// transition_body(src,dst) is called in parallal to any <transition>_body() task.\n")
    self.write(file,1,f"// this allows to handles transition in a more generic way\n")
    self.write(file,1,f"extern virtual function void transition_pre_body({self.classname}_state_t src,dst);\n")    
    self.write(file,1,f"extern virtual task          transition_body({self.classname}_state_t src,dst);\n")    
    self.write(file,1,f"extern virtual function void transition_post_body({self.classname}_state_t src,dst);\n")    
    self.write(file,0,f"\n")
    self.write(file,1,f"/// ----------------------------------------------\n")
    self.write(file,1,f"/// Utility Functions\n")
    self.write(file,1,f"/// ----------------------------------------------\n")
    self.write(file,1,f"// goto(): to be called in a state to control what is the next state\n")
    self.write(file,1,f"extern virtual function void goto({self.classname}_state_t next);\n\n")
    self.write(file,1,f"// exit(): to be called at anytime to force to go to completion\n")
    self.write(file,1,f"extern virtual function void exit();\n\n")
    self.write(file,1,f"// exclude_next(): to be called in a state to exclude one of the next from possible choices\n")
    self.write(file,1,f"extern virtual function void exclude_next({self.classname}_state_t next);\n\n")
    self.write(file,1,f"// include_next(): to be called in a state to include one of the next within possible choices\n")
    self.write(file,1,f"extern virtual function void include_next({self.classname}_state_t next,\n")
    self.write(file,1,f"                                          int unsigned _weight=initial_edge_weight);\n\n")
    self.write(file,1,f"// exclude_edge(): to be called anywhere, to exclude any edge\n")
    self.write(file,1,f"extern virtual function void exclude_edge({self.classname}_state_t src,dst);\n\n")
    self.write(file,1,f"// include_edge(): to be called anywhere, to include any edge\n")
    self.write(file,1,f"extern virtual function void include_edge({self.classname}_state_t src,dst,\n")
    self.write(file,1,f"                                          int unsigned _weight=initial_edge_weight);\n")
    self.write(file,0,f"\n")

    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// State tasks and functions hooks\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// Use these to perform actions when you are expected to be in or to go to a state\n")
    self.write(file,1,f"// You may use goto(state) include_next(state) or include_next(state) from these\n")
    self.write(file,1,f"// You may use exclude_edge(src,dst) or include_edge(src,dst) from these\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      self.write(file,1,f"extern virtual function void {_start}_pre_body();\n")    
    self.write(file,0,f"\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      self.write(file,1,f"extern virtual task          {_start}_body();\n")    
    self.write(file,0,f"\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      self.write(file,1,f"extern virtual function void {_start}_post_body();\n")    
    self.write(file,0,f"\n")

    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// Transition tasks and functions hooks\n")
    self.write(file,1,f"// ----------------------------------------------\n")
    self.write(file,1,f"// Use these to perform actions to move to the destination state\n")
    self.write(file,1,f"// You may use exclude_edge(src,dst) or include_edge(src,dst) from these\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        self.write(file,1,f"extern virtual function void {_start}_to_{_end}_pre_body();\n")    
    self.write(file,0,f"\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        self.write(file,1,f"extern virtual task          {_start}_to_{_end}_body();\n")    
    self.write(file,0,f"\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        self.write(file,1,f"extern virtual function void {_start}_to_{_end}_post_body();\n")    
    self.write(file,0,f"\n")

    self.write(file,1,f"extern virtual task body();\n")
    self.write(file,0,f"endclass : {self.classname}_sequence\n")

  def write_main_class_implementation(self,file):
    """

    """
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// Constructor \n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"function {self.classname}_sequence::new(string name=\"{self.classname}_sequence\");\n")
    self.write(file,1,f"super.new(name);\n")
    self.write(file,0,f"endfunction : new\n\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// Utility Functions \n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"function void {self.classname}_sequence::goto({self.classname}_state_t next);\n")
    self.write(file,0,f"  super.goto(next);\n")
    self.write(file,0,f"endfunction : goto\n\n")
    self.write(file,0,f"function void {self.classname}_sequence::exit();\n")
    self.write(file,0,f"  super.exit();\n")
    self.write(file,0,f"endfunction : exit\n\n")
    self.write(file,0,f"function void {self.classname}_sequence::exclude_next({self.classname}_state_t next);\n")
    self.write(file,0,f"  super.exclude_next(next);\n")
    self.write(file,0,f"endfunction : exclude_next\n\n")
    self.write(file,0,f"function void {self.classname}_sequence::include_next({self.classname}_state_t next,int unsigned _weight=initial_edge_weight);\n")
    self.write(file,0,f"  super.include_next(next);\n")
    self.write(file,0,f"endfunction : include_next\n\n")
    self.write(file,0,f"function void {self.classname}_sequence::exclude_edge({self.classname}_state_t src,dst);\n")
    self.write(file,0,f"  super.exclude_edge(src,dst);\n")
    self.write(file,0,f"endfunction : exclude_edge\n\n")
    self.write(file,0,f"function void {self.classname}_sequence::include_edge({self.classname}_state_t src,dst,int unsigned _weight=initial_edge_weight);\n")
    self.write(file,0,f"  super.include_edge(src,dst);\n")
    self.write(file,0,f"endfunction : include_edge\n\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// Common tasks and functions hooks\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"function void {self.classname}_sequence::state_pre_body({self.classname}_state_t state); \nendfunction\n")    
    self.write(file,0,f"task          {self.classname}_sequence::state_body({self.classname}_state_t state); \nendtask\n")    
    self.write(file,0,f"function void {self.classname}_sequence::state_post_body({self.classname}_state_t state);\nendfunction\n\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function void {self.classname}_sequence::transition_pre_body({self.classname}_state_t src,dst); \nendfunction\n")    
    self.write(file,0,f"task          {self.classname}_sequence::transition_body({self.classname}_state_t src,dst); \nendtask\n")    
    self.write(file,0,f"function void {self.classname}_sequence::transition_post_body({self.classname}_state_t src,dst);\nendfunction\n\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// State tasks and functions hooks\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      self.write(file,0,f"// STATE:{state} Hooks to be implemented in children classes\n")
      self.write(file,0,f"function void {self.classname}_sequence::{_start}_pre_body();\nendfunction\n")    
      self.write(file,0,f"task          {self.classname}_sequence::{_start}_body();\nendtask\n")    
      self.write(file,0,f"function void {self.classname}_sequence::{_start}_post_body();\nendfunction\n\n")    

    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// Transition tasks and functions hooks\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        self.write(file,0,f"// TRANSITION:{_start} to {_end}: Hooks to be implemented in children classes\n")
        self.write(file,0,f"function void {self.classname}_sequence::{_start}_to_{_end}_pre_body();\nendfunction\n")    
        self.write(file,0,f"task          {self.classname}_sequence::{_start}_to_{_end}_body();\nendtask\n")    
        self.write(file,0,f"function void {self.classname}_sequence::{_start}_to_{_end}_post_body();\nendfunction\n\n")    

    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// Completion hook\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"function void {self.classname}_sequence::completion_pre_body(); \n")
    self.write(file,1,f"`uvm_info(\"completion_body\",\"completion_pre_body called\",UVM_MEDIUM);\n")
    self.write(file,0,f"endfunction \n")
    self.write(file,0,f"task {self.classname}_sequence::completion_body(); \n")
    self.write(file,1,f"`uvm_info(\"completion_body\",\"completion_body called\",UVM_MEDIUM);\n")
    self.write(file,0,f"endtask \n")
    self.write(file,0,f"\n")
    self.write(file,0,f"// Show coverage at the end of the sequence\n")
    self.write(file,0,f"function void {self.classname}_sequence::completion_post_body();\n")
    self.write(file,2,f"`uvm_info(\"completion_post_body\",\"==================\",UVM_MEDIUM);\n")
    self.write(file,2,f"`uvm_info(\"completion_post_body\",\"Completion        \",UVM_MEDIUM);\n")
    self.write(file,2,f"`uvm_info(\"completion_post_body\",\"==================\",UVM_MEDIUM);\n")
    self.write(file,2,f"`uvm_info(\"completion_post_body\",$sformatf(\"- nr of iterations : %d\",this.get_current_iteration()),UVM_MEDIUM);\n")
    self.write(file,2,f"if ( get_current_iteration() >= max_iter )\n")
    self.write(file,3,f"`uvm_info(\"completion_post_body\",$sformatf(\"- Max iterations %d reached\",this.max_iter),UVM_MEDIUM);\n")
    if not self.no_covergroup :
      self.write(file,1,f"`uvm_info(\"completion_post_body\",\"- state      coverage: %d %%\",cg.states.get_coverage());\n")
      self.write(file,1,f"`uvm_info(\"completion_post_body\",\"- transition coverage: %d %%\",cg.transitions.get_coverage());\n")
      self.write(file,1,f"`uvm_info(\"completion_post_body\",\"- Total      coverage: %d %%\",cg.get_coverage());\n")
    self.write(file,0,f"endfunction\n")
    self.write(file,0,f"\n")


    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"// Graph Based Sequence body\n")
    self.write(file,0,f"// ----------------------------------------------\n")
    self.write(file,0,f"task {self.classname}_sequence::body();\n")

    self.write(file,1,f"if (!randomization_done)\n")
    self.write(file,1,f"`uvm_fatal(\"F_NORAND\",\"Sequence not randomized. Please randomize the sequence before calling start()\")\n")

    if self.__START__ == None:
      self.write(file,1,f"randsequence()\n")
    else:
      self.write(file,1,f"randsequence({self.__START__})\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      self.write(file,2,f"{_start} : {_start}_act {_start}_sel;\n")
    self.write(file,0,f"\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      self.write(file,2,f"{_start}_act : {{\n")
      self.write(file,3,f"prepare_context();\n")
      self.write(file,3,f"fork {_start}_pre_body(); state_pre_body({_start}); join\n")
      self.write(file,3,f"fork {_start}_body(); state_body({_start}); join\n")
      self.write(file,3,f"fork {_start}_post_body(); state_post_body({_start}); join\n")
      self.write(file,2,f"}};\n")
    self.write(file,0,f"\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      self.write(file,2,f"{_start}_sel : _END_:=weight_end")
      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        self.write(file,0,f" | {_start}_to_{_end}:=weight[{_start}][{_end}]")
      self.write(file,0,f";\n")
    self.write(file,0,f"\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        self.write(file,2,f"{_start}_to_{_end} : {{ \n")
        self.write(file,3,f"prepare_context();\n")
        self.write(file,3,f"fork {_start}_to_{_end}_pre_body(); transition_pre_body({_start},{_end}); join\n")
        self.write(file,3,f"fork {_start}_to_{_end}_body(); transition_body({_start},{_end}); join\n")
        self.write(file,3,f"fork {_start}_to_{_end}_post_body(); transition_post_body({_start},{_end}); join\n")
        self.write(file,3,f"update_transition({_start},{_end});\n")
        self.write(file,2,f"}} /* ... to ... */ {_end};\n")
    self.write(file,2,f"_END_ : {{ completion_pre_body(); completion_body(); completion_post_body();}};\n")
    self.write(file,1,f"endsequence\n")
    self.write(file,0,f"endtask : body\n")


  def write_checker_decl(self,file):
    self.write(file,0,f"\n")
    self.write(file,0,f"class {self.classname}_checker extends uvm_component;\n")
    self.write(file,1,f"`uvm_component_utils({self.classname}_checker)\n")
    self.write(file,0,f"\n")
    self.write(file,1,f"extern function new(string name=\"{self.classname}_checker\" , uvm_component parent=null);\n")
    self.write(file,0,f"\n")
    self.write(file,1,f"extern static function bit is_valid_transition({self.classname}_state_t src,dst);\n")
    self.write(file,0,f"\n")
    self.write(file,1,f"extern        function void check_transition({self.classname}_state_t src,dst);\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"endclass : {self.classname}_checker \n")

  def write_checker_imp(self,file):
    self.write(file,0,f"\n")
    self.write(file,0,f"function {self.classname}_checker::new(string name=\"{self.classname}_checker\" , uvm_component parent=null);\n")
    self.write(file,1,f"super.new(name,parent);\n")
    self.write(file,0,f"endfunction : new\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function bit {self.classname}_checker::is_valid_transition({self.classname}_state_t src,dst);\n")
    self.write(file,1,f"bit ret_val = 0;\n")
    self.write(file,1,f"case ({{src,dst}})\n")
    for idx,state in enumerate(self.db):
      _start = state.strip()
      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()
        self.write(file,2,f"{{{_start},{_end}}} : ret_val = 1;\n")    
    self.write(file,2,f"default: ret_val = 0;\n")
    self.write(file,1,f"endcase\n")
    self.write(file,0,f"endfunction : is_valid_transition\n")
    self.write(file,0,f"\n")
    self.write(file,0,f"function void {self.classname}_checker::check_transition({self.classname}_state_t src,dst);\n")
    self.write(file,1,f"ASSERT_{self.classname.upper()}_TRANSITION: assert (is_valid_transition(src,dst))\n")
    self.write(file,1,f"else `uvm_error(\"ASSERT_{self.classname.upper()}_TRANSITION\",$sformatf(\"Invalid transition from %s to %s\",src,dst))\n")
    self.write(file,0,f"endfunction : check_transition\n")
    self.write(file,0,f"\n")







