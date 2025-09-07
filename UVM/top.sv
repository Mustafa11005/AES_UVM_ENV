module top ();

    import pack_1::*;
    import uvm_pkg::*;

    logic clk;

    intf intf_(
        .clk(clk)
    );

    wrapper AES_Encrypt(
        .intf(intf_)
    );

    virtual intf vif;

    initial begin
        clk = 0;
        clk = 1;
        forever #5 clk = ~clk;
    end

    initial begin
        uvm_config_db #(virtual intf) :: set (null, "uvm_test_top", "vif", intf_);
        run_test("my_test");
    end
    
endmodule