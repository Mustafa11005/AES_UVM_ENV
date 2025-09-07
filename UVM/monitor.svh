class my_monitor extends uvm_monitor;

    `uvm_component_utils(my_monitor)

    my_sequence_item mon_seq_item_prototype;
    uvm_analysis_port #(my_sequence_item) mon_ap;
    virtual intf vif_monitor;

    function new (string name = "my_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon_seq_item_prototype = my_sequence_item::type_id::create("mon_seq_item_prototype");

        mon_ap = new("mon_ap", this);

        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif_monitor)) begin
                `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
        end

        $display("In build phase of my_monitor");
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        $display("In connect phase of my_monitor");
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            my_sequence_item mon_seq_item;
            $cast(mon_seq_item, mon_seq_item_prototype.clone());

            repeat (1) @(vif_monitor.m_CB);

            mon_seq_item.rst_n_i           <= vif_monitor.m_CB.rst_n          ;
            mon_seq_item.plain_text_128_i  <= vif_monitor.m_CB.plain_text_128 ;
            mon_seq_item.key_128_i         <= vif_monitor.m_CB.key_128        ;
            mon_seq_item.valid_in_i        <= vif_monitor.m_CB.valid_in       ;

            mon_seq_item.cipher_text_128_i  <= vif_monitor.m_CB.cipher_text_128  ;
            mon_seq_item.valid_out_i        <= vif_monitor.m_CB.valid_out        ;

            #1step;

            //$display ("[MONITOR_RUN] %0t: rst_n = %0b, plain_text = %0h, key = %0h, valid_in = %0b", $time, mon_seq_item.rst_n_i,         
            //                                                                                                mon_seq_item.plain_text_128_i,
            //                                                                                                mon_seq_item.key_128_i,       
            //                                                                                                mon_seq_item.valid_in_i);

            //$display("[MONITOR_RUN] %0t: cipher = %0h, valid_out = %0b", $time, mon_seq_item.cipher_text_128_i,
            //                                                                    mon_seq_item.valid_out_i);

            mon_ap.write(mon_seq_item); 
        end
    endtask

endclass