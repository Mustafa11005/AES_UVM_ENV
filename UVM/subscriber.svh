class my_subscriber extends uvm_subscriber #(my_sequence_item);

    `uvm_component_utils(my_subscriber)

    my_sequence_item sub_seq_item;

    uvm_analysis_imp #(my_sequence_item, my_subscriber) sub_ap;

    covergroup cg;        // Renamed covergroup to avoid conflict
        // Reset coverage
        RST_N: coverpoint sub_seq_item.rst_n_i {
            bins reset_active = {0};
            bins reset_inactive = {1};
        }

        // Valid input signal coverage
        VALID_IN: coverpoint sub_seq_item.valid_in_i {
            bins valid_in_off = {0};
            bins valid_in_on = {1};
        }

        // Valid output signal coverage
        VALID_OUT: coverpoint sub_seq_item.valid_out_i {
            bins valid_out_off = {0};
            bins valid_out_on = {1};
        }

        // Plain text coverage - divide into byte sections
        PLAIN_TEXT_MSB: coverpoint sub_seq_item.plain_text_128_i[127:96] {
            bins zeros = {32'h0000_0000};
            bins ones = {32'hFFFF_FFFF};
            bins toggle_bits_H = {32'hAAAA_AAAA};
            bins toggle_bits_L = {32'h5555_5555};
            bins test_vector = {32'h0011_2233};  // NIST test vector
            bins misc = default;
        }

        PLAIN_TEXT_MID_HIGH: coverpoint sub_seq_item.plain_text_128_i[95:64] {
            bins zeros = {32'h0000_0000};
            bins ones = {32'hFFFF_FFFF};
            bins toggle_bits_H = {32'hAAAA_AAAA};
            bins toggle_bits_L = {32'h5555_5555};
            bins test_vector = {32'h4455_6677};  // NIST test vector
            bins misc = default;
        }

        PLAIN_TEXT_MID_LOW: coverpoint sub_seq_item.plain_text_128_i[63:32] {
            bins zeros = {32'h0000_0000};
            bins ones = {32'hFFFF_FFFF};
            bins toggle_bits_H = {32'hAAAA_AAAA};
            bins toggle_bits_L = {32'h5555_5555};
            bins test_vector = {32'h8899_AABB};  // NIST test vector
            bins misc = default;
        }

        PLAIN_TEXT_LSB: coverpoint sub_seq_item.plain_text_128_i[31:0] {
            bins zeros = {32'h0000_0000};
            bins ones = {32'hFFFF_FFFF};
            bins toggle_bits_H = {32'hAAAA_AAAA};
            bins toggle_bits_L = {32'h5555_5555};
            bins test_vector = {32'hCCDD_EEFF};  // NIST test vector
            bins misc = default;
        }

        // Key coverage
        KEY_MSB: coverpoint sub_seq_item.key_128_i[127:96] {
            bins zeros = {32'h0000_0000};
            bins ones = {32'hFFFF_FFFF};
            bins toggle_bits_H = {32'hAAAA_AAAA};
            bins toggle_bits_L = {32'h5555_5555};
            bins test_vector = {32'h0011_2233};  // NIST test vector
            bins misc = default;
        }

        KEY_MID_HIGH: coverpoint sub_seq_item.key_128_i[95:64] {
            bins zeros = {32'h0000_0000};
            bins ones = {32'hFFFF_FFFF};
            bins toggle_bits_H = {32'hAAAA_AAAA};
            bins toggle_bits_L = {32'h5555_5555};
            bins test_vector = {32'h4455_6677};  // NIST test vector
            bins misc = default;
        }

        KEY_MID_LOW: coverpoint sub_seq_item.key_128_i[63:32] {
            bins zeros = {32'h0000_0000};
            bins ones = {32'hFFFF_FFFF};
            bins toggle_bits_H = {32'hAAAA_AAAA};
            bins toggle_bits_L = {32'h5555_5555};
            bins test_vector = {32'h8899_AABB};  // NIST test vector
            bins misc = default;
        }

        KEY_LSB: coverpoint sub_seq_item.key_128_i[31:0] {
            bins zeros = {32'h0000_0000};
            bins ones = {32'hFFFF_FFFF};
            bins toggle_bits_H = {32'hAAAA_AAAA};
            bins toggle_bits_L = {32'h5555_5555};
            bins test_vector = {32'hCCDD_EEFF};  // NIST test vector
            bins misc = default;
        }

        CIPHER_TEXT_MSB: coverpoint sub_seq_item.cipher_text_128_i[127:96] {
            option.auto_bin_max = 8;  // Divide into 8 auto bins for general coverage
            bins zeros = {32'h0000_0000};
            bins observed_output = {32'h69c4_e0d8};
        }

        // Upper middle 32 bits
        CIPHER_TEXT_UPPER_MID: coverpoint sub_seq_item.cipher_text_128_i[95:64] {
            option.auto_bin_max = 8;
            bins zeros = {32'h0000_0000};
            bins observed_output = {32'h6a7b_0430};
        }
        
        // Lower middle 32 bits
        CIPHER_TEXT_LOWER_MID: coverpoint sub_seq_item.cipher_text_128_i[63:32] {
            option.auto_bin_max = 8;
            bins zeros = {32'h0000_0000};
            bins observed_output = {32'hd8cd_b780};
        }
        
        // LSB (Least significant 32 bits)
        CIPHER_TEXT_LSB: coverpoint sub_seq_item.cipher_text_128_i[31:0] {
            option.auto_bin_max = 8;
            bins zeros = {32'h0000_0000};
            bins observed_output = {32'h70b4_c55a};
        }
        
        CIPHER_TEXT_TOGGLE_MSB: coverpoint sub_seq_item.cipher_text_128_i[127:120] {
            option.auto_bin_max = 256; 
        }
        
        CIPHER_TEXT_TOGGLE_LSB: coverpoint sub_seq_item.cipher_text_128_i[7:0] {
            option.auto_bin_max = 256;  
        }
        
    endgroup

    function new (string name = "my_subscriber", uvm_component parent = null);
        super.new(name, parent);
        cg = new();
    endfunction

    function void write (my_sequence_item t);
        this.sub_seq_item = t;
        -> sub_done;
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        
        sub_ap = new("sub_ap", this);

        $display("In build phase of my_subscriber \n\n");
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        $display("In connect phase of my_subscriber");
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @sub_done;
            cg.sample();
        end
    endtask

endclass