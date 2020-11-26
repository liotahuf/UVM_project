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
	uvm_analysis_export #(data_points_matrix) sb_export_datapoints;
	
	uvm_tlm_analysis_fifo #(APB_transaction) dut_fifo;
	uvm_tlm_analysis_fifo #(centroid_transaction) ref_fifo;
	uvm_tlm_analysis_fifo #(data_points_matrix) datapoints_fifo;
	
	int num_centroids = 8;
	int num_cords = 7;
	const int cordinate_width = 13;
	int max_datapoints = 512;
	
	APB_transaction dut_tx;
	
	centroid_transaction dut_centroids;
	centroid_transaction ref_centroids;
	data_points_matrix sb_matrix;
	
	logic signed [13] cordiff [7];
	int sum_cordiffs[8];
	int total_diff = 0;
	
	int i, j, k,num_tx;
	
	int num_fails;
	
	real fail_percent;
	
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
		
		
		//ref_txs		= new("ref_tx");
	endfunction: new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		//export wires
		sb_export_dut	= new("sb_export_dut", this);
		sb_export_ref	= new("sb_export_ref", this);
		sb_export_datapoints = new("sb_export_datapoints",this);
		
		//fifos
		dut_fifo		= new("dut_fifo", this);
		ref_fifo		= new("ref_fifo", this);
		datapoints_fifo = new("datapoints_fifo", this);
		
		//transactions data structures
		dut_centroids = centroid_transaction::type_id::create(.name("dut_centroids"), .contxt(get_full_name()));
		ref_centroids = centroid_transaction::type_id::create(.name("ref_centroids"), .contxt(get_full_name()));
		sb_matrix	  = data_points_matrix::type_id::create (.name("sb_matrix"), .contxt(get_full_name()));
		
	endfunction: build_phase
	
	function void connect_phase(uvm_phase phase);
		sb_export_dut.connect(dut_fifo.analysis_export);
		sb_export_ref.connect(ref_fifo.analysis_export);
		sb_export_datapoints.connect(datapoints_fifo.analysis_export);
	endfunction: connect_phase
	
	task run();
		`uvm_info("", "run method of Kmeans_scoreboard", UVM_MEDIUM);
		
		//get centroids from DUT, one by one, and then all togheter from REFMODEL
		num_tx = 0;
		num_fails = 0;
		forever begin
			num_tx++;
			for (j=0;j<num_centroids;j++) begin
				$display("SCOREBOARD, j = %d",j,UVM_LOW);
				dut_fifo.get(dut_tx);
				//$display("scoreboard, used in fifo = %d:",dut_fifo.used(),UVM_LOW);
				dut_centroids.centroids[j] = dut_tx.data;
			end
			
			ref_fifo.get(ref_centroids);
			
			datapoints_fifo.get(sb_matrix);
			
			$display("SCOREBOARD, tx num %d",num_tx,UVM_LOW);
			compare_centroids();
			visualize_centroids();
			fail_percent = num_fails;
			fail_percent = fail_percent/num_tx;
			$display("SCOREBOARD, num fails = %d, fail percentage = %f",num_fails,fail_percent, UVM_LOW);
		end
		

	
	endtask: run

	
	virtual function void visualize_centroids();
		$display("scoreboard, Thresh-Hold = %d",sb_matrix.threshold,UVM_LOW);
		$display("scoreboard, DUT centroids print",UVM_LOW);
		dut_centroids.print();
		$display("scoreboard, REFMODEL centroids print",UVM_LOW);
		ref_centroids.print();
	endfunction: visualize_centroids

	
	virtual function void compare_centroids();
		total_diff = 0;
		for(i = 0;i < num_centroids;i++) begin
			sum_cordiffs[i] = 0;
			for (j=0;j<num_cords;j++) begin
				cordiff[j] = ref_centroids.centroids[i][13*j +:13] - dut_centroids.centroids[i][13*j +:13];
				cordiff[j] = (cordiff[j] > 0) ? cordiff[j] : (-cordiff[j]);
				
				//$display("SCOREBARD, cordiff[%d][%d] = %d",i+1,j+1,cordiff[j],UVM_LOW);
				sum_cordiffs[i] += cordiff[j];
			end
			$display("SCOREBARD, sum cordinate diff for centroid[%d] = %d, avg cordiff = %d",i+1,sum_cordiffs[i],sum_cordiffs[i]/7,UVM_LOW);
			total_diff += sum_cordiffs[i];
		end
		if (total_diff > 2*sb_matrix.threshold*num_centroids*num_cords) begin
			num_fails++;
		end
		$display("SCOREBOARD, total diff = %d",total_diff, UVM_LOW);

		
	endfunction: compare_centroids
	
endclass: Kmeans_scoreboard
