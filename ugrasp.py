#!/bin/env python3
#----------------------------------------------------------------------------------------------------------------------
# $Id$
#----------------------------------------------------------------------------------------------------------------------
##  Copyright (c) 2024-2025 - AEDVICES Consulting 
##  166B Rue du Rocher de Lorzier, 38430 Moirans  - France
##  www.aedvices.com
##  For any query contact AEDVICES Consulting: contact@aedvices.com
#----------------------------------------------------------------------------------------------------------------------
##
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


import argparse
from py.svgraph_app import svgraph_app

def main():
  print("AEDVICES Consulting(c) - uGRASP - UVM Graph Automated Sequence Producer")
  parser = argparse.ArgumentParser(description="Python Test Suite Runner")
  parser.add_argument("-classname"    ,action="store"        ,dest="classname"     ,default=None ,help="Destination path. Filenames that are given with a relative paths will be relative to this path")
  parser.add_argument("-first_state"  ,action="store"        ,dest="first_state"   ,default=None ,help="First State to start with, multple states can be specify with \"State1,State2,...\" ")
  parser.add_argument('-in_csv'       ,action="store"        ,dest="in_csv"        ,default=None ,help="CSV Filename")  
  parser.add_argument("-out_dir"      ,action="store"        ,dest="out_dir"       ,default=None ,help="Destination path. Filenames that are given with a relative paths will be relative to this path")
  parser.add_argument('-gen_dot'      ,action="store_true"   ,dest="gen_dot"       ,default=None ,help="Graphviz Generation Simple Graph")  
  parser.add_argument('-gen_dot_full' ,action="store_true"   ,dest="gen_dot_full"  ,default=None ,help="Graphviz Full Graph Generation with all function names")  
  parser.add_argument("-gen_uvm"      ,action="store_true"   ,dest="gen_uvm"       ,default=None ,help="generate UVM graph")
  parser.add_argument("-per_instance" ,action="store"        ,dest="per_instance"  ,default=None ,help="(yes|no|param) : Specify if covergroup is per instance or not, or is parameterizable" )
  parser.add_argument("-no_covergroup"  ,action="store_true" ,dest="no_covergroup" ,default=None ,help="(yes|no) : Specify if covergroup is generated or not" )
  parser.add_argument("-allow_orphans"  ,action="store_true" ,dest="allow_orphans" ,default=None ,help="(yes|no) : When orphans are found the graph may start by one of them." )
  parser.add_argument("-sequence_item"  ,action="store"      ,dest="sequence_item" ,default=None ,help="When set, the generated sequence is non-virtual and uses this sequence item" )
  parser.add_argument("-import_package" ,action="store"      ,dest="import_package",default=None ,help="The generated package will import the given package. Empty by default." )
  parser.add_argument("-pre_run_state_name"  ,action="store"      ,dest="pre_run_state_name" ,default="ugrasp_pre_run"  ,help="Pre-Start extra state to handle initial actions" )
  parser.add_argument("-post_run_state_name" ,action="store"      ,dest="post_run_state_name",default="ugrasp_post_run" ,help="Post-Run extra state to handle final actions" )

  args = vars(parser.parse_args())
  app  = svgraph_app(args)
  app.main()
    

# Ensure we run only if calling the script as such.
if __name__ == '__main__':
  res = main()
  exit(res)
