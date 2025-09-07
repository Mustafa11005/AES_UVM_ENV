module wrapper (
    intf.DUT_ intf
);

    /***************************** Inputs ******************************/
        logic [127:0]       plain_text_128_r;
        logic [127:0]       key_128_r       ;
        
        /***************************** Outputs *****************************/
        logic [127:0]       cipher_text_128_r;
        logic               valid_out_r      ;

        always @(posedge intf.clk or negedge intf.rst_n) begin
            if (!intf.rst_n) begin
                plain_text_128_r <= 128'b0;
                key_128_r        <= 128'b0;
            end
            else begin
                if (intf.valid_in) begin
                    plain_text_128_r <= intf.plain_text_128;
                    key_128_r        <= intf.key_128       ;
                end
            end
        end

        always @(posedge intf.clk or negedge intf.rst_n) begin
            if (!intf.rst_n) begin
                intf.cipher_text_128 <= 128'b0;
                intf.valid_out       <= 1'b0;
                valid_out_r <= 1'b0;
            end
            else begin
                // Register the cipher text from the AES module
                intf.cipher_text_128 <= cipher_text_128_r;
                valid_out_r <= intf.valid_in;
                intf.valid_out <= valid_out_r;
            end
        end

        AES_Encrypt UUT (
            .in(plain_text_128_r),
            .key(key_128_r),
            .out(cipher_text_128_r)
        );
    
endmodule