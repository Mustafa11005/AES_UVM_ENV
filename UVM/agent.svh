class my_agent extends uvm_agent;

    `uvm_component_utils(my_agent)

    my_driver agent_driver;
    my_monitor agent_monitor;
    my_sequencer agent_sequencer;
    uvm_analysis_port #(my_sequence_item) agent_ap;

    virtual intf vif_agent;

    function new (string name = "my_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_driver = my_driver::type_id::create("agent_driver", this);
        agent_monitor = my_monitor::type_id::create("agent_monitor", this);
        agent_sequencer = my_sequencer::type_id::create("agent_sequencer", this);
        
        agent_ap = new("agent_ap", this);

        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif_agent)) begin
                `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
        end

        uvm_config_db#(virtual intf)::set(this, "agent_driver", "vif", vif_agent);
        uvm_config_db#(virtual intf)::set(this, "agent_monitor", "vif", vif_agent);

        $display("In build phase of my_agent");
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        agent_monitor.mon_ap.connect(this.agent_ap);

        agent_driver.seq_item_port.connect(agent_sequencer.seq_item_export);

        $display("In connect phase of my_agent");
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
    endtask

endclass