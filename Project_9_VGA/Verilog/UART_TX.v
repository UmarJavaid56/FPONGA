module UART_TX #(
    parameter CLKS_PER_BIT = 217
)(
	input i_Clock,
	input i_Reset,
	input i_TX_DV,
	input [7:0] i_TX_Byte,
	output reg o_TX_Active,
	output reg o_TX_Serial,
	output reg o_TX_Done
);

    localparam TX_IDLE       = 2'b00;
    localparam TX_START_BIT  = 2'b01;
    localparam TX_DATA_BITS  = 2'b10;
    localparam TX_STOP_BIT   = 2'b11;
	
	reg [2:0] r_Bit_Index = 0;		 // 3 bits to count up to 8  
	reg [$clog2(CLKS_PER_BIT):0] r_Clock_Count;     // calculates and stores bits to count up to CLKS_PER_BIT
    reg [7:0] r_TX_Byte = 0;         // 8-bit register to hold data
    reg [2:0] r_State_Machine;   	 // 3 bits for state machine
  
	always @(posedge i_Clock or negedge i_Reset)
	
	begin
		if (~i_Reset)
			begin
				r_State_Machine <= 3'b000;
			end
		else						
			begin								
				o_TX_Done <= 1'b0;
				case (r_State_Machine)
				TX_IDLE:
					begin
						r_Bit_Index <= 0;
						r_Clock_Count <= 0;
						o_TX_Serial <= 1'b1;	
						if(i_TX_DV == 1'b1)
							begin
								r_TX_Byte <= i_TX_Byte;
								r_State_Machine <= TX_START_BIT;
								o_TX_Active <= 1'b1;
							end
						else
								r_State_Machine <= TX_IDLE;
					end
	
				TX_START_BIT:
					begin
						o_TX_Serial <= 1'b0;
						begin 
							if(r_Clock_Count < CLKS_PER_BIT-1)
								begin 
									r_Clock_Count <= r_Clock_Count + 1;
									r_State_Machine <= TX_START_BIT;
								end
							else
								begin
									r_Clock_Count <= 0;
									r_State_Machine <= TX_DATA_BITS;
								end
						end
					end
	
				TX_DATA_BITS:
					begin
					o_TX_Serial <= r_TX_Byte[r_Bit_Index];
						if(r_Clock_Count < CLKS_PER_BIT-1)
							begin
								r_Clock_Count <= r_Clock_Count + 1;
								r_State_Machine <= TX_DATA_BITS;
							end
						else
							begin
								r_Clock_Count <= 0;
									if(r_Bit_Index < 7)
										begin
											r_Bit_Index <= r_Bit_Index + 1;
											r_State_Machine <= TX_DATA_BITS;
										end
									else
										begin
											r_State_Machine <= TX_STOP_BIT;
											r_Bit_Index <= 0;
										end
							end
					end
		
				TX_STOP_BIT:
					begin 
					o_TX_Serial <= 1'b1;
						if(r_Clock_Count < CLKS_PER_BIT-1)
							begin
								r_Clock_Count <= r_Clock_Count + 1;
								r_State_Machine <= TX_STOP_BIT;
							end
						else
							begin 
								r_Clock_Count <= 0;
								r_State_Machine <= TX_IDLE;
								o_TX_Done <= 1'b1;
								o_TX_Active <= 1'b0;
							end
					end
					
				default:
					r_State_Machine <= TX_IDLE;
				endcase
			end 
	end // end always block
endmodule