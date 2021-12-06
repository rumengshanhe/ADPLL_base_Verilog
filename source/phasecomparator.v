`timescale 1ns / 1ps

/* phase comparator */

module phasecomparator(InputSignal, OutputSignal, MainClock, Lead, Lag, InputSignalEdge, OutputSignalEdge, Lock, SynchronousSignal, PeriodCount);

    input MainClock;    // System Clock
    input InputSignal, OutputSignal;    // PLL input(reference) and output(dejittered clock) signals
    output SynchronousSignal;            
    output Lead, Lag;                   // Lead and Lag signals
    output InputSignalEdge, OutputSignalEdge, Lock;
    output [7:0] PeriodCount;
    
	 /*	D触发器,同步输入信号	*/
    reg SynchronousSignal;
    always @(posedge MainClock)
        begin
            SynchronousSignal <= InputSignal;
        end
    
    reg [1:0] InputSignalEdgeDet;       // detector of the rising edge
    always @(posedge MainClock)
        begin
            #0.001;
            InputSignalEdgeDet <= { InputSignalEdgeDet[0], SynchronousSignal };
        end
     
    reg [1:0] OutputSignalEdgeDet;       // detector of the rising edge
    always @(posedge MainClock)
        begin
            #0.002;
            OutputSignalEdgeDet <= { OutputSignalEdgeDet[0], OutputSignal };
        end

    /* this signal checked at rising edge of MainClock.       */
    /* It's simple detector of the Input signal rising edge - */
    /* When it detected then we check the level of the output.*/
    /* There is possible to place additional 2 registers for  */
    /* output signal for eliminatig  the cmp. constant phase error */
    wire InputSignalEdge = (InputSignalEdgeDet == 2'b01);   	// InputSignal上升沿
    wire InputSignalDownEdge = (InputSignalEdgeDet == 2'b10);  // InputSignal下降沿
    wire OutputSignalEdge = (OutputSignalEdgeDet == 2'b01);   	// OutputSignal上升沿
    
    /*	计算输入信号的频率（时钟周期数）	*/
    reg flag;
    reg [7:0] cnt, PeriodCount;
    always @(posedge MainClock)
        begin
            #0.001;
            if(flag)
                begin
                    if(SynchronousSignal)
                        begin
                            cnt <= cnt + 1; 
                        end
                end
        end  
    always @(posedge InputSignalDownEdge)
        begin
            flag = 1'b0;
            PeriodCount <= cnt;
        end
    
    /* "Lead" signal will be generate in case of output==1 during input rising edge*/
    reg Lead, Lag;                   // outputs "Lead", "Lag" are registered
    always @(posedge MainClock)
         begin                  
             if(Lock)  
                 begin
                     Lag <= 1'b0;
                     Lead <= 1'b0;
                 end
             else
                 begin
                 #0.001;  
                     Lag  <= ((InputSignalEdge == 1'b1)  && (OutputSignal == 1'b0));
                     Lead <= ((InputSignalEdge == 1'b1)  && (OutputSignal == 1'b1));
                 end
         end
         
    reg Lock;
    always @(posedge InputSignalEdge)
        begin
            #0.002;
            if(OutputSignalEdge)
                Lock <= 1'b1;
            else
                Lock <= 1'b0;
        end
        
    initial begin
        flag <= 1'b1;
        Lock <= 1'b0;
        cnt <= 8'd0;
        PeriodCount <= 8'd0;
        OutputSignalEdgeDet <= 2'b00;
        InputSignalEdgeDet <= 2'b00;
    end
    

endmodule
