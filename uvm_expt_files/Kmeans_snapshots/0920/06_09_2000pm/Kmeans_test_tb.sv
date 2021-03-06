/*------------------------------------------------------------------------------
 * File          : Kmeans_test_tb.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/
`include "Kmeans_pkg.sv"

//TODO - rmv all incldues to kmeans_pkg file later
`include "parsing_dividing.sv"
`include "accumulator_adder.sv"
`include "integer_to_fixed_point_and_concatenating.sv"
`include "distance_calc.sv"

`include "DW_div.v"
`include "demux.sv"
`include "spram512x50_cb.v"


`include "classify_block_pipe1.sv"
`include "classify_block_pipe2.sv"
`include "classify_block_pipe3.sv"

`include "classification_block.sv"
`include "convergence_check_block.sv"
`include "new_means_calculation_block.sv"
`include "controller.sv"

`include "RegFile.sv"
`include "k_means_core.sv"
`include "k_means_top.sv"
`include "Kmeans_if.sv"
`include "Kmeans_Ref_if.sv"

//TODO - make new area in pkg file for refModel and add below includes

`include "/users/epedlh/UVM_Project/Matlab/codegen/dll/refModel2/refModel2_dpi_pkg.sv"
`include "/users/epedlh/UVM_Project/Matlab/codegen/dll/refModel2/refModel2_dpi.sv"


//`include "/users/goel/synopsys78/uvm/Expt/Ver_MLExpt/src/NeuralNet_pkg.sv"
module Kmeans_test_tb;
import uvm_pkg::*;

//For Ref - todo - might add signals?
int i,j;
int num_centroids = 8;
logic [91] single_point;

//Interface declaration
Kmeans_if		vif ();
Kmeans_Ref_if	vrefif ();

//Connects the Interface to the DUT
k_means_top dut (
	vif.clk,
	vif.rst_n,
	vif.paddr,
	vif.pwrite,
	vif.psel,
	vif.penable,
	vif.pwdata,
	vif.prdata,
	vif.pready,
	vif.interupt
);

//TODO - make sure add include here
refModel2_dpi k_means_ref (
	vrefif.clk,
	vrefif.go,
	vrefif.rst,
	vrefif.matrix,       //TODO - make sure connection of matrix work
	vrefif.in_centroids, //TODO - make sure connection of matrix work
	vrefif.out_centroids
);

initial begin
	//Registers Interfaces in the configuration block so that other blocks can use it
	uvm_resource_db#(virtual Kmeans_if)::set (.scope("ifs"), .name("Kmeans_if"), .val(vif));
	uvm_resource_db#(virtual Kmeans_Ref_if)::set (.scope("ifs"), .name("Kmeans_Ref_if"), .val(vrefif));
	
	//Executes the test
	run_test("Kmeans_test");
	
	for(i=0 ; i < num_centroids ; i++) begin
		for(j=0 ; j<7 ; j++) begin
			single_point[13*j +:13] = vrefif.in_centroids[7*i+j];
		end
		$display("aaaa TB: centroid[%d] = %h",i+1,single_point,UVM_LOW);
	end
	#25000
	
			$finish;
end

//Resets
initial begin
	vif.rst_n		= 1'b0 ;
	vrefif.rst	= 1'b1 ;
	
	#10
			vif.rst_n  = 1'b1 ;
	vrefif.rst  = 1'b0 ;
end

//Clocks - TODO : might separate them later again
initial begin
	vif.clk <= 1'b0;
	vrefif.clk <= 1'b0;
end
//Clock generation
always begin
	#10
			vif.clk = ~vif.clk;
	vrefif.clk = ~vrefif.clk;
end

endmodule