module UART_RX #(
    parameter CLKS_PER_BIT = 217
)(
    input i_Clock,
    input i_RX_Input,
    output o_RX_Bit,
    output [7:0] o_RX_Byte
);

    parameter RX_IDLE        = 3'b000;
    parameter RX_START_BIT   = 3'b001;
    parameter RX_DATA_BITS   = 3'b010;
    parameter RX_STOP_BIT    = 3'b011;
    parameter RX_CLEANUP     = 3'b100;

    reg [2:0] r_Bit_Index = 0;       // 3 bits to count up to 8
    reg [7:0] r_Clock_Count = 0;     // 8 bits to count up to CLKS_PER_BIT
    reg [7:0] r_RX_Byte = 0;         // 8-bit register to hold received byte
    reg [2:0] r_State_Machine = RX_IDLE;   // 3 bits for state machine
    reg r_RX_Bit = 0;                // 1-bit register for UART bit
  
    // Purpose: Control RX state machine
    always @(posedge i_Clock)
    begin
        case (r_State_Machine)
        RX_IDLE:
        begin 
            r_Clock_Count <= 0;
            r_Bit_Index <= 0;
            r_RX_Bit <= 0;

            if (i_RX_Input == 1'b0)  // Start bit detected
                r_State_Machine <= RX_START_BIT;
            else
                r_State_Machine <= RX_IDLE;        
        end
        
        // Start bit detection
        RX_START_BIT:
        begin
            if (r_Clock_Count == (CLKS_PER_BIT-1)/2) // Check middle of start bit
            begin
                if (i_RX_Input == 1'b0)  // If still low, valid start bit
                begin 
                    r_Clock_Count <= 0;
                    r_State_Machine <= RX_DATA_BITS;
                end
                else
                    r_State_Machine <= RX_IDLE; // Not a valid start bit, return to IDLE
            end
            else
            begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_State_Machine <= RX_START_BIT;
            end
        end
        
        // Data bits reception
        RX_DATA_BITS:
        begin
            if (r_Clock_Count < CLKS_PER_BIT-1) // Counting to CLKS_PER_BIT
            begin 
                r_Clock_Count <= r_Clock_Count + 1;
				r_State_Machine <= RX_DATA_BITS;
            end
            else
            begin 
                r_Clock_Count <= 0;
                r_RX_Byte[r_Bit_Index] <= i_RX_Input; // Capture data bit
                
                if (r_Bit_Index < 7)
                begin
                    r_Bit_Index <= r_Bit_Index + 1;
                    r_State_Machine <= RX_DATA_BITS;
                end
                else
                begin
                    r_Bit_Index <= 0;
                    r_State_Machine <= RX_STOP_BIT;
                end
            end
        end
        
        // Stop bit detection
        RX_STOP_BIT:
        begin
            if (r_Clock_Count < CLKS_PER_BIT-1)
            begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_State_Machine <= RX_STOP_BIT;
            end
            else
            begin 
                r_RX_Bit <= 1'b1; // Indicate that data is valid
                r_Clock_Count <= 0;
                r_State_Machine <= RX_CLEANUP;
            end
        end
        
        // Cleanup and return to IDLE
        RX_CLEANUP:        
        begin
            r_State_Machine <= RX_IDLE;
            r_RX_Bit <= 1'b0;
        end
        
        default: 
            r_State_Machine <= RX_IDLE;
        
        endcase
    end
  
    assign o_RX_Bit = r_RX_Bit;
    assign o_RX_Byte = r_RX_Byte;

endmodule
