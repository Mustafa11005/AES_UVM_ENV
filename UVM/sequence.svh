class init extends uvm_sequence #(my_sequence_item);

    `uvm_object_utils(init)

    my_sequence_item seq_item;

    function new (string name = "init");
        super.new(name);
    endfunction

    task pre_body();
        seq_item = my_sequence_item::type_id::create("seq_item");
    endtask

    task body();
        start_item(seq_item);

        seq_item.rst_n_i = 1'b0;
        seq_item.plain_text_128_i = 0;
        seq_item.key_128_i = 0;
        seq_item.valid_in_i = 1'b0;

        finish_item(seq_item);
    endtask

    task post_body();
        $display ("Sequence Done_0");
    endtask
endclass

class ts01 extends uvm_sequence #(my_sequence_item);

    `uvm_object_utils(ts01)

    my_sequence_item seq_item;

    function new (string name = "ts01");
        super.new(name);
    endfunction

    task pre_body();
        seq_item = my_sequence_item::type_id::create("seq_item");

        seq_item.rst_n_i.rand_mode(0);
        seq_item.plain_text_128_i.rand_mode(0);
        seq_item.key_128_i.rand_mode(0);
        seq_item.valid_in_i.rand_mode(0);
    endtask

    task body();

        start_item(seq_item);

        seq_item.rst_n_i = 1'b1;
        seq_item.plain_text_128_i = 128'h0011_2233_4455_6677_8899_aabb_ccdd_eeff;
        seq_item.key_128_i = 128'h_000102030405060708090a0b0c0d0e0f;
        seq_item.valid_in_i = 1'b1;

        finish_item(seq_item);
    endtask

    task post_body ();

        seq_item.rst_n_i.rand_mode(1);
        seq_item.plain_text_128_i.rand_mode(1);
        seq_item.key_128_i.rand_mode(1);
        seq_item.valid_in_i.rand_mode(1);
        $display ("Sequence Done_1");
    endtask
endclass

class ts02 extends uvm_sequence #(my_sequence_item);

    `uvm_object_utils(ts02)

    my_sequence_item seq_item;

    function new (string name = "ts02");
        super.new(name);
    endfunction

    task pre_body();
        seq_item = my_sequence_item::type_id::create("seq_item");

        seq_item.rst_n_i.rand_mode(0);
        seq_item.valid_in_i.rand_mode(0);
        seq_item.plain_text_128_i.rand_mode(0);
    endtask

    task body();
        for (int i = 0; i < 6 ; i++) begin
            for (int j = 0; j < 6 ; j++) begin
                for (int k = 0; k < 6 ; k++) begin
                    for (int l = 0; l < 6 ; l++) begin
                        start_item(seq_item);
                        seq_item.rst_n_i = 1'b1;
                        seq_item.valid_in_i = 1'b1;
                        seq_item.plain_text_128_i = {test_special_cases_0[i], test_special_cases_1[j], test_special_cases_2[k], test_special_cases_3[l]};

                        if (!seq_item.randomize()) begin
                            `uvm_fatal("RAND_FAIL", "Randomization failed in ts02");
                        end
                        finish_item(seq_item);
                    end
                end
            end
        end
    endtask

    task post_body ();

        seq_item.rst_n_i.rand_mode(1);
        seq_item.valid_in_i.rand_mode(1);
        seq_item.plain_text_128_i.rand_mode(1);
    endtask
endclass

class ts03 extends uvm_sequence #(my_sequence_item);

    `uvm_object_utils(ts03)

    my_sequence_item seq_item;

    function new (string name = "ts03");
        super.new(name);
    endfunction

    task pre_body();
        seq_item = my_sequence_item::type_id::create("seq_item");

        seq_item.rst_n_i.rand_mode(0);
        seq_item.valid_in_i.rand_mode(0);
        seq_item.key_128_i.rand_mode(0);
    endtask

    task body();
        for (int i = 0; i < 6 ; i++) begin
            for (int j = 0; j < 6 ; j++) begin
                for (int k = 0; k < 6 ; k++) begin
                    for (int l = 0; l < 6 ; l++) begin
                        start_item(seq_item);
                        seq_item.rst_n_i = 1'b1;
                        seq_item.valid_in_i = 1'b1;
                        seq_item.key_128_i = {test_special_cases_0[i], test_special_cases_1[j], test_special_cases_2[k], test_special_cases_3[l]};

                        if (!seq_item.randomize()) begin
                            `uvm_fatal("RAND_FAIL", "Randomization failed in ts03");
                        end
                        finish_item(seq_item);
                    end
                end
            end
        end
    endtask

    task post_body ();

        seq_item.rst_n_i.rand_mode(1);
        seq_item.valid_in_i.rand_mode(1);
        seq_item.key_128_i.rand_mode(1);
    endtask
endclass

class ts04 extends uvm_sequence #(my_sequence_item);

    `uvm_object_utils(ts04)

    my_sequence_item seq_item;

    function new (string name = "ts04");
        super.new(name);
    endfunction

    task pre_body();
        seq_item = my_sequence_item::type_id::create("seq_item");
    endtask

    task body();

        repeat (100) begin
            start_item(seq_item);

            if (!seq_item.randomize()) begin
                `uvm_fatal("RAND_FAIL", "Randomization failed in ts04");
            end

            finish_item(seq_item);
        end
    endtask
endclass