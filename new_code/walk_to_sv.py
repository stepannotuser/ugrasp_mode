#!/usr/bin/env python3
"""
walk в SV-класс, который проходит
walk детерминированно, вместо randsequence.
"""

import sys
import os
from dfs_traversal import read_graph, dfs_states, edge_coverage_walk


def gen_class(classname, walk, out_file):
    lines = []
    lines.append(f"// Auto-generated automaton sequence")
    lines.append(f"// Walk ({len(walk)-1} transitions): {' -> '.join(walk)}")
    lines.append(f"")
    lines.append(f"class {classname}_automaton_sequence extends {classname}_user_sequence;")
    lines.append(f"  `uvm_object_utils({classname}_automaton_sequence)")
    lines.append(f"")
    lines.append(f"  function new(string name=\"{classname}_automaton_sequence\");")
    lines.append(f"    super.new(name);")
    lines.append(f"  endfunction : new")
    lines.append(f"")
    lines.append(f"  // Public coverage accessors for reporting")
    lines.append(f"  function real get_state_coverage();")
    lines.append(f"    return cg.states.get_coverage();")
    lines.append(f"  endfunction")
    lines.append(f"")
    lines.append(f"  function real get_transition_coverage();")
    lines.append(f"    return cg.transitions.get_coverage();")
    lines.append(f"  endfunction")
    lines.append(f"")
    lines.append(f"  function real get_total_coverage();")
    lines.append(f"    return cg.get_coverage();")
    lines.append(f"  endfunction")
    lines.append(f"")
    lines.append(f"  // Coverage goal setters")
    lines.append(f"  function void set_state_at_least(int n);")
    lines.append(f"    cg.states.option.at_least = n;")
    lines.append(f"  endfunction")
    lines.append(f"")
    lines.append(f"  function void set_transition_at_least(int n);")
    lines.append(f"    cg.transitions.option.at_least = n;")
    lines.append(f"  endfunction")
    lines.append(f"")
    lines.append(f"")
    lines.append(f"  virtual task body();")
    lines.append(f"    if (!randomization_done)")
    lines.append(f"      `uvm_fatal(\"F_NORAND\",\"Sequence not randomized. Please randomize before start()\")")
    lines.append(f"")
    lines.append(f"    // Set initial state (protected members accessible from subclass)")
    lines.append(f"    current_state  = {walk[0]};")
    lines.append(f"    cg.sample({walk[0]});  // sample initial state to enable first transition coverage")
    lines.append(f"    previous_state = {walk[0]};")
    lines.append(f"")

    for i, state in enumerate(walk):
        lines.append(f"    // --- state {state} (step {i}) ---")
        lines.append(f"    {state}_pre_body();  state_pre_body({state});")
        lines.append(f"    {state}_body();      state_body({state});")
        lines.append(f"    {state}_post_body(); state_post_body({state});")
        lines.append(f"")

        if i < len(walk) - 1:
            src, dst = walk[i], walk[i + 1]
            lines.append(f"    // --- transition {src} -> {dst} ---")
            lines.append(f"    {src}_to_{dst}_pre_body();  transition_pre_body({src}, {dst});")
            lines.append(f"    {src}_to_{dst}_body();      transition_body({src}, {dst});")
            lines.append(f"    {src}_to_{dst}_post_body(); transition_post_body({src}, {dst});")
            lines.append(f"    update_transition({src}, {dst});")
            lines.append(f"")

    lines.append(f"    // --- completion ---")
    lines.append(f"    completion_pre_body();")
    lines.append(f"    completion_body();")
    lines.append(f"    completion_post_body();")
    lines.append(f"  endtask : body")
    lines.append(f"")
    lines.append(f"endclass : {classname}_automaton_sequence")
    lines.append(f"")

    with open(out_file, 'w') as f:
        f.write('\n'.join(lines))
    print(f"Wrote: {out_file}")
    print(f"  transitions: {len(walk)-1}")
    


def main():
    if len(sys.argv) < 4:
        print("Usage: walk_to_sv.py <graph.csv> <dfs|edges> <classname> [out_dir]")
        sys.exit(1)

    csv_file  = sys.argv[1]
    mode      = sys.argv[2]
    classname = sys.argv[3]
    out_dir   = sys.argv[4] if len(sys.argv) > 4 else "new_code/output"

    os.makedirs(out_dir, exist_ok=True)

    graph = read_graph(csv_file)
    start = next(iter(graph))

    if mode == 'dfs':
        walk = dfs_states(graph, start)
    elif mode == 'edges':
        walk = edge_coverage_walk(graph, start)
    else:
        print(f"Unknown mode: {mode}")
        sys.exit(1)

    out_file = os.path.join(out_dir, f"{classname}_automaton_sequence.svh")
    gen_class(classname, walk, out_file)


if __name__ == '__main__':
    main()
