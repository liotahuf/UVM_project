/*------------------------------------------------------------------------------
 * File          : Kmeans_if.v
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 18, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

/*module Kmeans_if #() ();

endmodule*/

interface Kmeans_if #(
parameter
tc_mode           = 1,
	rem_mode          =1,
	accum_width       = 7*22,
	addrWidth         = 9,
	dataWidth         = 91,
	centroid_num      =8,
	log2_cent_num     = 3,
	accum_cord_width  = 22,
	cordinate_width   = 13,
	count_width       = 10,
	manhatten_width   = 16, //protect from overflow
	log2_of_point_cnt = 9,
	ram_word_len      = 50,
	reg_amount        = 8
)
/*(
	input clk;
)*/


//inputs to DUT
logic	clk, rst_n;
logic	pwrite, psel, penable
logic 	[addrWidth-1:0] paddr;
logic  	[dataWidth-1:0] pwdata;
//outputs from DUT
logic	pready, interupt;
logic  	[dataWidth-1:0] prdata;

endinterface : Kmeans_if
