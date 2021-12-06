library verilog;
use verilog.vl_types.all;
entity variableresetrandomwalkfilter is
    generic(
        N_FilterLength  : integer := 8;
        N_FilterResetValue: integer := 8;
        N_FilterMaxValue: vl_notype;
        N_FilterMinValue: vl_notype;
        ResetterCounterLength: integer := 4;
        ResetterCounterMaxValue: integer := 3;
        ResetterCounterMinValue: integer := 13
    );
    port(
        MainClock       : in     vl_logic;
        Lead            : in     vl_logic;
        Lag             : in     vl_logic;
        Positive        : out    vl_logic;
        Negative        : out    vl_logic;
        N_FilterCounter : out    vl_logic_vector;
        ResetterValue   : out    vl_logic_vector;
        ResetterCounter : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N_FilterLength : constant is 1;
    attribute mti_svvh_generic_type of N_FilterResetValue : constant is 1;
    attribute mti_svvh_generic_type of N_FilterMaxValue : constant is 3;
    attribute mti_svvh_generic_type of N_FilterMinValue : constant is 3;
    attribute mti_svvh_generic_type of ResetterCounterLength : constant is 1;
    attribute mti_svvh_generic_type of ResetterCounterMaxValue : constant is 1;
    attribute mti_svvh_generic_type of ResetterCounterMinValue : constant is 1;
end variableresetrandomwalkfilter;
