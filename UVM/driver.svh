class my_driver extends uvm_driver #(my_sequence_item);

    `uvm_component_utils(my_driver)

    my_sequence_item drv_seq_item;

    virtual intf vif_driver;

    function new (string name = "my_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif_driver)) begin
                `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
        end

        $display("In build phase of my_driver");
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        $display("In connect phase of my_driver");
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);

        forever begin
            seq_item_port.get_next_item(drv_seq_item);

            -> new_item;

            repeat (1) @(vif_driver.d_CB);
            
            vif_driver.d_CB.rst_n            <= drv_seq_item.rst_n_i         ;
            vif_driver.d_CB.plain_text_128   <= drv_seq_item.plain_text_128_i;
            vif_driver.d_CB.key_128          <= drv_seq_item.key_128_i       ;
            vif_driver.d_CB.valid_in         <= drv_seq_item.valid_in_i      ;

            //$display ("[DRIVER_RUN]: rst_n = %0b, plain_text = %0h, key = %0h, valid_in = %0b", vif_driver.d_CB.rst_n,         
            //                                                                                    vif_driver.d_CB.plain_text_128,
            //                                                                                    vif_driver.d_CB.key_128,       
            //                                                                                    vif_driver.d_CB.valid_in);

            if (drv_seq_item.rst_n_i === 1'b0) begin
               repeat (2) @(posedge vif_driver.clk);
            end else begin
                repeat (LATENCY + 1) @(posedge vif_driver.clk);
            end
            
            #1step;
            seq_item_port.item_done();
        end
    endtask

endclass