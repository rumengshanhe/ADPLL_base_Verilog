library verilog;
use verilog.vl_types.all;
entity dpll is
    generic(
        DividerMultiple : integer := 5
    );
    port(
        MainClock       : in     vl_logic;
        SignalIn        : in     vl_logic;
        SignalOut       : out    vl_logic;
        SynchronousSignal: out    vl_logic;
        Positive        : out    vl_logic;
        Negative        : out    vl_logic;
        Lead            : out    vl_logic;
        Lag             : out    vl_logic;
        InputSignalEdge : out    vl_logic;
        OutputSignalEdge: out    vl_logic;
        Lock            : out    vl_logic;
        PeriodCount     : out    vl_logic_vector(7 downto 0);
        DividerMaxValue : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DividerMultiple : constant is 1;
end dpll;
