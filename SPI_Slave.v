module SPI_Slave (MOSI , MISO , SS_n , clk , rst_n , rx_data , rx_valid , tx_data , tx_valid);
parameter IDLE =3'b000 ;
parameter CHK_CMD =3'b001 ;
parameter WRITE =3'b010 ;
parameter READ_DATA =3'b011 ;
parameter READ_ADD =3'b100 ;
input MOSI , SS_n , clk , rst_n , tx_valid ;
input [7:0] tx_data ;
output reg [9:0] rx_data ;
output reg MISO , rx_valid ;
(* fsm_encoding = "seq" *)
reg [2:0] cs , ns ;
reg reading_data ;
reg [3:0]counter_wr_rd ;
reg [3:0]counter_read_data ;
always @(cs , MOSI , SS_n , tx_valid ) begin
	case (cs) 
	IDLE : begin
		if (SS_n)
		ns=IDLE ;
		else 
		ns=CHK_CMD ;
	end
	CHK_CMD : begin
		if(SS_n)
		ns=IDLE ;
		else begin
			if(~MOSI)
			ns=WRITE ;
			else begin
				if (reading_data===1'b1)
				ns=READ_DATA ;
				else
				ns=READ_ADD ;
			end
		end
	end	
	WRITE :
		if(SS_n)
		ns=IDLE ;
		else if(SS_n==0 ) 
		ns=WRITE ;
	READ_ADD :
		if(SS_n)
		ns=IDLE ;
		else if(SS_n==0 ) 
		ns=READ_ADD ;
	READ_DATA : 
		if(SS_n)
		ns=IDLE ;
		else if(SS_n==0 ) 
		ns=READ_DATA ;
	endcase
end				
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			cs<= IDLE ;
		end
		else 
		cs<= ns ;
	end

		always @(posedge clk) begin
			case (cs) 
			IDLE : begin
				rx_valid <=1'b0 ;  counter_wr_rd<=4'd11 ;
				counter_read_data <=4'd0 ;
			end
			WRITE : begin
				if(counter_wr_rd>1 && counter_wr_rd<=11)
				rx_data <= {rx_data[8:0],MOSI} ;
				 if(counter_wr_rd==2)
					rx_valid <=1'b1 ;
					else  
					rx_valid <=1'b0 ;

					counter_wr_rd<=counter_wr_rd-1 ;
			end
			READ_ADD : begin
				if(counter_wr_rd>1 && counter_wr_rd<=11)
				rx_data <= {rx_data[8:0],MOSI} ;
				 if(counter_wr_rd==2) begin
						rx_valid <=1'b1 ; reading_data <= 1 ;
					end
					else  
					rx_valid <=1'b0 ;
					
					counter_wr_rd<=counter_wr_rd-1 ;
				end	
			READ_DATA : begin
				if(counter_wr_rd>1 && counter_wr_rd<=11) begin
					rx_data <= {rx_data[8:0],MOSI} ;
					counter_wr_rd<=counter_wr_rd-1 ;
					end
					if (counter_wr_rd<=1 && tx_valid==1) begin
						if(counter_read_data>=0 && counter_read_data<8)
						MISO<=tx_data[counter_read_data];
						if(counter_read_data==7) 
						reading_data <=0 ;
						counter_read_data<=counter_read_data+1 ;
				end
			end	
			endcase
		end
endmodule