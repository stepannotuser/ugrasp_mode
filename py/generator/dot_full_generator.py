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
import copy

class dot_full_generator(base_generator):
  def __init__(self):
    fname = "dot_generator.dot"

  def generate(self,db,args):
    outdir    = "."        if args["out_dir"]   == None else args["out_dir"]
    classname = "svgraph"  if args["classname"] == None else args["classname"]
    first_state = args["first_state"]

    self.db        = copy.deepcopy(db)
    self.classname = classname
    self.outdir    = outdir
    self.first_state = first_state
    self.__START__   = args["pre_run_state_name"]  # Name of the start node
    self.__END__     = args["post_run_state_name"] # Name of the end

    # Detect if there are any ending states
    ending_states = [state for state in self.db if not self.db[state]]
    if ending_states:
      self.db[self.__END__] = []
      for state in ending_states:
        if state != self.__START__:
          self.db[state].append(self.__END__)


    if ( not os.path.isdir(self.outdir) ):
      os.makedirs(self.outdir)

    # The main package
    f = self.open(f"_full_graphviz.dot")
    self.write_dot(f)
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
    

  def write_dot(self,file):
    self.write(file,0,"\n")
    self.write(file,0,f"digraph {self.classname} {{\n")
    self.write(file,1,f"pad=\"0.5\"\n")


    if ( self.__START__ != None ):
       self.write(file,1,f"{self.__START__} [label=\"{self.__START__}\" fillcolor=lightgrey style=filled];\n")
       self.write(file,1,f"{self.__START__} -> {self.__START__}_body;\n")

    for idx,state in enumerate(self.db):
      _start = state.strip()
      self.write(file,1,f"{_start}_body [label=\"{_start}_body()\" shape=box style=filled fillcolor=darkseagreen1];\n")
      self.write(file,1,f"{_start}_sel [label=\"\" shape=diamond height=\"0.3\" width=\"0.3\"];\n")
      self.write(file,1,f"{_start}_body -> {_start}_sel;\n")

      for jdx,nextstate in enumerate(self.db[state]):
        _end   = nextstate.strip()

        self.write(file,1,f"{_start}_to_{_end}_body [label=\"{_start}_to_{_end}_body()\" shape=box style=filled fillcolor=lightcyan];\n")
        self.write(file,1,f"{_start}_sel -> {_start}_to_{_end}_body\n") #[labelfloat=true label=\"weight\\n[{_start}][{_end}]\"];
        #self.write(file,1,f"{_end}_body [shape=box]\n")
        self.write(file,1,f"{_start}_to_{_end}_body -> {_end}_body;\n")

    
    self.write(file,0,f"}}\n")
