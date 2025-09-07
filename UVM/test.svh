class my_test extends uvm_test;

    `uvm_component_utils(my_test)

    my_env test_env;
    init init_seq;
    ts01 ts01_seq;
    ts02 ts02_seq;
    ts03 ts03_seq;
    ts04 ts04_seq;
    virtual intf vif_test;

    string test_status;
    int total_transactions;
    real error_percentage; 

    function new (string name = "my_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif_test)) begin
                `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
        end

        uvm_config_db#(virtual intf)::set(this, "test_env", "vif", vif_test);

        test_env = my_env::type_id::create("test_env", this);
        init_seq = init::type_id::create("init_seq");
        ts01_seq = ts01::type_id::create("ts01_seq");
        ts02_seq = ts02::type_id::create("ts02_seq");
        ts03_seq = ts03::type_id::create("ts03_seq");
        ts04_seq = ts04::type_id::create("ts04_seq");
    
        $display("\n\nIn build phase of my_test");
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        $display("In connect phase of my_test");
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        `uvm_info("run_phase", "welcome to AES UVM", UVM_MEDIUM)

        $display("\n----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");

        `uvm_info("run_phase", "Initialization started", UVM_LOW)
        init_seq.start(test_env.env_agent.agent_sequencer);
        `uvm_info("run_phase", "Initialization ended", UVM_LOW)

        $display("\n----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");

        `uvm_info("run_phase", "TS01 started", UVM_LOW)
        ts01_seq.start(test_env.env_agent.agent_sequencer);
        `uvm_info("run_phase", "TS01 ended", UVM_LOW)

        $display("\n----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");

        `uvm_info("run_phase", "TS02 started", UVM_LOW)
        ts02_seq.start(test_env.env_agent.agent_sequencer);
        `uvm_info("run_phase", "TS02 ended", UVM_LOW)

        $display("\n----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");

        `uvm_info("run_phase", "TS03 started", UVM_LOW)
        ts03_seq.start(test_env.env_agent.agent_sequencer);
        `uvm_info("run_phase", "TS03 ended", UVM_LOW)

        $display("\n----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");

        `uvm_info("run_phase", "TS04 started", UVM_LOW)
        ts04_seq.start(test_env.env_agent.agent_sequencer);
        `uvm_info("run_phase", "TS04 ended", UVM_LOW)

        phase.drop_objection(this);
    endtask

    function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    // Calculate basic statistics
    total_transactions = correct_count + err_count;
    error_percentage = (total_transactions > 0) ? (100.0 * err_count / total_transactions) : 0.0;
    test_status = (err_count == 0) ? "PASSED" : "FAILED";
    
    // Comprehensive test report
    $display("\n========================================");
    $display("           UVM TEST SUMMARY             ");
    $display("========================================");
    $display(" Test Name:    %s", get_full_name());
    $display(" Simulation:   %t", $time);
    $display("----------------------------------------");
    $display(" TRANSACTION STATISTICS");
    $display("----------------------------------------");
    $display(" Total Transactions: %0d", total_transactions);
    $display(" Correct:            %0d", correct_count);
    $display(" Errors:             %0d", err_count);
    $display(" Error Percentage:   %0.2f%%", error_percentage);
    
    $display("----------------------------------------");
    $display(" TIMING INFORMATION");
    $display("----------------------------------------");
    $display(" Simulation Time:    %0t ns", $time);
    
    $display("========================================");
    if (err_count == 0) begin
        $display(" TEST STATUS: PASSED");
        $display(" All checks completed successfully!");
    end else begin
        $display(" TEST STATUS: FAILED");
        $display(" %0d error(s) detected during simulation", err_count);
    end
    $display("========================================\n");
    
    generate_summary_file();
endfunction

function void generate_summary_file();
    int file_handle;
    string filename;
    
    filename = $sformatf("test_summary_%s.log", get_full_name());
    file_handle = $fopen(filename, "w");
    
    if (file_handle) begin
        // Write all content to file
        $fdisplay(file_handle, "\n========================================");
        $fdisplay(file_handle, "           UVM TEST SUMMARY             ");
        $fdisplay(file_handle, "========================================");
        $fdisplay(file_handle, " Test Name:    %s", get_full_name());
        $fdisplay(file_handle, " Simulation:   %t", $time);
        $fdisplay(file_handle, "----------------------------------------");
        $fdisplay(file_handle, " TRANSACTION STATISTICS");
        $fdisplay(file_handle, "----------------------------------------");
        $fdisplay(file_handle, " Total Transactions: %0d", total_transactions);
        $fdisplay(file_handle, " Correct:            %0d", correct_count);
        $fdisplay(file_handle, " Errors:             %0d", err_count);
        $fdisplay(file_handle, " Error Percentage:   %0.2f%%", error_percentage);
        
        // Add simple timing information
        $fdisplay(file_handle, "----------------------------------------");
        $fdisplay(file_handle, " TIMING INFORMATION");
        $fdisplay(file_handle, "----------------------------------------");
        $fdisplay(file_handle, " Simulation Time:    %0t ns", $time);
        
        // Final test status
        $fdisplay(file_handle, "========================================");
        if (err_count == 0) begin
            $fdisplay(file_handle, " TEST STATUS: PASSED");
            $fdisplay(file_handle, " All checks completed successfully!");
        end else begin
            $fdisplay(file_handle, " TEST STATUS: FAILED");
            $fdisplay(file_handle, " %0d error(s) detected during simulation", err_count);
        end
        $fdisplay(file_handle, "========================================\n");
        
        // Close the file
        $fclose(file_handle);

        `uvm_info("REPORT", $sformatf("Summary file generated: %s", filename), UVM_LOW)
    end
endfunction

endclass