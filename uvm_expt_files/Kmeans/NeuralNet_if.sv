/*------------------------------------------------------------------------------
 * File          : NeuralNet_if.sv
 * Project       : Ver_MLExpt
 * Author        : goel
 * Creation date : Feb 10, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

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

logic	clk, rst_n;

logic	pwrite, psel, penable, pready, interupt;
logic [addrWidth-1:0] paddr;
logic  [dataWidth-1:0] pwdata, prdata;

endinterface : Kmeans_if
