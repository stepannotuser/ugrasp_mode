from py.generator.uvm_sequence_generator import uvm_sequence_generator
from py.traversal.dfs   import dfs_states
from py.traversal.edges import edge_coverage_walk
from py.traversal.postman import directed_chinese_postman
import os


class uvm_automaton_generator(uvm_sequence_generator):

    def generate(self, db, args): 
        strategy = args.get("strategy", "random") 
        self.gen_automaton = (strategy != "random")
        self.strategy = strategy

        self.user_sequence_class = (
            args.get("user_sequence")
            or f"{self.classname}_sequence"
        )

        if self.gen_automaton:
            pre_run = args.get("pre_run_state_name", "ugrasp_pre_run")
            clean_db = {k: v for k, v in db.items() if k != pre_run}

            first = args.get("first_state") or next(iter(clean_db))
            if "," in first:
                first = first.split(",")[0].strip()
            if first not in clean_db:
                raise ValueError(
                    f"Start state '{first}' not in graph. "
                    f"Available: {', '.join(clean_db.keys())}"
                )

            if strategy == "dfs":
                walk = dfs_states(clean_db, first)
            elif strategy == "edges":
                walk = edge_coverage_walk(clean_db, first)
            elif strategy == "postman":
                walk = directed_chinese_postman(clean_db, first)
            else:
                raise ValueError(f"Unknown strategy: {strategy}")

            self.walk = walk
            self.clean_db = clean_db
            self.first_state_used = first

            print(f"Info: automaton strategy '{strategy}', "
                  f"start '{first}', "
                  f"walk: {len(walk)-1} transitions")

        super().generate(db, args)

        if not self.gen_automaton:
            return

        f = self.open("_automaton_sequence.svh")
        self._write_automaton_class_decl(f)
        f.close()

        f = self.open("_automaton_sequence.sv")
        self._write_automaton_class_impl(f)
        f.close()


    def write_package(self, file): 
        self.write(file, 0, f"package {self.classname}_pkg;\n\n")
        self.write(file, 1, "\n")
        self.write(file, 1, "`include \"uvm_macros.svh\"\n")
        self.write(file, 1, "import uvm_pkg::*;\n")

        if self.import_package is not None and self.import_package.strip() != "":
            self.write(file, 1, f"import {self.import_package.strip()}::*;\n")

        self.write(file, 1, "\n")
        self.write(file, 1, f"`include \"{self.classname}_types.svh\"\n")
        if not self.no_covergroup:
            self.write(file, 1, f"`include \"{self.classname}_covergroups.svh\"\n")
        self.write(file, 1, "\n")
        self.write(file, 1, f"`include \"{self.classname}_base_sequence.svh\"\n")
        self.write(file, 1, f"`include \"{self.classname}_sequence.svh\"\n")
        
        if self.user_sequence_class != f"{self.classname}_sequence":
            self.write(file, 1, f"`include \"{self.user_sequence_class}.svh\"\n")
            
        self.write(file, 1, f"`include \"{self.classname}_checker.svh\"\n")
        self.write(file, 1, "\n")
        self.write(file, 1, f"`include \"{self.classname}_base_sequence.sv\"\n")
        self.write(file, 1, f"`include \"{self.classname}_sequence.sv\"\n")
        self.write(file, 1, f"`include \"{self.classname}_checker.sv\"\n")
        
        if getattr(self, "gen_automaton", False):
            self.write(file, 1, "\n")
            self.write(file, 1, f"`include \"{self.classname}_automaton_sequence.svh\"\n")
            self.write(file, 1, f"`include \"{self.classname}_automaton_sequence.sv\"\n")

        self.write(file, 0, "\n")
        self.write(file, 0, f"endpackage : {self.classname}_pkg\n")
        self.write(file, 0, "\n")
        

    def _write_automaton_class_decl(self, file):
        self.write(file, 0, "\n")
        self.write(file, 0, "// Automaton sequence (declaration)\n")
        self.write(file, 0, f"class {self.classname}_automaton_sequence "
                            f"extends {self.user_sequence_class};\n")
        self.write(file, 1, f"`uvm_object_utils({self.classname}_automaton_sequence)\n\n")
        self.write(file, 1, f"extern function new(string name=\"{self.classname}_automaton_sequence\");\n")
        self.write(file, 1, "extern virtual task body();\n")
        self.write(file, 0, f"endclass : {self.classname}_automaton_sequence\n")


    def _write_automaton_class_impl(self, file):
        walk = self.walk
        cls = f"{self.classname}_automaton_sequence"

        self.write(file, 0, "\n")
        self.write(file, 0, f"// Walk ({len(walk)-1} transitions): {' -> '.join(walk)}\n")
        self.write(file, 0, f"function {cls}::new(string name=\"{cls}\");\n")
        self.write(file, 1, "super.new(name);\n")
        self.write(file, 0, "endfunction : new\n\n")

        self.write(file, 0, f"task {cls}::body();\n")
        self.write(file, 1, "if (!randomization_done)\n")
        self.write(file, 2, "`uvm_fatal(\"F_NORAND\",\"Sequence not randomized\")\n")
        self.write(file, 1, "\n")
        self.write(file, 1, f"current_state  = {walk[0]};\n")
        self.write(file, 1, f"previous_state = {walk[0]};\n")
        self.write(file, 1, "\n")
#
        for i, state in enumerate(walk):
            self.write(file, 1, f"// state {state}\n")
            self.write(file, 1, f"{state}_pre_body();  state_pre_body({state});\n")
            self.write(file, 1, f"{state}_body();      state_body({state});\n")
            self.write(file, 1, f"{state}_post_body(); state_post_body({state});\n")
            if i < len(walk) - 1:
                src, dst = walk[i], walk[i + 1]
                self.write(file, 1, f"// transition {src} -> {dst}\n")
                self.write(file, 1, f"{src}_to_{dst}_pre_body();  transition_pre_body({src}, {dst});\n")
                self.write(file, 1, f"{src}_to_{dst}_body();      transition_body({src}, {dst});\n")
                self.write(file, 1, f"{src}_to_{dst}_post_body(); transition_post_body({src}, {dst});\n")
                self.write(file, 1, f"update_transition({src}, {dst});\n")
                self.write(file, 1, "\n")

        self.write(file, 1, "completion_pre_body();\n")
        self.write(file, 1, "completion_body();\n")
        self.write(file, 1, "completion_post_body();\n")
        self.write(file, 0, "endtask : body\n")
