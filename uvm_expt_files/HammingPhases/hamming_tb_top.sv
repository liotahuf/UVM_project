`include "hamming_pkg.sv"
`include "hamming.v"
`include "hamming_if.sv"

module hamming_tb_top;
	import uvm_pkg::*;

	//Interface declaration
	hamming_if vif();

	//Connects the Interface to the DUT
	hamming dut(vif.sig_clock,
			vif.sig_x,
			vif.sig_z);

	initial begin
		//Registers the Interface in the configuration block so that other
		//blocks can use it
		uvm_resource_db#(virtual hamming_if)::set (.scope("ifs"), .name("hamming_if"), .val(vif));

		//Executes the test
		run_test();
	end

	//Variable initialization
	initial begin
		vif.sig_clock <= 1'b1;
	end

	//Clock generation
	always
		#5 vif.sig_clock = ~vif.sig_clock;

endmodule
