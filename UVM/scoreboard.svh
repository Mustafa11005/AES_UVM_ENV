class my_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(my_scoreboard)

    my_sequence_item sb_seq_item;

    // QUEUE
    my_sequence_item dump_queue [$];
    bit rst_var;

    logic [127:0] exp_out;
    int fd;

    uvm_analysis_imp #(my_sequence_item, my_scoreboard) sb_ap;

    function new (string name = "my_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_ap = new("sb_ap", this);

        $display("In build phase of my_scoreboard");
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        $display("In connect phase of my_scoreboard");
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        fork
            begin
                forever begin
                    @(sb_done);

                    // NOTE: MAKE SURE THE PATH TO CODE AND FILES ARE RIGHT 
                    // TIP : RUN THE PYTHON CODE ON TERMINAL FROM THE DIRECTORY 
                    //       OF THE UVM SCOREBOARD TO CHECK NO ERRORS

                    // Open file "key.txt" for writing

                    fd = $fopen("../Python_gen/key.txt","w");

                    // Writing to file : First line writing the data , Second line writing the key

                    $fdisplay(fd,"%h \n%h",sb_seq_item.plain_text_128_i , sb_seq_item.key_128_i);

                    // Close the "key.txt"

                    $fclose(fd);

                    // "$system" task to run the python code and interact with SCOREBOARD through I/O files

                    $system($sformatf("python  ../Python_gen/gen_key.py"));

                    // Open file "output.txt" for reading

                    fd = $fopen("../Python_gen/output.txt","r");

                    // Reading the output of python code through "output.txt" file

                    $fscanf(fd,"%h",exp_out);

                    // Close the "output.txt"

                    $fclose(fd);

                    // COMPARE THE ACTUAL OUTPUT AND EXPECTED OUTPUT
                    if ((sb_seq_item.rst_n_i)) begin
                        if (!sb_seq_item.valid_in_i) begin
                            $display("\nINVALID INPUT [%0t]: IGNORING THE OUTPUT \n", $time);
                        end else begin
                            if(exp_out == sb_seq_item.cipher_text_128_i) begin
                                $display("\nSUCCESS [%0t]: OUT IS %h and EXP OUT IS %h \n", $time, sb_seq_item.cipher_text_128_i , exp_out);
                                correct_count++;
                            end else begin
                                $display("\nFAILURE [%0t]: OUT IS %h and EXP OUT IS %h \n", $time, sb_seq_item.cipher_text_128_i , exp_out);
                                err_count++;
                            end
                        end
                    end else begin
                        exp_out = 128'h0;

                        if (exp_out == sb_seq_item.cipher_text_128_i) begin
                            $display("\nSUCCESS [%0t]: OUT IS %h and EXP OUT IS %h \n", $time, sb_seq_item.cipher_text_128_i , exp_out);
                            correct_count++;
                        end else begin
                            $display("\nFAILURE [%0t]: OUT IS %h and EXP OUT IS %h \n", $time, sb_seq_item.cipher_text_128_i , exp_out);
                            err_count++;
                        end
                    end
                end
            end

            begin
                forever begin
                    @(new_item);
                    repeat (4) begin
                        if (dump_queue.size() > 0) begin
                            dump_queue.pop_front();
                        end
                    end 
                end
            end
        join
        
    endtask

    function void write (my_sequence_item t);
        if (t == null) begin
            `uvm_fatal("NULL_SEQ_ITEM", "Received null sequence item");
        end else if (t.rst_n_i === 1'b0) begin
            if (dump_queue.size() < 2) begin
                dump_queue.push_back(t);
                dump_queue.push_back(t);
            end else begin
                this.sb_seq_item = t;
                rst_var = 1;
                -> sb_done;
            end
        end else begin
            if (rst_var) begin
                if (dump_queue.size() < 4) begin
                dump_queue.push_back(t);
                end else begin
                    this.sb_seq_item = t;
                    rst_var = 0;
                    -> sb_done;
                end
            end else begin
                if (dump_queue.size() < 3) begin
                dump_queue.push_back(t);
                end else begin
                    this.sb_seq_item = t;
                    -> sb_done;
                end
            end
        end
    endfunction
endclass