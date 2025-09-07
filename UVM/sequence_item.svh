class my_sequence_item extends uvm_sequence_item;

    `uvm_object_utils(my_sequence_item)

    /***************************** Inputs ******************************/
        rand logic               rst_n_i           ;
        rand logic [127:0]       plain_text_128_i  ;
        rand logic [127:0]       key_128_i         ;
        rand logic               valid_in_i        ;
        
        /***************************** Outputs *****************************/
        logic [127:0]       cipher_text_128_i ;
        logic               valid_out_i       ;

    /***************************** Constraints **************************/

    constraint c_rst_n_i {
        rst_n_i dist {
            0 := 5,
            1 := 95
        };
    }

    constraint c_valid_in_i {
        valid_in_i dist {
            0 := 5,
            1 := 95
        };
    }

    function new (string name = "my_sequence_item");
        super.new(name);
    endfunction

    
endclass