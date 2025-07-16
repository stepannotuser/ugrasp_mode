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
  common_arguments = ["out_dir","classname","first_state"]

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
    self.generate()
