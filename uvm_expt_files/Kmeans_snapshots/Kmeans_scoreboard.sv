/*------------------------------------------------------------------------------
 * File          : Kmeans_scoreboard.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/
/*module Kmeans_scoreboard #() ();

endmodule*/

//`uvm_analysis_imp_decl(_dut)
//`uvm_analysis_imp_decl(_ref)

class Kmeans_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(Kmeans_scoreboard)

	uvm_analysis_export #(APB_transaction) sb_export_dut;
	//uvm_analysis_export #(APB_transaction) sb_export_ref;

	uvm_tlm_analysis_fifo #(APB_transaction) dut_fifo;
	//uvm_tlm_analysis_fifo #(APB_transaction) ref_fifo;

	int num_centroids = 8;

	APB_transaction dut_txs[];
	//APB_transaction ref_txs[1:8];

	int i;
	
	
	function new(string name, uvm_component parent);
		super.new(name, parent);

		dut_txs		= new[num_centroids];
		foreach(dut_txs[i]) dut_txs[i] = APB_transaction::type_id::create("dut_tx");

		//ref_txs		= new("ref_tx");
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		sb_export_dut	= new("sb_export_dut", this);
		//sb_export_ref	= new("sb_export_ref", this);
		
		dut_fifo		= new("dut_fifo", this);
		//ref_fifo		= new("ref_fifo", this);
		
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		sb_export_dut.connect(dut_fifo.analysis_export);
		//sb_export_ref.connect(ref_fifo.analysis_export);
	endfunction: connect_phase

	task run();
		//forever begin
		
		
		//TODO - get 8 centroids from REF model
		//get 8 centroids from DUT
		for (i=0; i <num_centroids ; i++) begin
		   `uvm_info("", "run method of Kmeans_scoreboard", UVM_MEDIUM);
		   dut_fifo.get(dut_txs[i]);
		   //ref_fifo.get(transaction_ref);
		   
		  /* $display("scoreboard, pkt number %d:",i+1,UVM_LOW);
		   `uvm_info("pkt print:" ,dut_txs[i].sprint(), UVM_LOW)*/
		end
		compare();
		
	endtask: run

	virtual function void compare();
		//TODO - need to implement according to how we get output transaction from dut,ref
		for (i=0; i <num_centroids ; i++) begin
			$display("scoreboard, pkt number %d:",i+1,UVM_LOW);
			`uvm_info("pkt print:" ,dut_txs[i].sprint(), UVM_LOW)
		end
		
	endfunction: compare
endclass: Kmeans_scoreboard
