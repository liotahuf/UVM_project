//`include "/users/goel/synopsys78/uvm/Expt/Ver_MLExpt/src/NeuralNet_pkg.sv"
module NeuralNet_tb_uvm;
	import uvm_pkg::*;
	logic [71:0] InputImage; //For Ref
	//Interface declaration
	NeuralNet_if vif();
	NeuralNet_Ref_if vrefif();

	//Connects the Interface to the DUT
	NeuralNet dut(vif.clk,
		    vif.pixels,
		    vif.rst,
			vif.learn,
			vif.classify,
			vif.KIDATA1,
			vif.KIDATA2,
			vif.W1IDATA1,
			vif.W1IDATA2,
			vif.W2IDATA1,
			vif.W2IDATA2,
			vif.result);
	
	NeuralNet_Ref Ref(vrefif.clk,vrefif.rst,vrefif.InputImage,vrefif.result);

	initial begin
		//Registers the Interface in the configuration block so that other
		//blocks can use it
		uvm_resource_db#(virtual NeuralNet_if)::set (.scope("ifs"), .name("NeuralNet_if"), .val(vif));
		uvm_resource_db#(virtual NeuralNet_Ref_if)::set (.scope("ifs"), .name("NeuralNet_Ref_if"), .val(vrefif));
		//Executes the test
		run_test("NeuralNet_test");
		#220 $finish;
	end
	
	initial begin
		vif.rst  = 1'b1 ;
		vrefif.rst  = 1'b1 ;
		vif.learn  = 1'b0 ;
		vif.classify  = 1'b0 ;
		#10
		vif.rst  = 1'b0 ;
		vrefif.rst  = 1'b0 ;
		vif.learn  = 1'b1 ;
		#10
		#10
		vif.learn  = 1'b0 ;
		vif.classify  = 1'b1 ;
		#220 $finish;
	end
	

		initial begin 
		#15 
		vif.KIDATA1 = 32'h01ffff01 ; //first filter looks for \
		vif.W1IDATA1 = 64'h01ffff01 ; 
		vif.W2IDATA1 = 64'hff0101ff ; 
		vif.W1IDATA2 = 64'hff0101ff ; 
		vif.W2IDATA2 = 64'h01ffff01 ; 
		//KIDATA1 = 32'h0; W1IDATA1 = 64'h1; W2IDATA1 = 64'h2; W1IDATA2 = 64'h3; W2IDATA2 = 64'h4;
		#10 
		vif.KIDATA1 = 32'hff0101ff ;  //second filter looks for /
		vif.W1IDATA1 = 64'hffffffff ; 
		vif.W2IDATA1 = 64'hff0101ff ; 
		vif.W1IDATA2 = 64'h01ffff01 ; 
		vif.W2IDATA2 = 64'hffffffff ; 
		//KIDATA1 = 32'h5; W1IDATA1 = 64'h6; W2IDATA1 = 64'h7; W1IDATA2 = 64'h8; W2IDATA2 = 64'h9; 
		#10
		#220 $finish; 
		end

	//Variable initialization
	initial
		vif.clk <= 1'b0;
	//Clock generation
	always
		#5 vif.clk = ~vif.clk;
	initial
		vrefif.clk <= 1'b0;
	//Clock generation
	always
		#5 vrefif.clk = ~vrefif.clk;
endmodule
