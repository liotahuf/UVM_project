/*------------------------------------------------------------------------------
 * File          : Kmeans_test_tb.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/
`include "Kmeans_pkg.sv"

`include "/users/epedlh/UVM_Project/UVMprjDir/parsing_dividing.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/accumulator_adder.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/integer_to_fixed_point_and_concatenating.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/distance_calc.sv"

`include "/users/epedlh/UVM_Project/UVMprjDir/DW_div.v"
`include "/users/epedlh/UVM_Project/UVMprjDir/demux.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/spram512x50_cb.v"


`include "/users/epedlh/UVM_Project/UVMprjDir/classify_block_pipe1.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/classify_block_pipe2.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/classify_block_pipe3.sv"

`include "/users/epedlh/UVM_Project/UVMprjDir/classification_block.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/convergence_check_block.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/new_means_calculation_block.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/controller.sv"

`include "/users/epedlh/UVM_Project/UVMprjDir/RegFile.sv"
`include "/users/epedlh/UVM_Project/UVMprjDir/k_means_core.sv"
`include "k_means_top.sv"
`include "Kmeans_if.sv"
//`include "Kmeans_Ref_if.sv"


//`include "/users/goel/synopsys78/uvm/Expt/Ver_MLExpt/src/NeuralNet_pkg.sv"
module Kmeans_test_tb;
import uvm_pkg::*;

//For Ref - todo - might add signals?

//Interface declaration
Kmeans_if vif ();
//Kmeans_Ref_if vrefif ();

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
/*
Ref_Model Ref (
	//TODO
);*/

initial begin
	//Registers Interfaces in the configuration block so that other blocks can use it
	uvm_resource_db#(virtual Kmeans_if)::set (.scope("ifs"), .name("Kmeans_if"), .val(vif));
	//uvm_resource_db#(virtual Kmeans_Ref_if)::set (.scope("ifs"), .name("Kmeans_Ref_if"), .val(vrefif));
	
	//Executes the test
	run_test("Kmeans_test");
	#220 $finish;
end

//Resets
initial begin
	vif.rst_n		= 1'b0 ;
	//vrefif.rst_n	= 1'b0 ;
	#10
			vif.rst_n  = 1'b1 ;
	//vrefif.rst_n  = 1'b1 ;
end

//Clocks - TODO : might separate them later again
initial begin
	vif.clk <= 1'b0;
	//vrefif.clk <= 1'b0;
end
//Clock generation
always begin
	#10
			vif.clk = ~vif.clk;
	//vrefif.clk = ~vrefif.clk;
end

endmodule