/*------------------------------------------------------------------------------
 * File          : Kmeans_sequencer.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

`define addrWidth 9
`define dataWidth 91
`define wordDepth 512
`define centroid_num 8
//`define max_points 512 - TODO - maybe use this for data points array max size

class centroid_transaction extends uvm_sequence_item;
	logic [8][91] centroids;//dataWidth
	int i,j;
	int num_cords = 7;
	int num_centroids = 8;
	
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	`uvm_object_utils_begin(centroid_transaction)
		`uvm_field_int(centroids, UVM_ALL_ON)
	`uvm_object_utils_end
	
	function print();
		$display("CENT TX PRINT:",UVM_LOW);
		for (i=0; i<num_centroids; i++) begin
			$display("CENT %d PRINT: %h",i+1,centroids[i],UVM_LOW);
			for (j=0;j<num_cords;j++) begin
				$display("cordinate [%d]: %h",j+1,centroids[i][13*j +:13],UVM_LOW);
			end
		end
	endfunction
endclass

//transaction under APB protocol
class APB_transaction extends uvm_sequence_item;
	bit write;
	rand bit [91-1:0] data;//dataWidth
	bit [9-1:0] address;//addrWidth
	
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	`uvm_object_utils_begin(APB_transaction)
		`uvm_field_int(address, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(write, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: APB_transaction

//full single kmeans calculation
class Kmeans_transaction extends uvm_sequence_item;
	//TODO - add constraints for randing here
	rand logic [8][91] centroids;
	rand int num_points;
	//const int max_points = 512;
	rand logic [512][91] data_points;
	
	constraint legal_num_points {
		num_points >= 8;
		num_points <= 512;
	}
	
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	//TODO - make sure this is okay not writing both unpacked arrays to factory
	`uvm_object_utils_begin(Kmeans_transaction)
		//`uvm_field_int(centroids, UVM_ALL_ON)
		`uvm_field_int(num_points, UVM_ALL_ON)
		//`uvm_field_int(data_points, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: Kmeans_transaction


class Kmeans_in_sequence extends uvm_sequence#(Kmeans_transaction);
	`uvm_object_utils (Kmeans_in_sequence)
	
	//constructor
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	Kmeans_transaction kmeans_tx;
	
	//perform sequence - push inputs to DUT - fill centroids and data points
	task body();
		`uvm_info ("KMEANS_IN_SEQUENCE", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
		
		//TODO - make the following in a loop - do many kmeans_transactions
		kmeans_tx = Kmeans_transaction::type_id::create(.name("kmeans_tx"), .contxt(get_full_name()));
		
		start_item(kmeans_tx);
		if (!kmeans_tx.randomize()) begin
			`uvm_error("USER_DEFINED_FLAG", "This is a randomize error");
		end
		$display("SEQUENCE, num points is %d",kmeans_tx.num_points ,UVM_LOW);
		for (int i = 0; i < 8; i++) begin
			$display("SEQUENCE, centroid %d is h'%h DONE",i,kmeans_tx.centroids[i] ,UVM_LOW);
		end
		
		finish_item(kmeans_tx);

	endtask: body
	
	
endclass: Kmeans_in_sequence

typedef uvm_sequencer#(Kmeans_transaction) Kmeans_sequencer;