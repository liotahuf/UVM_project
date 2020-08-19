/*------------------------------------------------------------------------------
 * File          : Kmeans_scoreboard.v
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 18, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

/*module Kmeans_scoreboard #() ();

endmodule*/

//`uvm_analysis_imp_decl(_dut)
//`uvm_analysis_imp_decl(_ref)

class Kmeans_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(Kmeans_scoreboard)

	uvm_analysis_export #(Kmeans_transaction) sb_export_dut;
	uvm_analysis_export #(Kmeans_transaction) sb_export_ref;

	uvm_tlm_analysis_fifo #(Kmeans_transaction) dut_fifo;
	uvm_tlm_analysis_fifo #(Kmeans_transaction) ref_fifo;

	Kmeans_transaction transaction_dut;
	Kmeans_transaction transaction_ref;

	function new(string name, uvm_component parent);
		super.new(name, parent);

		transaction_dut	= new("transaction_dut");
		transaction_ref	= new("transaction_ref");
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		sb_export_dut	= new("sb_export_dut", this);
		sb_export_ref	= new("sb_export_ref", this);
		
		dut_fifo		= new("dut_fifo", this);
		ref_fifo		= new("ref_fifo", this);
		
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		sb_export_dut.connect(dut_fifo.analysis_export);
		sb_export_ref.connect(ref_fifo.analysis_export);
	endfunction: connect_phase

	task run();
		forever begin
		   `uvm_info("", "run method of Kmeans_scoreboard", UVM_MEDIUM);
		   dut_fifo.get(transaction_dut);
		   ref_fifo.get(transaction_ref);
		   compare();
		end
	endtask: run

	virtual function void compare();
		//TODO - need to implement according to how we get output transaction from dut,ref
		
	endfunction: compare
endclass: Kmeans_scoreboard
