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

from py.parsers.base_parser import base_parser
import csv

class csv_parser(base_parser):
  def __init__(self):
    pass


  def read(self,filename,args=None):

    db = {}
    try:
      with open(filename, 'r') as csvfile:
        csvf = list(csv.reader(csvfile))
    except (FileNotFoundError, IOError) as e:
      print(f"Error: Unable to open or read the file '{filename}': {e}")
      return {}

    # Get all header info.
    state_idx      = 0
    next_state_idx = 1
    header = [] 

    # Recovery of the header
    idx = 0
    for column in csvf[0]:
      column = column.lower().strip()
      header.append(column)

      if column in ["state","current_state","current"]:
        state_idx = idx 
      if column in ["next_state","next"]:
        next_state_idx = idx 
      idx += 1

    # Create the graph
    for row in csvf[1:]:
      l = len(row)
      if ( state_idx < l and next_state_idx < l):
        curr_state = row[state_idx].strip()
        next_state = row[next_state_idx].strip()

      if curr_state in db:
        if ( not next_state in db[curr_state] ): # avoid duplicates
          db[curr_state].append(next_state)
      else:
        db[curr_state] = [next_state]

      if not next_state in db:
        db[next_state] = []

    return db
  
