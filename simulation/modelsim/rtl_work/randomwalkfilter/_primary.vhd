library verilog;
use verilog.vl_types.all;
entity randomwalkfilter is
    generic(
        FilterLength    : integer := 8;
        FilterResetValue: integer := 4;
        FilterMaxValue  : vl_notype;
        FilterMinValue  : vl_notype
    );
    port(
        MainClock       : in     vl_logic;
        Lead            : in     vl_logic;
        Lag             : in     vl_logic;
        Positive        : out    vl_logic;
        Negative        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FilterLength : constant is 1;
    attribute mti_svvh_generic_type of FilterResetValue : constant is 1;
    attribute mti_svvh_generic_type of FilterMaxValue : constant is 3;
    attribute mti_svvh_generic_type of FilterMinValue : constant is 3;
end randomwalkfilter;
