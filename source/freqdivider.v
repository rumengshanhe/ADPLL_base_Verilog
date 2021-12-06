`timescale 1ns / 1ps

/* frequency divider and phase controller */

module freqdivider(MainClock, DividerMax, Positive, Negative, FrequencyOut, DividerCounter, DividerMaxValue);
     input MainClock;                 // main clock
     input [7:0] DividerMax;
     input Positive, Negative;    // signals Positive, Negative are synchronous with MainClock
     output reg FrequencyOut;        // output frequency
     output [6:0] DividerCounter;
     output [7:0] DividerMaxValue;
    
    /* needed counter length */
    parameter DividerLength = 7;
    
    /*  controlled prescaler, after this prescales the "divider by 2" installed,     */
    /*  so composite divide coefficient will be equivalent of 96 (in this example) - */
    /*  it's necessary for work DPLL on frequency 192kHz with oscillator             */
    /*  frequency 18432kHz                                                           */
    /* additional divider by 2 used for getting output signal with duty factor of 2  */
    
    reg [7:0] DividerMaxValue;
    always @(posedge MainClock)
     begin
        DividerMaxValue <= DividerMax;
     end
//    parameter DividerMaxValue = 48;
    
    reg [DividerLength-1 : 0] DividerCounter;
    reg overflow;
    
    initial 
        begin
            FrequencyOut <= 1'b0;
            DividerCounter <= 0;
            overflow <= 0;
        end
    
    /* Process of freq. division according to  signals from Random  Deviations Filter:  */
    /* if "lag" then counter will incremented by 2                                                                          */
    /* if "lead" then counter will not changed                                                                                */
    /* if there is no phase lead or lag then counter normally incremented by 1                          */
    
    always @(posedge MainClock)
     begin
         #0.001;
         if(Negative == 1'b0 && Positive == 1'b0 && DividerCounter >= (DividerMaxValue - 1))
             begin
               DividerCounter <= 0;
               overflow <= 1'b1;
             end  
         else if(Negative == 1'b1)  
             begin     
                 if(DividerCounter <= (DividerMaxValue - 3))
                     DividerCounter <= DividerCounter + 2;
                 else if(DividerCounter == (DividerMaxValue - 2))
                     begin
                         DividerCounter <= 0;
                         overflow <= 1'b1;
                     end
                 else if(DividerCounter == (DividerMaxValue - 1))
                     begin
                         DividerCounter <= 1;
                         overflow <= 1'b1;
                     end
             end
         else if(Positive == 1'b1) 
             begin
                 DividerCounter <= DividerCounter;
                 overflow <= 1'b0;
             end        
         else       
             begin
                 DividerCounter <= DividerCounter + 1;
                 overflow <= 1'b0;
             end
         // additional divider by 2 - for producing 50% duty factor of the output signal
     end
     
    always @(posedge overflow)
        begin
            FrequencyOut <= ~FrequencyOut;
        end

endmodule
