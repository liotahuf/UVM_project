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
	uvm_analysis_export #(centroid_transaction) sb_export_ref;
	
	uvm_tlm_analysis_fifo #(APB_transaction) dut_fifo;
	uvm_tlm_analysis_fifo #(centroid_transaction) ref_fifo;
	
	int num_centroids = 8;
	
	APB_transaction dut_tx;
	
	//logic [91] dut_centroids[1:8];
	
	centroid_transaction dut_centroids;
	centroid_transaction ref_centroids;
	
	int i, j;
	
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
		
		
		//ref_txs		= new("ref_tx");
	endfunction: new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		sb_export_dut	= new("sb_export_dut", this);
		sb_export_ref	= new("sb_export_ref", this);
		
		dut_fifo		= new("dut_fifo", this);
		ref_fifo		= new("ref_fifo", this);
		
		//dut_tx	= APB_transaction::type_id::create(.name("dut_tx"), .contxt(get_full_name()));
		
		dut_centroids = centroid_transaction::type_id::create(.name("dut_centroids"), .contxt(get_full_name()));
		ref_centroids = centroid_transaction::type_id::create(.name("ref_centroids"), .contxt(get_full_name()));
		
	endfunction: build_phase
	
	function void connect_phase(uvm_phase phase);
		sb_export_dut.connect(dut_fifo.analysis_export);
		sb_export_ref.connect(ref_fifo.analysis_export);
	endfunction: connect_phase
	
	task run();
		`uvm_info("", "run method of Kmeans_scoreboard", UVM_MEDIUM);
		
		//TODO - get 8 centroids from REF model
		
		//get centroids from DUT, one by one, and then all togheter from REFMODEL
		j = 1;
		forever begin
			for (j=0;j<num_centroids;j++) begin
				dut_fifo.get(dut_tx);
				//$display("scoreboard, used in fifo = %d:",dut_fifo.used(),UVM_LOW);
				dut_centroids.centroids[j] = dut_tx.data;
			end
			
			ref_fifo.get(ref_centroids);
		
			compare();
		end
		
	endtask: run
	
	virtual function void compare();
		$display("scoreboard, DUT centroids print",UVM_LOW);
		dut_centroids.print();
		$display("scoreboard, REFMODEL centroids print",UVM_LOW);
		ref_centroids.print();

		//TODO - need to implement according to how we get output transaction from dut,ref
		
		/*for (i=0; i <num_centroids ; i++) begin
			$display("scoreboard, pkt number %d, pkt = %h:",i+1,dut_centroids.centroids[i],UVM_LOW);

			//`uvm_info("pkt print at compare:" ,dut_tx.sprint(), UVM_LOW)
		end*/
		
	endfunction: compare
endclass: Kmeans_scoreboard
