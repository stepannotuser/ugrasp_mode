#!/bin/env python3
#----------------------------------------------------------------------------------------------------------------------
# $Id$
#----------------------------------------------------------------------------------------------------------------------
##  Copyright (c) 2024-2025 - AEDVICES Consulting 
##  166B Rue du Rocher de Lorzier, 38430 Moirans  - France
##  www.aedvices.com
##  For any query contact AEDVICES Consulting: contact@aedvices.com
#----------------------------------------------------------------------------------------------------------------------
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
#----------------------------------------------------------------------------------------------------------------------
# Description: Entry point of svgraph program.
#----------------------------------------------------------------------------------------------------------------------

from py.parsers.base_parser import base_parser
from py.parsers.csv_parser  import csv_parser

from py.generator.base_generator          import base_generator 
from py.generator.uvm_sequence_generator  import uvm_sequence_generator
from py.generator.dot_generator           import dot_generator
from py.generator.dot_full_generator      import dot_full_generator

class svgraph_app:
  """
    Main SV Graph App
  """
  common_arguments = ["out_dir","classname","first_state","no_covergroup","allow_orphans"]

  parser_factory = {
    "in_csv" : csv_parser
  }

  gen_factory = {
    "gen_uvm"      : uvm_sequence_generator,
    "gen_dot"      : dot_generator,
    "gen_dot_full" : dot_full_generator,
  }

  graph = {}

  def __init__(self,args):
    """
        Constructor

        Args:
            args: associative arrays of arguments passed in command line
    """
    self.args  = args
    self.__START__ = args["pre_run_state_name"]  # Name of the start node
    self.__END__   = args["post_run_state_name"] # Name of the end node
    self.graph = {}
    self.parser = None
    self.first_states = [] if args["first_state"]==None else args["first_state"].replace(" ","").split(",")
    self.diagnostics = {
      "errors": {
        "message": []
      },
      "warnings" :{
        "message":  []
      },
      "info" :{
        "message":  []
      }
    }
    if len(self.first_states) == 0:
      self.warn("No first state is defined. The sequence assumes to start from any state of the graph as a first state.")

  def parse(self):
    # Check if any of the argument is in the parser factory
    for argname in self.args:
      # skip known generation arguments
      if argname in self.common_arguments:
        continue

      if ( argname in self.parser_factory and self.args[argname] != None):
        #print(f"argname = {argname} --> {self.args[argname]}")
        self.parser = self.parser_factory.get(argname,base_parser)()
        # a parser if found, we use only one
        break

    if self.parser == None:
      exit() # TODO: should raise an exception 

    # Read the file
    self.graph = self.parser.read(self.args[argname],self.args)

  def detect_orphans(self):
    orphans = []
    for current in self.graph:
      found = False
      for next in self.graph:
        if current in self.graph.get(next):
          found = True
      if not found:
        orphans.append(current)

    return orphans
  
  def detect_unreachable(self,start=None):
    if start == None:
      start=self.__START__
    unreachable = [node for node in self.graph]
    to_process = [start]
    unreachable.remove(start)
    while to_process:
      current = to_process.pop()
      for neighbor in self.graph[current]:
        if neighbor in unreachable:
          to_process.append(neighbor)
          unreachable.remove(neighbor)

    return unreachable


  def pre_gen(self):
    """      Pre Generation Function
        This function is called before the generation of the files.
        It will check the graph and add the __START__ node.
    """
    nodes = [node for node in self.graph]
    self.graph[self.__START__] = [] # need to be after user nodes in order not to have __START__ pointing on itself

    # Check if first states are defined and valid
    invalid_first_states = []
    for state in self.first_states :
      if not state in nodes :
        invalid_first_states.append(state)
        self.raise_error(f"Undefined first state {state}")

    # If first states are defined and valid, use them
    # Otherwise, use all nodes as possible first state
    if self.first_states and not invalid_first_states:
      self.graph[self.__START__] = self.first_states
    elif invalid_first_states:
      for state in self.first_states:
        if not state in invalid_first_states:
          self.graph[self.__START__].append(state)
    else : 
      self.graph[self.__START__] = nodes

    # If allow_orphans is set, add orphans to __START__
    if self.args['allow_orphans']:
      orphans = self.detect_orphans()
      for orphan in orphans:
        if not orphan in self.graph[self.__START__] and orphan!=self.__START__:
          self.graph[self.__START__].append(orphan)

    # Detect unreachable states and report them
    unreachable = self.detect_unreachable()
    if unreachable:
      for state in unreachable:
        self.warn(f"Unreachable state {state}")

    # Detect if there are any ending states
    ending_states = [state for state in self.graph if not self.graph[state]]
    if not ending_states:
      self.info(f"No final states are found. The sequence will loop until the maximum number of iterations or coverage is reached.")
    else:
      #self.graph[self.__END__] = []
      for state in ending_states:
        if state != self.__START__:
          #self.graph[state].append(self.__END__)
          self.info(f"State {state} is an ending state. Reaching it will terminate the sequence.")
      


  def generate(self):
    """
      Main Generation Function
    """
    # Generate Result
    for argname in self.args:
      # skip known generation arguments
      if argname in self.common_arguments:
        continue

      if ( argname in self.gen_factory and self.args[argname] != None):
        #print(f"argname = {argname} --> {self.args[argname]}")
        generator = self.gen_factory.get(argname,base_parser)()

        # generate files
        generator.generate(self.graph,self.args)
  
  def raise_error(self,message):
    """
      Add an error message to diagnostics
    """
    self.diagnostics["errors"]["message"].append(message)

  def warn(self,message):
    """ Add a warning message to diagnostics """
    self.diagnostics["warnings"]["message"].append(message)

  def info(self,message):
    """ Add an info message to diagnostics """
    self.diagnostics["info"]["message"].append(message)


  def report_diagnostics(self):
    """
      Report diagnostics
    """
    for m in self.diagnostics["info"]["message"]:
      print("Info: %s"%m)
    for m in self.diagnostics["warnings"]["message"]:
      print("Warning: %s"%m)
    for m in self.diagnostics["errors"]["message"]:
      print("Error: %s"%m)

  def main(self):
    """
      Main entry point of the application
    """
    self.parse()
    if self.graph:
      self.pre_gen()
      self.generate()
      self.report_diagnostics()
    

