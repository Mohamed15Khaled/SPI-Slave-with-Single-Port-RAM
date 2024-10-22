module RAM (din , rx_valid , clk , rst_n , tx_valid , dout);
parameter MEM_DEPTH =256 ;
parameter ADDR_SIZE =8 ;
input clk , rst_n , rx_valid ; 
input [ADDR_SIZE+1 : 0] din ;
output reg [ADDR_SIZE-1 :0] dout ;
output reg tx_valid ;
reg [ADDR_SIZE-1 :0] addr_wr;
reg [ADDR_SIZE-1 :0] addr_rd;
reg [ADDR_SIZE-1 :0] mem [MEM_DEPTH-1:0] ;
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		dout=8'b0;
		tx_valid<=0 ;
	end
	else  begin
		case (din[9:8])
		2'b00: if(rx_valid) begin addr_wr<= din[7:0]; tx_valid<=0 ; end
		2'b01: if(rx_valid) begin mem[addr_wr]<= din[7:0]; tx_valid<=0 ; end
		2'b10: if(rx_valid) begin addr_rd<= din[7:0]; tx_valid<=0 ; end
		2'b11: begin dout<=mem[addr_rd] ;tx_valid<=1 ; end
		endcase
	end
	
end
endmodule