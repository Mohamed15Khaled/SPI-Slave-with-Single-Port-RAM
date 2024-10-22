module SPI (MOSI , MISO , SS_n ,clk , rst_n);
input MOSI , clk , SS_n , rst_n ;
output MISO ;
wire [9:0] in;
wire [7:0] out ;
SPI_Slave spi_slave (.MOSI(MOSI) , .MISO(MISO) , .SS_n(SS_n) , .clk(clk) ,
	 .rst_n(rst_n) , .rx_data(in) , .rx_valid(rx_valid) , .tx_data(out) , .tx_valid(tx_valid));
RAM spi_ram (.din(in) , .rx_valid(rx_valid) , .clk(clk) , .rst_n(rst_n) , .tx_valid(tx_valid) , .dout(out));

endmodule