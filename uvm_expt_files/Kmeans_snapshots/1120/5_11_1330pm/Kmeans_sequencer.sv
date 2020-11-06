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

class data_points_matrix extends uvm_sequence_item;
	logic [512][91] data_points;
	logic [12:0] threshold;
	
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	`uvm_object_utils_begin(data_points_matrix)
		`uvm_field_int(data_points, UVM_ALL_ON)
		`uvm_field_int(threshold, UVM_ALL_ON)
	`uvm_object_utils_end
endclass


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
				$display("cordinate [%d]: %h",num_cords-(j),centroids[i][13*j +:13],UVM_LOW);
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
	int min_num_points = 8;
	int max_num_points = 512;
	rand logic [4] range;
	
	//max_points = 512;
	rand logic [512][91] data_points;
	
	constraint legal_num_points {
		num_points >= min_num_points;
		num_points <= max_num_points;
	}
	
	
	rand logic [12:0] threshold;
	constraint Accuracy {
		threshold[12:8] == 5'd0;
	}
	
	//ram boundaries
	rand logic [13] first_point_index;
	rand logic [13] last_point_index;
	constraint RamBoundaries_low {
		first_point_index <= 512 - num_points;
		first_point_index >=1;
	}
	constraint RamBoundaries_High {
		last_point_index == num_points + first_point_index - 13'b1;
	}
	
	constraint rng {
		range >= 4'd7;
		//TODO: return range up to 11
		range <= 4'd11;//11;
	}
	//data/constraints for Test Line
	constraint TestLine4 {
		threshold == 13'b1;
		num_points >= range*30;//50;
	}
	
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	//TODO - make sure this is okay not writing both unpacked arrays to factory
	`uvm_object_utils_begin(Kmeans_transaction)
		//`uvm_field_int(centroids, UVM_ALL_ON)
		`uvm_field_int(num_points, UVM_ALL_ON)
		`uvm_field_int(threshold, UVM_ALL_ON)
		`uvm_field_int(first_point_index, UVM_ALL_ON)
		`uvm_field_int(last_point_index, UVM_ALL_ON)
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
	int num_txs = 100;
	int j,i,m;
	int num_centroids = 8;
	
	//perform sequence - push inputs to DUT - fill centroids and data points
	task body();
		`uvm_info ("KMEANS_IN_SEQUENCE", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
		
		for (j=0 ; j<num_txs ; j++) begin
			$display("SEQUENCE, tx number %d",j+1,UVM_LOW);
			kmeans_tx = Kmeans_transaction::type_id::create(.name("kmeans_tx"), .contxt(get_full_name()));
			if (!kmeans_tx.randomize()) begin
				`uvm_error("USER_DEFINED_FLAG", "This is a randomize error");
			end
			
			//Test Line changes: begin
			//kmeans_tx.num_points += 50*j;
			//kmeans_tx.last_point_index += 50*j;
			//Test Line changes: end
			
			
			start_item(kmeans_tx);
			
			$display("SEQUENCE, num points is %d, firstRam idx %d, lastRam idx %d, threshold %b,range %d ",kmeans_tx.num_points,
					kmeans_tx.first_point_index, kmeans_tx.last_point_index, kmeans_tx.threshold,kmeans_tx.range ,UVM_LOW);
			
			finish_item(kmeans_tx);
			
		end
		
	endtask: body
	
	
endclass: Kmeans_in_sequence

typedef uvm_sequencer#(Kmeans_transaction) Kmeans_sequencer;
