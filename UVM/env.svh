class my_env extends uvm_env;

    `uvm_component_utils(my_env)

    my_agent env_agent;
    my_subscriber env_subscriber;
    my_scoreboard env_scoreboard;
    virtual intf vif_env;

    function new (string name = "my_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_agent = my_agent::type_id::create("env_agent", this);
        env_subscriber = my_subscriber::type_id::create("env_subscriber", this);
        env_scoreboard = my_scoreboard::type_id::create("env_scoreboard", this);

        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif_env)) begin
            `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
        end

        uvm_config_db#(virtual intf)::set(this, "env_agent", "vif", vif_env);

        $display("In build phase of my_env");
    endfunction

    

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        env_agent.agent_ap.connect(env_scoreboard.sb_ap);
        env_agent.agent_ap.connect(env_subscriber.sub_ap);

        $display("In connect phase of my_env");
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
    endtask

endclass