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
  
  def pre_gen(self):
    nodes = [node for node in self.graph]
    valid_first_state = True
    for starter in self.first_states :
      if not starter in nodes :
        valid_first_state = False


    if self.first_states and valid_first_state :
      self.graph[__START__] = self.first_states
    else : 
      self.graph[__START__] = nodes
    
    if self.args['allow_orphans']:
      orphans = self.detect_orphans()
      for orphan in orphans:
        if not orphan in self.graph[__START__] and orphan!=__START__:
          self.graph[__START__].append(orphan)

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



  def main(self):
    self.parse()
    self.pre_gen()
    self.generate()
