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


class base_generator:
  def __init__(self):
    pass 

  def generate(self,db,args):
    pass    

  def header(self,file,suffix):
    """
      Header file
    """
    file.write(f"// SVGraph {self.classname}\n")
    file.write(f"// File    {self.classname}{suffix}\n\n")


  def write(self,file,indent,str):
    indent_str = ""
    for ii in range(indent):
      indent_str += "  "
    file.write(indent_str+str)
