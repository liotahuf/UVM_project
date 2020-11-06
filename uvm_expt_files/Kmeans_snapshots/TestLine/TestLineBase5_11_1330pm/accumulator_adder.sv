/*------------------------------------------------------------------------------
 * File          : accumulator_adder.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module accumulator_adder 
#(
	parameter
	tc_mode         = 0,
	rem_mode        =1,
	accum_width = 7*22,
	addrWidth = 8,
	dataWidth = 91, 
	centroid_num =8,
	accum_cord_width = 22,
	cordinate_width = 13,
	count_width = 10
)  
(
		input [dataWidth-1:0]  point,
		input [accum_width-1:0]  accumulator,
		//
		output [accum_width-1:0]	result
);

//first point
wire signed [cordinate_width -1:0] point_cord_1_2c;
wire signed [cordinate_width -1:0] point_cord_2_2c;
wire signed [cordinate_width -1:0] point_cord_3_2c;
wire signed [cordinate_width -1:0] point_cord_4_2c;
wire signed [cordinate_width -1:0] point_cord_5_2c;
wire signed [cordinate_width -1:0] point_cord_6_2c;
wire signed [cordinate_width -1:0] point_cord_7_2c;
//first point expended with signing
wire signed [accum_cord_width -1:0] point_cord_1ex;
wire signed [accum_cord_width -1:0] point_cord_2ex;
wire signed [accum_cord_width -1:0] point_cord_3ex;
wire signed [accum_cord_width -1:0] point_cord_4ex;
wire signed [accum_cord_width -1:0] point_cord_5ex;
wire signed [accum_cord_width -1:0] point_cord_6ex;
wire signed [accum_cord_width -1:0] point_cord_7ex;

//second point
wire signed [accum_cord_width -1:0] accum_point_cord_1;
wire signed [accum_cord_width -1:0] accum_point_cord_2;
wire signed [accum_cord_width -1:0] accum_point_cord_3;
wire signed [accum_cord_width -1:0] accum_point_cord_4;
wire signed [accum_cord_width -1:0] accum_point_cord_5;
wire signed [accum_cord_width -1:0] accum_point_cord_6;
wire signed [accum_cord_width -1:0] accum_point_cord_7;
//
//per_cordinate_adder
wire signed [accum_cord_width -1:0] cord_1_result;
wire signed [accum_cord_width -1:0] cord_2_result;
wire signed [accum_cord_width -1:0] cord_3_result;
wire signed [accum_cord_width -1:0] cord_4_result;
wire signed [accum_cord_width -1:0] cord_5_result;
wire signed [accum_cord_width -1:0] cord_6_result;
wire signed [accum_cord_width -1:0] cord_7_result;


//wire assigns
assign point_cord_1_2c = ~(point[1*cordinate_width -1:0*cordinate_width] - 1'b1);
assign point_cord_2_2c = ~(point[2*cordinate_width -1:1*cordinate_width] - 1'b1);
assign point_cord_3_2c = ~(point[3*cordinate_width -1:2*cordinate_width] - 1'b1);
assign point_cord_4_2c = ~(point[4*cordinate_width -1:3*cordinate_width] - 1'b1);
assign point_cord_5_2c = ~(point[5*cordinate_width -1:4*cordinate_width] - 1'b1);
assign point_cord_6_2c = ~(point[6*cordinate_width -1:5*cordinate_width] - 1'b1);
assign point_cord_7_2c = ~(point[7*cordinate_width -1:6*cordinate_width] - 1'b1);
//assign abs extended with relevant sign, then give sign
assign point_cord_1ex = (point[1*cordinate_width-1] ? -{9'd0,point_cord_1_2c} : {9'd0,point[1*cordinate_width -1:0*cordinate_width]});
assign point_cord_2ex = (point[2*cordinate_width-1] ? -{9'd0,point_cord_2_2c} : {9'd0,point[2*cordinate_width -1:1*cordinate_width]});
assign point_cord_3ex = (point[3*cordinate_width-1] ? -{9'd0,point_cord_3_2c} : {9'd0,point[3*cordinate_width -1:2*cordinate_width]});
assign point_cord_4ex = (point[4*cordinate_width-1] ? -{9'd0,point_cord_4_2c} : {9'd0,point[4*cordinate_width -1:3*cordinate_width]});
assign point_cord_5ex = (point[5*cordinate_width-1] ? -{9'd0,point_cord_5_2c} : {9'd0,point[5*cordinate_width -1:4*cordinate_width]});
assign point_cord_6ex = (point[6*cordinate_width-1] ? -{9'd0,point_cord_6_2c} : {9'd0,point[6*cordinate_width -1:5*cordinate_width]});
assign point_cord_7ex = (point[7*cordinate_width-1] ? -{9'd0,point_cord_7_2c} : {9'd0,point[7*cordinate_width -1:6*cordinate_width]});
//
assign accum_point_cord_1 = accumulator[1*accum_cord_width -1:0*accum_cord_width];
assign accum_point_cord_2 = accumulator[2*accum_cord_width -1:1*accum_cord_width];
assign accum_point_cord_3 = accumulator[3*accum_cord_width -1:2*accum_cord_width];
assign accum_point_cord_4 = accumulator[4*accum_cord_width -1:3*accum_cord_width];
assign accum_point_cord_5 = accumulator[5*accum_cord_width -1:4*accum_cord_width];
assign accum_point_cord_6 = accumulator[6*accum_cord_width -1:5*accum_cord_width];
assign accum_point_cord_7 = accumulator[7*accum_cord_width -1:6*accum_cord_width];
/*----comb logic----*/
assign cord_1_result = (accum_point_cord_1 + point_cord_1ex);
assign cord_2_result = (point_cord_2ex + accum_point_cord_2);
assign cord_3_result = (point_cord_3ex + accum_point_cord_3);
assign cord_4_result = (point_cord_4ex + accum_point_cord_4);
assign cord_5_result = (point_cord_5ex + accum_point_cord_5);
assign cord_6_result = (point_cord_6ex + accum_point_cord_6);
assign cord_7_result = (point_cord_7ex + accum_point_cord_7);
//
assign result = {cord_7_result,cord_6_result,cord_5_result,cord_4_result,cord_3_result,cord_2_result,cord_1_result};

endmodule

///*-----Wires-----*/


