/*------------------------------------------------------------------------------
 * File          : Kmeans_test_tb.v
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 18, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

/*module Kmeans_test_tb #() ();

endmodule*/

//`include "/users/goel/synopsys78/uvm/Expt/Ver_MLExpt/src/NeuralNet_pkg.sv"
module NeuralNet_tb_uvm;
import uvm_pkg::*;

//For Ref
logic [71:0] InputImage;

//Interface declaration
Kmeans_if vif ();
Kmeans_Ref_if vrefif ();

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

Ref_Model Ref (
	//TODO
);

initial begin
	//Registers Interfaces in the configuration block so that other blocks can use it
	uvm_resource_db#(virtual Kmeans_if)::set (.scope("ifs"), .name("Kmeans_if"), .val(vif));
	uvm_resource_db#(virtual Kmeans_Ref_if)::set (.scope("ifs"), .name("Kmeans_Ref_if"), .val(vrefif));
	
	//Executes the test
	run_test("Kmeans_test");
	#220 $finish;
end

//Resets
initial begin
	vif.rst_n		= 1'b0 ;
	vrefif.rst_n	= 1'b0 ;
	#10
			vif.rst_n  = 1'b1 ;
	vrefif.rst_n  = 1'b1 ;
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