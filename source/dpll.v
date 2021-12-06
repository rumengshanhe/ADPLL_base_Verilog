
/* Top module */
module dpll(
    MainClock,
    SignalIn, SignalOut, SynchronousSignal,
    Positive, Negative, Lead, Lag,
    InputSignalEdge, OutputSignalEdge, Lock, PeriodCount,DividerMaxValue
    );
    
    input  SignalIn;                // input signal
    input  MainClock;               // reference signal
    output SignalOut;               // output
    output Positive, Negative;      // internal DPLL signals
    output Lead, Lag;               // internal DPLL signals
    output InputSignalEdge, OutputSignalEdge;
    output Lock;
    output SynchronousSignal;
    output [7:0] PeriodCount;
    output [7:0] DividerMaxValue;

    
    parameter DividerMultiple = 5;

    // phase comparator 
    phasecomparator inst_ph_cmp(.MainClock(MainClock), .InputSignal(SignalIn),
                                .OutputSignal(SignalOut), .Lead(Lead), .Lag(Lag),
                                .InputSignalEdge(InputSignalEdge), .OutputSignalEdge(OutputSignalEdge),
                                .Lock(Lock), .SynchronousSignal(SynchronousSignal),
                                .PeriodCount(PeriodCount)
                                );
    /*
    // "Zero-Reset Random Walk Filter"
    randomwalkfilter inst_zrwf(.MainClock(MainClock), .Lead(Lead), .Lag(Lag),
                               .Positive(Positive), .Negative(Negative)
                               );
    */
    
	//    defparam inst_freqdiv.DividerMaxValue;
    
    // "Variable-Reset Random Walk Filter"
    variableresetrandomwalkfilter inst_zrwf(.MainClock(MainClock), .Lead(Lead), .Lag(Lag),
                               .Positive(Positive), .Negative(Negative)
                               );
    
    // controlled frequency divider
    freqdivider inst_freqdiv(.MainClock(MainClock), .FrequencyOut(SignalOut), .DividerMax(PeriodCount/DividerMultiple),
                               .Positive(Positive), .Negative(Negative), .DividerMaxValue(DividerMaxValue)
                               );
    
        

endmodule
