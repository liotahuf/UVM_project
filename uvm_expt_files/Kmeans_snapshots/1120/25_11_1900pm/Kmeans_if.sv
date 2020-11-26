/*------------------------------------------------------------------------------
 * File          : Kmeans_if.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/
/*`define addrWidth 9
`define dataWidth 91*/

interface Kmeans_if;
/*#(
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
()*/


//inputs to DUT
logic	clk;
logic	rst_n;
logic	pwrite;
logic	psel;
logic	penable;
logic 	[9-1:0] paddr;//addrWidth = 9
logic  	[91-1:0] pwdata;//dataWidth = 91
//outputs from DUT
logic	pready;
logic 	interupt;
logic  	[91-1:0] prdata;//dataWidth = 91



endinterface : Kmeans_if
