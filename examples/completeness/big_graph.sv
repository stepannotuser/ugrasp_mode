
package aedv_smbus_pkg;

    const int initial_weight = 1000;
    const int weight_decrement = 999;

    typedef enum {
        IDLE, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31, S32, S33
    } state_t;

    class smbus_arp_sequence;
        rand int unsigned max_iter;
        constraint max_iter_c {
            soft max_iter == 100;
        }

        state_t state;
        int unsigned weight[state_t][state_t];
        int unsigned weight_end;

        covergroup cg;
            coverpoint state {
                bins state[] = { [state.first():state.last()]};
                bins transitions[] = 
                    (IDLE => S1),
                    (IDLE => S2),
                    (IDLE => S3),
                    (IDLE => S16),
                    (S1 => S4),
                    (S2 => S4),
                    (S3 => S4),
                    (S3 => S13),
                    (S4 => S5),
                    (S4 => S6),
                    (S5 => S7),
                    (S5 => S8),
                    (S6 => S9),
                    (S6 => S10),
                    (S7 => S11),
                    (S8 => S11),
                    (S9 => S11),
                    (S9 => S6),
                    (S10 => S11),
                    (S10 => S27),
                    (S11 => S12),
                    (S11 => S13),
                    (S12 => S14),
                    (S13 => S14),
                    (S13 => S11),
                    (S14 => S15),
                    (S14 => S16),
                    (S14 => S14),
                    (S15 => S17),
                    (S15 => S18),
                    (S15 => S19),
                    (S16 => S20),
                    (S16 => S21),
                    (S17 => S22),
                    (S18 => S22),
                    (S18 => S15),
                    (S15 => S15),
                    (S19 => S22),
                    (S20 => S22),
                    (S21 => S22),
                    (S21 => S21),
                    (S21 => S17),
                    (S21 => S20),
                    (S22 => S23),
                    (S22 => S24),
                    (S22 => S25),
                    (S22 => S12),
                    (S22 => S20),
                    (S22 => S22),
                    (S22 => S29),
                    (S22 => S21),
                    (S23 => S26),
                    (S24 => S26),
                    (S25 => S26),
                    (S26 => S27),
                    (S26 => S28),
                    (S26 => S29),
                    (S26 => S7),
                    (S27 => S30),
                    (S28 => S30),
                    (S29 => S30),
                    (S30 => S31),
                    (S30 => S32),
                    (S30 => S33),
                    (S22 => IDLE),
                    (S31 => IDLE),
                    (S32 => IDLE),
                    (S33 => IDLE)
                ;
            }
            
        endgroup

        function new();
            state_t orig;
            state_t dest;

            cg = new;
            state = IDLE;

            this.weight_end = 0;
            for (orig=orig.first() ; orig < orig.last(); orig = orig.next() ) begin 
                for (dest=dest.first() ; dest < dest.last(); dest = dest.next() ) begin 
                    weight[orig][dest] = initial_weight;
                end
                weight[orig][dest] = initial_weight;
                dest = dest.next();
                weight[orig][dest] = initial_weight;
            end
            weight[orig][dest] = initial_weight;
            orig = orig.next();
            weight[orig][dest] = initial_weight;
            
        endfunction

        int iter = 0;
        function void update_trans(state_t _src, _dst);
            if ( weight[_src][_dst] > weight_decrement ) begin 
               weight[_src][_dst] = _src != _dst ? weight[_src][_dst] + weight_decrement : 0;
            end
            this.state = _dst;
            cg.sample();
            this.iter ++;
            if ( this.iter >= this.max_iter || cg.get_coverage() == 100 ) begin
                state_t orig;
                state_t dest;
                
                this.weight_end += 100;
                
                //weight.delete();
                /*
                for (orig=orig.first() ; orig < orig.last(); orig = orig.next() ) begin 
                    for (dest=dest.first() ; dest < dest.last(); dest = dest.next() ) begin 
                        weight[orig][dest] = 0;
                    end
                    weight[orig][dest] = 0;
                    dest = dest.next();
                    weight[orig][dest] = 0;
                end
                weight[orig][dest] = 0;
                orig = orig.next();
                weight[orig][dest] = 0;          
                */      
            end

            
        endfunction


        task start();

            randsequence (IDLE_S)
                IDLE_S  : IDLE_S1_A := weight[IDLE][S1] | IDLE_S2_A := weight[IDLE][S2] | IDLE_S3_A := weight[IDLE][S3] | IDLE_S16_A := weight[IDLE][S16] | GRAPH_END := weight_end;

                S1_S  : S1_S4_A := weight[S1][S4] | GRAPH_END := weight_end;
                S2_S  : S2_S4_A := weight[S2][S4] | GRAPH_END := weight_end;
                S3_S  : S3_S4_A := weight[S3][S4] | S3_S13_A := weight[S3][S13] | GRAPH_END := weight_end;

                S4_S  : S4_S5_A := weight[S4][S5] | S4_S6_A := weight[S4][S6] | GRAPH_END := weight_end;

                S5_S  : S5_S7_A := weight[S5][S7] | S5_S8_A := weight[S5][S8] | GRAPH_END := weight_end;

                S6_S  : S6_S9_A := weight[S6][S9] | S6_S10_A := weight[S6][S10] | GRAPH_END := weight_end;

                S7_S  : S7_S11_A := weight[S7][S11] | GRAPH_END := weight_end;
                S8_S  : S8_S11_A := weight[S8][S11] | GRAPH_END := weight_end;
                S9_S  : S9_S11_A := weight[S9][S11] | S9_S6_A := weight[S9][S6] | GRAPH_END := weight_end;
                S10_S : S10_S11_A := weight[S10][S11] | S10_S27_A := weight[S10][S27] | GRAPH_END := weight_end;

                S11_S : S11_S12_A := weight[S11][S12] | S11_S13_A := weight[S11][S13] | GRAPH_END := weight_end;

                S12_S : S12_S14_A := weight[S12][S14] | GRAPH_END := weight_end;
                S13_S : S13_S14_A := weight[S13][S14] | S13_S11_A := weight[S13][S11] | GRAPH_END := weight_end;

                S14_S : S14_S15_A := weight[S14][S15] | S14_S16_A := weight[S14][S16] | S14_S14_A := weight[S14][S14] | GRAPH_END := weight_end;

                S15_S : S15_S17_A := weight[S15][S17] | S15_S18_A := weight[S15][S18] | S15_S19_A := weight[S15][S19] | S15_S15_A := weight[S15][S15] | GRAPH_END := weight_end;

                S16_S : S16_S20_A := weight[S16][S20] | S16_S21_A := weight[S16][S21] | GRAPH_END := weight_end;

                S17_S : S17_S22_A := weight[S17][S22] | GRAPH_END := weight_end;
                S18_S : S18_S22_A := weight[S18][S22] | S18_S15_A := weight[S18][S15] | GRAPH_END := weight_end;

                S19_S : S19_S22_A := weight[S19][S22] | GRAPH_END := weight_end;
                S20_S : S20_S22_A := weight[S20][S22] | GRAPH_END := weight_end;
                S21_S : S21_S22_A := weight[S21][S22] | S21_S21_A := weight[S21][S21] | S21_S17_A := weight[S21][S17] | S21_S20_A := weight[S21][S20] | GRAPH_END := weight_end;

                S22_S : S22_S23_A := weight[S22][S23] |
                         S22_S24_A := weight[S22][S24] |
                         S22_S25_A := weight[S22][S25] | 
                         S22_S12_A := weight[S22][S12] | 
                         S22_IDLE_A := weight[S22][IDLE] | 
                         S22_S20_A  := weight[S22][S20] |
                         S22_S22_A  := weight[S22][S22] |
                         S22_S29_A  := weight[S22][S29] |
                         S22_S21_A  := weight[S22][S21] |
                         GRAPH_END := weight_end;

                S23_S : S23_S26_A := weight[S23][S26] | GRAPH_END := weight_end;
                S24_S : S24_S26_A := weight[S24][S26] | GRAPH_END := weight_end;
                S25_S : S25_S26_A := weight[S25][S26] | GRAPH_END := weight_end;

                S26_S : S26_S27_A := weight[S26][S27] | S26_S28_A := weight[S26][S28] | S26_S29_A := weight[S26][S29] | S26_S7_A := weight[S26][S7] | GRAPH_END := weight_end;

                S27_S : S27_S30_A := weight[S27][S30] | GRAPH_END := weight_end;
                S28_S : S28_S30_A := weight[S28][S30] | GRAPH_END := weight_end;
                S29_S : S29_S30_A := weight[S29][S30] | GRAPH_END := weight_end;

                S30_S : S30_S31_A := weight[S30][S31] | S30_S32_A := weight[S30][S32] | S30_S33_A := weight[S30][S33] | GRAPH_END := weight_end;

                S31_S : S31_IDLE_A := weight[S31][IDLE] | GRAPH_END := weight_end;
                S32_S : S32_IDLE_A := weight[S32][IDLE] | GRAPH_END := weight_end;
                S33_S : S33_IDLE_A := weight[S33][IDLE] | GRAPH_END := weight_end;


                IDLE_S1_A  : { update_trans(IDLE, S1); $display("IDLE => S1"); } S1_S;
                IDLE_S2_A  : { update_trans(IDLE, S2); $display("IDLE => S2"); } S2_S;
                IDLE_S3_A  : { update_trans(IDLE, S3); $display("IDLE => S3"); } S3_S;
                IDLE_S16_A : { update_trans(IDLE, S16); $display("IDLE => S16"); } S16_S;

                S1_S4_A  : { update_trans(S1, S4); $display("S1 => S4"); } S4_S;
                S2_S4_A  : { update_trans(S2, S4); $display("S2 => S4"); } S4_S;
                S3_S4_A  : { update_trans(S3, S4); $display("S3 => S4"); } S4_S;
                S3_S13_A : { update_trans(S3, S13); $display("S3 => S13"); } S13_S;

                S4_S5_A  : { update_trans(S4, S5); $display("S4 => S5"); } S5_S;
                S4_S6_A  : { update_trans(S4, S6); $display("S4 => S6"); } S6_S;

                S5_S7_A  : { update_trans(S5, S7); $display("S5 => S7"); } S7_S;
                S5_S8_A  : { update_trans(S5, S8); $display("S5 => S8"); } S8_S;

                S6_S9_A  : { update_trans(S6, S9); $display("S6 => S9"); } S9_S;
                S6_S10_A : { update_trans(S6, S10); $display("S6 => S10"); } S10_S;

                S7_S11_A  : { update_trans(S7, S11); $display("S7 => S11"); } S11_S;
                S8_S11_A  : { update_trans(S8, S11); $display("S8 => S11"); } S11_S;
                S9_S11_A  : { update_trans(S9, S11); $display("S9 => S11"); } S11_S;
                S9_S6_A   : { update_trans(S9, S6); $display("S9 => S6"); } S6_S;
                S10_S11_A : { update_trans(S10, S11); $display("S10 => S11"); } S11_S;

                S10_S27_A : { update_trans(S10, S27); $display("S10 => S27"); } S27_S;

                S11_S12_A : { update_trans(S11, S12); $display("S11 => S12"); } S12_S;
                S11_S13_A : { update_trans(S11, S13); $display("S11 => S13"); } S13_S;

                S12_S14_A : { update_trans(S12, S14); $display("S12 => S14"); } S14_S;
                S13_S14_A : { update_trans(S13, S14); $display("S13 => S14"); } S14_S;
                S13_S11_A : { update_trans(S13, S11); $display("S13 => S11"); } S11_S;

                S14_S15_A : { update_trans(S14, S15); $display("S14 => S15"); } S15_S;
                S14_S16_A : { update_trans(S14, S16); $display("S14 => S16"); } S16_S;
                S14_S14_A : { update_trans(S14, S14); $display("S14 => S14"); } S14_S;

                S15_S17_A : { update_trans(S15, S17); $display("S15 => S17"); } S17_S;
                S15_S18_A : { update_trans(S15, S18); $display("S15 => S18"); } S18_S;
                S15_S19_A : { update_trans(S15, S19); $display("S15 => S19"); } S19_S;
                S15_S15_A : { update_trans(S15, S15); $display("S15 => S15"); } S15_S;

                S16_S20_A : { update_trans(S16, S20); $display("S16 => S20"); } S20_S;
                S16_S21_A : { update_trans(S16, S21); $display("S16 => S21"); } S21_S;

                S17_S22_A : { update_trans(S17, S22); $display("S17 => S22"); } S22_S;
                S18_S22_A : { update_trans(S18, S22); $display("S18 => S22"); } S22_S;
                S18_S15_A : { update_trans(S18, S15); $display("S18 => S15"); } S15_S;

                S19_S22_A : { update_trans(S19, S22); $display("S19 => S22"); } S22_S;
                S20_S22_A : { update_trans(S20, S22); $display("S20 => S22"); } S22_S;
                S21_S22_A : { update_trans(S21, S22); $display("S21 => S22"); } S22_S;
                S21_S21_A : { update_trans(S21, S21); $display("S21 => S21"); } S21_S;
                S21_S17_A : { update_trans(S21, S17); $display("S21 => S17"); } S17_S;
                S21_S20_A : { update_trans(S21, S20); $display("S21 => S20"); } S20_S;

                S22_S23_A : { update_trans(S22, S23); $display("S22 => S23"); } S23_S;
                S22_S24_A : { update_trans(S22, S24); $display("S22 => S24"); } S24_S;
                S22_S25_A : { update_trans(S22, S25); $display("S22 => S25"); } S25_S;
                S22_S12_A : { update_trans(S22, S12); $display("S22 => S12"); } S12_S;

                S22_S20_A : { update_trans(S22, S20); $display("S22 => S20"); } S20_S;
                S22_S22_A : { update_trans(S22, S22); $display("S22 => S22"); } S22_S;
                S22_S29_A : { update_trans(S22, S29); $display("S22 => S29"); } S29_S;
                S22_S21_A : { update_trans(S22, S21); $display("S22 => S21"); } S21_S;


                S22_IDLE_A : { update_trans(S22, IDLE); $display("S22 => IDLE"); } IDLE_S;

                S23_S26_A : { update_trans(S23, S26); $display("S23 => S26"); } S26_S;
                S24_S26_A : { update_trans(S24, S26); $display("S24 => S26"); } S26_S;
                S25_S26_A : { update_trans(S25, S26); $display("S25 => S26"); } S26_S;

                S26_S27_A : { update_trans(S26, S27); $display("S26 => S27"); } S27_S;
                S26_S28_A : { update_trans(S26, S28); $display("S26 => S28"); } S28_S;
                S26_S29_A : { update_trans(S26, S29); $display("S26 => S29"); } S29_S;
                S26_S7_A  : { update_trans(S26, S7); $display("S26 => S7"); } S7_S;

                S27_S30_A : { update_trans(S27, S30); $display("S27 => S30"); } S30_S;
                S28_S30_A : { update_trans(S28, S30); $display("S28 => S30"); } S30_S;
                S29_S30_A : { update_trans(S29, S30); $display("S29 => S30"); } S30_S;

                S30_S31_A : { update_trans(S30, S31); $display("S30 => S31"); } S31_S;
                S30_S32_A : { update_trans(S30, S32); $display("S30 => S32"); } S32_S;
                S30_S33_A : { update_trans(S30, S33); $display("S30 => S33"); } S33_S;

                S31_IDLE_A : { update_trans(S31, IDLE); $display("S31 => IDLE"); } IDLE_S;
                S32_IDLE_A : { update_trans(S32, IDLE); $display("S32 => IDLE"); } IDLE_S;
                S33_IDLE_A : { update_trans(S33, IDLE); $display("S33 => IDLE"); } IDLE_S;

                GRAPH_END : { $display("GRAPH_END reached"); };
            endsequence

            $display("nr iterations = %d",this.iter);
            $display("Coverage      = %d",cg.get_coverage());

        endtask
    endclass



endpackage


module tb;
    import aedv_smbus_pkg::*;
    smbus_arp_sequence seq = new();
    initial begin 
        void'(seq.randomize() with {max_iter == 20000;});
        seq.start();
    end


endmodule