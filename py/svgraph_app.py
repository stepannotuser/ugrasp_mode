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

__START__ = "__START__" # Name of the start node
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
    self.graph = {}
    self.parser = None
    self.first_states = [] if args["first_state"]==None else args["first_state"].replace(" ","").split(",")
    self.diagnostics = {
      "errors": {
        "has" : False,
        "message":""
      },
      "warnings" :{
        "hase" : False,
        "message": ""
      }
    }

  def parse(self):
    # Check if any of the argument is in the parser factory
    for argname in self.args:
      # skip known generation arguments
      if argname in self.common_arguments:
        continue

      if ( argname in self.parser_factory and self.args[argname] != None):
        print(f"argname = {argname} --> {self.args[argname]}")
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
  
  def detect_unreachable(self,start=__START__):
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
    nodes = [node for node in self.graph]
    self.graph[__START__] = [] # need to be after nodes in order to don't have __START__ pointing on itself
    invalid_first_states = []
    for state in self.first_states :
      if not state in nodes :
        invalid_first_states.append(state)
        self.raise_error(f"Error: undefined first state {state}")


    if self.first_states and not invalid_first_states:
      self.graph[__START__] = self.first_states
    elif invalid_first_states:
      for state in self.first_states:
        if not state in invalid_first_states:
          self.graph[__START__].append(state)
    else : 
      self.graph[__START__] = nodes
    
    if self.args['allow_orphans']:
      orphans = self.detect_orphans()
      for orphan in orphans:
        if not orphan in self.graph[__START__] and orphan!=__START__:
          self.graph[__START__].append(orphan)

    unreachable = self.detect_unreachable()
    if unreachable:
      for state in unreachable:
        self.warn(f"Warning: unreachable state {state}")

    self.args["first_state"] = __START__

  def generate(self):
    
    # Generate Result
    for argname in self.args:
      # skip known generation arguments
      if argname in self.common_arguments:
        continue

      if ( argname in self.gen_factory and self.args[argname] != None):
        print(f"argname = {argname} --> {self.args[argname]}")
        generator = self.gen_factory.get(argname,base_parser)()

        # generate files
        generator.generate(self.graph,self.args)
  
  def raise_error(self,message):
    self.diagnostics["errors"]["has"] = True
    self.diagnostics["errors"]["message"] += message + "\n" 

  def warn(self,message):
    self.diagnostics["warnings"]["has"] = True
    self.diagnostics["warnings"]["message"] += message + "\n" 

  def main(self):
    self.parse()
    self.pre_gen()
    if not self.diagnostics["errors"]["has"]:
      self.generate()
    else:
      print(self.diagnostics["errors"]["message"])
    if self.diagnostics["warnings"]["has"]:
      print(self.diagnostics["warnings"]["message"])

