
package fsm_pkg;

    class fsm_base_class;

        /// State Enum Type
        typedef enum 
            // AEDV_GRAPH_TEMPLATE_ENUM_BEGIN
            { IDLE, A, B, C, D } 
            // AEDV_GRAPH_TEMPLATE_ENUM_END
        state_t; 

        ///  Current Iteration Index
        local int unsigned local_curr_iter_idx = 0;
        //local int unsigned local_edge_weight[state_t][state_t]; ///< constrainable weights for each possible edge. Initial value set to "initial_edge_weight"

        // Protected Members
        protected state_t current_state;
        protected int unsigned weight_end = 0;

        // Public Members
        rand int unsigned max_iter;                      ///< maximum number of iterations. When reached, the graph completes
        rand int unsigned weight[state_t][state_t]; ///< constrainable weights for each possible edge. Initial value set to "initial_edge_weight"
        rand int unsigned initial_edge_weight = 100;     ///< constrainable initial default weight for each edge
        rand bit coverage_closure_en = 0;                ///< constrainable coverage closure configuration. When 1, graph will exit when the coverage reaches 100%
        rand int unsigned weight_default_decrement = 1;           ///< constrainable decrement of the weight of the edge each time it is executed
        rand int unsigned default_edge_at_least = 1;              ///< constrainable. Each edge should be covered at least this number of times

        // State and Transition Coverage
        // AEDV_GRAPH_TEMPLATE_COVERAGE_BEGIN
        covergroup cg;
            states : coverpoint current_state {
                bins state      [] = { [current_state.first():current_state.last()] };
            }
            
            transitions : coverpoint current_state {
                option.at_least = 0;
                bins transition[] = 
                    (IDLE => A,B),
                    (A    => A,B,C),
                    (B    => B,C,D),
                    (C    => IDLE,A),
                    (D    => B,IDLE);
            }
            

            transition_IDLE_A : coverpoint current_state { bins IDLE_A = (IDLE=>A);} 
            transition_IDLE_B : coverpoint current_state { bins IDLE_B = (IDLE=>B);} 
            transition_A_A    : coverpoint current_state { bins A_A    = (A=>A)   ;}
            transition_A_B    : coverpoint current_state { bins A_B    = (A=>B)   ;}
            transition_A_C    : coverpoint current_state { bins A_C    = (A=>C)   ;}
            transition_B_B    : coverpoint current_state { bins B_B    = (B=>B)   ;}
            transition_B_C    : coverpoint current_state { bins B_C    = (B=>C)   ;}
            transition_B_D    : coverpoint current_state { bins B_D    = (B=>D)   ;}
            transition_C_IDLE : coverpoint current_state { bins C_IDLE = (C=>IDLE);}
            transition_C_A    : coverpoint current_state { bins C_A    = (C=>A)   ;}
            transition_D_B    : coverpoint current_state { bins D_B    = (D=>B)   ;}
            transition_D_IDLE : coverpoint current_state { bins D_IDLE = (D=>IDLE);}

        endgroup
        // // AEDV_GRAPH_TEMPLATE_COVERAGE_END

        // Value getter to be used in directed constraints
        function int unsigned get_uint_value(int unsigned value);
            return value;
        endfunction


        constraint fsm_base_class_default_c {
            // Maximum default number off iterations 
            soft max_iter == 1_000;

            // Coverage Closure is disable by default
            soft coverage_closure_en == 0;

            // default_edge_at_least
            soft default_edge_at_least == 1;

            // Default Weight for each edge
            soft initial_edge_weight == 100;
            foreach (weight[src,dst]) {
                soft weight[src][dst] == get_uint_value(initial_edge_weight);
            }

            // weight_default_decrement
            soft weight_default_decrement == 1;
            weight_default_decrement < initial_edge_weight;
        }


        // curr_iter_idx getter
        virtual function get_current_iteration();
            return local_curr_iter_idx;
        endfunction

        // Initialize all of the weights to the given value in argument
        // If the given weight is 0, we consider this is the end and weight_end is set to 100.
        // should be called once at the begining before randomization and once at the end
        function void init_weight(int unsigned _w);
            state_t src,dst; 

            if ( _w > 0 ) weight_end = 0 ;
            else          weight_end = 100;

            src = src.first();
            dst = dst.first();

            // AEDV_GRAPH_TEMPLATE_INIT_WEIGHT_BEGIN
            // TODO: could be generated with only the required values
            // iterate through all of the states 
            // note: the iteration is generic, so we exit the loop on the last but one. 
            // So we need to initialize the last column and last line after the loops
            for (src = src.first();src != src.last();src = src.next() ) begin 
                for (dst = dst.first(); dst != dst.last() ; dst = dst.next() ) begin 
                    weight[src][dst] = _w;
                end
                // Get to the last dest
                weight[src][dst] = _w;
            end
            // Iterate on the last src
            for (dst = dst.first(); dst != dst.last() ; dst = dst.next() ) begin 
                weight[src][dst] = _w;
            end
            // get to the last dest
            weight[src][dst] = _w;
            // AEDV_GRAPH_TEMPLATE_INIT_WEIGHT_END

        endfunction


        // constructor
        function new();
            cg = new();
            local_curr_iter_idx = 0;
            weight_end = 0;
            init_weight(initial_edge_weight);

            //cg.transitions.option.weight = 0;
            //cg.transition_IDLE_B.option.weight = 0;
        endfunction 

        // post_randomize()
        // AEDV_GRAPH_TEMPLATE_INIT_POST_RANDOMIZE_BEGIN
        function void post_randomize();
            foreach (weight[src,dst]) begin 
                if ( weight[src][dst] == 0) begin 
                    case ({src,dst})
                        {IDLE,A}: cg.transition_IDLE_A .option.weight = 0;
                        {IDLE,B}: cg.transition_IDLE_B .option.weight = 0;
                        {A,A}:    cg.transition_A_A    .option.weight = 0;
                        {A,C}:    cg.transition_A_B    .option.weight = 0;
                        {A,B}:    cg.transition_A_C    .option.weight = 0;
                        {B,B}:    cg.transition_B_B    .option.weight = 0;
                        {B,C}:    cg.transition_B_C    .option.weight = 0;
                        {B,D}:    cg.transition_B_D    .option.weight = 0;
                        {C,IDLE}: cg.transition_C_IDLE .option.weight = 0;
                        {C,A}:    cg.transition_C_A    .option.weight = 0;
                        {D,B}:    cg.transition_D_B    .option.weight = 0;
                        {D,IDLE}: cg.transition_D_IDLE .option.weight = 0;
                    endcase
                end 
                else begin 
                    case ({src,dst})
                        {IDLE,A}: cg.transition_IDLE_A .option.at_least = default_edge_at_least;
                        {IDLE,B}: cg.transition_IDLE_B .option.at_least = default_edge_at_least;
                        {A,A}:    cg.transition_A_A    .option.at_least = default_edge_at_least;
                        {A,C}:    cg.transition_A_B    .option.at_least = default_edge_at_least;
                        {A,B}:    cg.transition_A_C    .option.at_least = default_edge_at_least;
                        {B,B}:    cg.transition_B_B    .option.at_least = default_edge_at_least;
                        {B,C}:    cg.transition_B_C    .option.at_least = default_edge_at_least;
                        {B,D}:    cg.transition_B_D    .option.at_least = default_edge_at_least;
                        {C,IDLE}: cg.transition_C_IDLE .option.at_least = default_edge_at_least;
                        {C,A}:    cg.transition_C_A    .option.at_least = default_edge_at_least;
                        {D,B}:    cg.transition_D_B    .option.at_least = default_edge_at_least;
                        {D,IDLE}: cg.transition_D_IDLE .option.at_least = default_edge_at_least;
                    endcase
                end
            end
        endfunction 
        // AEDV_GRAPH_TEMPLATE_INIT_POST_RANDOMIZE_END

        function void update_state(state_t _src, _dst);
            current_state = _dst;
            weight[_src][_dst] = weight[_src][_dst] > weight_default_decrement ? weight[_src][_dst] - weight_default_decrement : 1;
            local_curr_iter_idx += 1;

            if ( ( local_curr_iter_idx >= max_iter ) || 
                 ( coverage_closure_en && (cg.get_coverage() == 100 && get_custom_coverage() == 100) ) ) 
            begin 
                init_weight(0);
                weight_end = 100;
            end
            cg.sample();

        endfunction 

        /// Users may override it to implement their own coverage
        virtual function int get_custom_coverage();
            return 100;
        endfunction

        // AEDV_GRAPH_TEMPLATE_HOOKS_BEGIN
        virtual function  void IDLE_pre_body();
            $display("IDLE_pre called");
        endfunction
        virtual task IDLE_body();
            $display("IDLE_body called");
        endtask
        virtual function void IDLE_post_body();
            $display("IDLE_post called");
        endfunction
        virtual function void A_pre_body();
            $display("A_pre_body called");
        endfunction
        virtual task A_body();
            $display("A_body called");
        endtask
        virtual function void A_post_body();
            $display("A_post_body called");
        endfunction
        virtual function void B_pre_body();
            $display("B_pre_body called");
        endfunction
        virtual task B_body();
            $display("B_body called");
        endtask
        virtual function void B_post_body();
            $display("B_post_body called");
        endfunction
        virtual function void C_pre_body();
            $display("C_pre_body called");
        endfunction
        virtual task C_body();
            $display("C_body called");
        endtask
        virtual function void C_post_body();
            $display("C_post_body called");
        endfunction
        virtual function  void D_pre_body();
            $display("D_pre_body called");
        endfunction
        virtual task D_body();
            $display("D_body called");
        endtask
        virtual function void D_post_body();
            $display("D_post_body called");
        endfunction

        virtual function void IDLE_to_A_pre_body();
            $display("IDLE_to_A_pre_body called");
        endfunction
        virtual task IDLE_to_A_body();
            $display("IDLE_to_A_body called");
        endtask
        virtual function void IDLE_to_A_post_body();
            $display("IDLE_to_A_post_body called");
        endfunction
        virtual function void IDLE_to_B_pre_body();
            $display("IDLE_to_B_pre_body called");
        endfunction
        virtual task IDLE_to_B_body();
            $display("IDLE_to_B_body called");
        endtask
        virtual function void IDLE_to_B_post_body();
            $display("IDLE_to_B_post_body called");
        endfunction
        virtual function void A_to_A_pre_body();
            $display("A_to_A_pre_body called");
        endfunction
        virtual task    A_to_A_body();
            $display("A_to_A_body called");
        endtask
        virtual function void    A_to_A_post_body();
            $display("A_to_A_post_body called");
        endfunction
        virtual function void A_to_C_pre_body();
            $display("A_to_C_pre_body called");
        endfunction
        virtual task    A_to_C_body();
            $display("A_to_C_body called");
        endtask
        virtual function void    A_to_C_post_body();
            $display("A_to_C_post_body called");
        endfunction
        virtual function void A_to_B_pre_body();
            $display("A_to_B_pre_body called");
        endfunction
        virtual task    A_to_B_body();
            $display("A_to_B_body called");
        endtask
        virtual function void    A_to_B_post_body();
            $display("A_to_B_post_body called");
        endfunction
        virtual function void B_to_B_pre_body();
            $display("B_to_B_pre_body called");
        endfunction
        virtual task    B_to_B_body();
            $display("B_to_B_body called");
        endtask
        virtual function void    B_to_B_post_body();
            $display("B_to_B_post_body called");
        endfunction
        virtual function void B_to_C_pre_body();
            $display("B_to_C_pre_body called");
        endfunction
        virtual task    B_to_C_body();
            $display("B_to_C_body called");
        endtask
        virtual function void    B_to_C_post_body();
            $display("B_to_C_post_body called");
        endfunction
        virtual function void B_to_D_pre_body();
            $display("B_to_D_pre_body called");
        endfunction
        virtual task    B_to_D_body();
            $display("B_to_D_body called");
        endtask
        virtual function void    B_to_D_post_body();
            $display("B_to_D_post_body called");
        endfunction
        virtual function void C_to_IDLE_pre_body();
            $display("C_to_IDLE_pre_body called");
        endfunction
        virtual task C_to_IDLE_body();
            $display("C_to_IDLE_body called");
        endtask
        virtual function void C_to_IDLE_post_body();
            $display("C_to_IDLE_post_body called");
        endfunction
        virtual function void C_to_A_pre_body();
            $display("C_to_A_pre_body called");
        endfunction
        virtual task    C_to_A_body();
            $display("C_to_A_body called");
        endtask
        virtual function void    C_to_A_post_body();
            $display("C_to_A_post_body called");
        endfunction
        virtual function void D_to_B_pre_body();
            $display("D_to_B_pre_body called");
        endfunction
        virtual task    D_to_B_body();
            $display("D_to_B_body called");
        endtask
        virtual function void    D_to_B_post_body();
            $display("D_to_B_post_body called");
        endfunction
        virtual function void D_to_IDLE_pre_body();
            $display("D_to_IDLE_pre_body called");
        endfunction
        virtual task D_to_IDLE_body();
            $display("D_to_IDLE_body called");
        endtask
        virtual function void D_to_IDLE_post_body();
            $display("D_to_IDLE_post_body called");
        endfunction

        // Generic State hooks
        virtual function void state_pre_body(state_t state);
             $display("state_pre_body called");
        endfunction 
        virtual task state_body(state_t state);
             $display("state_body called");
        endtask
        virtual function void state_post_body(state_t state);
             $display("state_post_body called");
        endfunction 

        // Generic Edge hooks
        virtual function void edge_pre_body(state_t src,dst);
             $display("edge_pre_body called");
        endfunction 
        virtual task edge_body(state_t src,dst);
             $display("edge_body called");
        endtask
        virtual function void edge_post_body(state_t src,dst);
             $display("edge_post_body called");
        endfunction 

        //TODO: implement UVM Call backs


        // AEDV_GRAPH_TEMPLATE_HOOKS_END

        function void completion_pre_body(); 
            $display("completion_pre_body called");
        endfunction 
        task completion_body(); 
            $display("completion_body called");
        endtask 


        function void completion_post_body();
            $display("==================");
            $display("Completion");
            $display("==================");
            $display("- nr of iterations : %d",this.local_curr_iter_idx);
            if ( local_curr_iter_idx >= max_iter )
                $display("- Max iterations %d reached",this.max_iter);
            $display("- state coverage: %d %%",cg.states.get_coverage());
            //$display("- state coverage: %d %%",cg.transitions.get_coverage());
            $display("- Total coverage: %d %%",cg.get_coverage());
        endfunction

        // AEDV_GRAPH_TEMPLATE_STATE_ACTION_BEGIN
        /// Launch all the pre_body(), body() and post_body() functions and tasks depending on the state to reach.
        /// Antecedent: The edge to this state has been executed
        /// Consequence: At the end of this task, it is assumed that the state is reached.
        local task state_action(state_t state);
            // pre_body()
            state_pre_body(state);
            case (state)
                IDLE: IDLE_pre_body(); 
                A: A_pre_body(); 
                B: B_pre_body(); 
                C: C_pre_body(); 
                D: D_pre_body(); 
            endcase

            // body
            fork
                // Thread 1: 
                state_body(state);

                // Thread 2
                case (state)
                    IDLE:IDLE_body();
                    A:A_body();
                    B:B_body();
                    C:C_body();
                    D:D_body();
                endcase
            join

            // post_body
            case (state)
                IDLE: IDLE_post_body();
                A: A_post_body();
                B: B_post_body();
                C: C_post_body();
                D: D_post_body();                        
            endcase
            state_post_body(state);
        endtask
        // AEDV_GRAPH_TEMPLATE_STATE_ACTION_END
        
        // AEDV_GRAPH_TEMPLATE_EDGE_ACTION_BEGIN
        task edge_action(state_t src,dst);
            // pre_body
            edge_pre_body(src,dst);
            case ({src,dst})
                {IDLE,A}: IDLE_to_A_pre_body(); 
                {IDLE,B}: IDLE_to_B_pre_body(); 
                {A,A}:    A_to_A_pre_body();    
                {A,C}:    A_to_C_pre_body();    
                {A,B}:    A_to_B_pre_body();    
                {B,B}:    B_to_B_pre_body();    
                {B,C}:    B_to_C_pre_body();    
                {B,D}:    B_to_D_pre_body();    
                {C,IDLE}: C_to_IDLE_pre_body(); 
                {C,A}:    C_to_A_pre_body();    
                {D,B}:    D_to_B_pre_body();    
                {D,IDLE}: D_to_IDLE_pre_body(); 
            endcase

            // body
            fork 
                // thread 1:
                edge_body(src,dst);
                // thread 2:
                case ({src,dst})
                    {IDLE,A}: IDLE_to_A_body();
                    {IDLE,B}: IDLE_to_B_body();
                    {A,A}:    A_to_A_body();
                    {A,C}:    A_to_C_body();
                    {A,B}:    A_to_B_body();
                    {B,B}:    B_to_B_body();
                    {B,C}:    B_to_C_body();
                    {B,D}:    B_to_D_body();
                    {C,IDLE}: C_to_IDLE_body();
                    {C,A}:    C_to_A_body();
                    {D,B}:    D_to_B_body();
                    {D,IDLE}: D_to_IDLE_body();
                endcase
            join 

            // post_body
            case ({src,dst})
                {IDLE,A}: IDLE_to_A_post_body();
                {IDLE,B}: IDLE_to_B_post_body();
                {A,A}:    A_to_A_post_body();
                {A,C}:    A_to_C_post_body();
                {A,B}:    A_to_B_post_body();
                {B,B}:    B_to_B_post_body();
                {B,C}:    B_to_C_post_body();
                {B,D}:    B_to_D_post_body();
                {C,IDLE}: C_to_IDLE_post_body();
                {C,A}:    C_to_A_post_body();
                {D,B}:    D_to_B_post_body();
                {D,IDLE}: D_to_IDLE_post_body();
            endcase
            edge_post_body(src,dst);
        endtask
        // AEDV_GRAPH_TEMPLATE_EDGE_ACTION_END

        // AEDV_GRAPH_TEMPLATE_BODY_BEGIN
        task body();
            $display("body() called");
            randsequence()
                // States
                IDLE : IDLE_act IDLE_sel;
                A    : A_act    A_sel;
                B    : B_act    B_sel;
                C    : C_act    C_sel;
                D    : D_act    D_sel;

                // State Actions
                IDLE_act : { state_action(IDLE);} ;
                A_act    : { state_action(A);   } ;
                B_act    : { state_action(B);   } ;
                C_act    : { state_action(C);   } ;
                D_act    : { state_action(D);   } ;

                // State Selection
                IDLE_sel : _END_ := weight_end | IDLE_to_A :=weight[IDLE][A] | IDLE_to_B  :=weight[IDLE][B] ;
                A_sel    : _END_ := weight_end | A_to_A    :=weight[A][A]    | A_to_C     :=weight[A][C]    | A_to_B :=weight[A][B];
                B_sel    : _END_ := weight_end | B_to_B    :=weight[B][B]    | B_to_C     :=weight[B][C]    | B_to_D :=weight[B][D];
                C_sel    : _END_ := weight_end | C_to_IDLE :=weight[C][IDLE] | C_to_A     :=weight[C][A]    ;
                D_sel    : _END_ := weight_end | D_to_B    :=weight[D][B]    | D_to_IDLE  :=weight[D][IDLE] ;

                // Edge    : {  Actions                                   }  Next State
                IDLE_to_A  : {  edge_action(IDLE,A); update_state(IDLE,A);}  A;
                IDLE_to_B  : {  edge_action(IDLE,B); update_state(IDLE,B);}  B;
                A_to_A     : {  edge_action(A,A);    update_state(A,A)   ;}  A;
                A_to_C     : {  edge_action(A,C);    update_state(A,C)   ;}  C;
                A_to_B     : {  edge_action(A,B);    update_state(A,B)   ;}  B;
                B_to_B     : {  edge_action(B,B);    update_state(B,B)   ;}  B;
                B_to_C     : {  edge_action(B,C);    update_state(B,C)   ;}  C;
                B_to_D     : {  edge_action(B,D);    update_state(B,D)   ;}  D;
                C_to_IDLE  : {  edge_action(C,IDLE); update_state(C,IDLE);}  IDLE;
                C_to_A     : {  edge_action(C,A);    update_state(C,A)   ;}  A;
                D_to_B     : {  edge_action(D,B);    update_state(D,B)   ;}  B;
                D_to_IDLE  : {  edge_action(D,IDLE); update_state(D,IDLE);}  IDLE;

                _END_ : { completion_pre_body(); completion_body(); completion_post_body();};
            endsequence

            $display("end of test");
            $display("- weight_end = %d",weight_end);
            $display("- iter       = %d",local_curr_iter_idx);
            $display("- max_iter   = %d",max_iter);

        endtask
        // AEDV_GRAPH_TEMPLATE_BODY_END


    endclass

endpackage 

module tb;

    import fsm_pkg::*;

    fsm_base_class c = new();

    initial begin
        void'(c.randomize() with {
            c.max_iter == 10000;
            c.coverage_closure_en == 1;
            //c.weight[A][C] == 0; // Do not care about B to D
            c.default_edge_at_least == 1;
        }); 
        c.body();
    end

endmodule

