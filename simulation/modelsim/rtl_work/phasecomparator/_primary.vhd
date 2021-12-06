library verilog;
use verilog.vl_types.all;
entity phasecomparator is
    port(
        InputSignal     : in     vl_logic;
        OutputSignal    : in     vl_logic;
        MainClock       : in     vl_logic;
        Lead            : out    vl_logic;
        Lag             : out    vl_logic;
        InputSignalEdge : out    vl_logic;
        OutputSignalEdge: out    vl_logic;
        Lock            : out    vl_logic;
        SynchronousSignal: out    vl_logic;
        PeriodCount     : out    vl_logic_vector(7 downto 0)
    );
end phasecomparator;
