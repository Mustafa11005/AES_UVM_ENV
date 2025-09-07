interface intf (clk);
        input logic              clk     ;

        /***************************** Inputs ******************************/
        logic               rst_n           ;
        logic [127:0]       plain_text_128  ;
        logic [127:0]       key_128         ;
        logic               valid_in        ;
        
        /***************************** Outputs *****************************/
        logic [127:0]       cipher_text_128 ;
        logic               valid_out       ;

        clocking d_CB @(posedge clk);
                output #1step rst_n             ;
                output #1step plain_text_128    ;
                output #1step key_128           ;
                output #1step valid_in          ;
        endclocking

        clocking m_CB @(posedge clk);
                input #1step rst_n              ;
                input #1step plain_text_128     ;
                input #1step key_128            ;
                input #1step valid_in           ;

                input #1step cipher_text_128;
                input #1step valid_out      ;
        endclocking

        modport DUT_ (
            input   clk             ,
                    rst_n           ,
                    plain_text_128  ,
                    key_128         ,  
                    valid_in        ,        
            output  cipher_text_128 ,
                    valid_out
        );
endinterface