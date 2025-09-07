package shared_pkg;

    parameter LATENCY = 2;

    parameter WORD_ZERO = 32'h0000_0000;
    parameter WORD_ONES = 32'hFFFF_FFFF;
    parameter WORD_TOGGLE_H = 32'hAAAA_AAAA;
    parameter WORD_TOGGLE_L = 32'h5555_5555;
    parameter WORD_TEST_VECTOR_0 = 32'h0011_2233; // NIST test vector part 0
    parameter WORD_TEST_VECTOR_1 = 32'h4455_6677; // NIST test vector part 1
    parameter WORD_TEST_VECTOR_2 = 32'h8899_AABB; // NIST test vector part 2
    parameter WORD_TEST_VECTOR_3 = 32'hCCDD_EEFF; // NIST test vector part 3

    logic [31:0] test_special_cases_0[] = {
        WORD_ZERO,
        WORD_ONES,
        WORD_TOGGLE_H,
        WORD_TOGGLE_L,
        WORD_TEST_VECTOR_0,
        WORD_TEST_VECTOR_3
    };

    logic [31:0] test_special_cases_1[] = {
        WORD_ZERO,
        WORD_ONES,
        WORD_TOGGLE_H,
        WORD_TOGGLE_L,
        WORD_TEST_VECTOR_1,
        WORD_TEST_VECTOR_2
    };

    logic [31:0] test_special_cases_2[] = {
        WORD_ZERO,
        WORD_ONES,
        WORD_TOGGLE_H,
        WORD_TOGGLE_L,
        WORD_TEST_VECTOR_2,
        WORD_TEST_VECTOR_1
    };

    logic [31:0] test_special_cases_3[] = {
        WORD_ZERO,
        WORD_ONES,
        WORD_TOGGLE_H,
        WORD_TOGGLE_L,
        WORD_TEST_VECTOR_3,
        WORD_TEST_VECTOR_0
    };

    integer unsigned err_count = 0;
    integer unsigned correct_count = 0;

    event sb_done;
    event sub_done;
    event new_item;

    

endpackage