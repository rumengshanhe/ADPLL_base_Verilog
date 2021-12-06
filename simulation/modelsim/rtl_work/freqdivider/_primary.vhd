library verilog;
use verilog.vl_types.all;
entity freqdivider is
    generic(
        DividerLength   : integer := 7
    );
    port(
        MainClock       : in     vl_logic;
        DividerMax      : in     vl_logic_vector(7 downto 0);
        Positive        : in     vl_logic;
        Negative        : in     vl_logic;
        FrequencyOut    : out    vl_logic;
        DividerCounter  : out    vl_logic_vector;
        DividerMaxValue : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DividerLength : constant is 1;
end freqdivider;
