library verilog;
use verilog.vl_types.all;
entity dpll_vlg_tst is
    generic(
        clk_period      : integer := 20;
        signal_period   : integer := 2000;
        delay           : integer := 3287
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of clk_period : constant is 1;
    attribute mti_svvh_generic_type of signal_period : constant is 1;
    attribute mti_svvh_generic_type of delay : constant is 1;
end dpll_vlg_tst;
