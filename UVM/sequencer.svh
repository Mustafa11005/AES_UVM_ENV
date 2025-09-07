class my_sequencer extends uvm_sequencer #(my_sequence_item);

    `uvm_component_utils(my_sequencer)

    my_sequence_item sequencer_seq_item;

    function new (string name = "my_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer_seq_item = my_sequence_item::type_id::create("sequencer_seq_item");

        $display("In build phase of my_sequencer");
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        $display("In connect phase of my_sequencer");
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
    endtask

endclass