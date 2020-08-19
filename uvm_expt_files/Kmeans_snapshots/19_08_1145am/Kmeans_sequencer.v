/*------------------------------------------------------------------------------
 * File          : Kmeans_sequencer.v
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 18, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

`define addrWidth 9
`define dataWidth 91
`define wordDepth 512
`define centroid_num 8
`define reg_amount 8

module Kmeans_sequencer #() ();

endmodule


enum logic [reg_amount-1:0] { 
	internal_status_reg,
	GO_reg,
	cent_1_reg,
	cent_2_reg,
	cent_3_reg,
	cent_4_reg,
	cent_5_reg,
	cent_6_reg,
	cent_7_reg,
	cent_8_reg,
	ram_addr_reg,
	ram_data_reg,
	first_ram_addr_reg,
	last_ram_addr_reg,
	threshold_reg
} register_num;

/* task write_to_reg_file;
	input [8-1:0] adress;
	input [dataWidth-1:0] data;
	begin
		paddr = adress;
		pwdata= data;
		pwrite = 1;
		psel=1;
		#10
				penable=1;
		#10
				psel = 1'b0;
		penable = 1'b0;
	end
endtask */

//transaction under APB protocol
class APB_transaction extends uvm_sequence_item;
	bit write;
	rand bit [dataWidth-1:0] data;
	bit [addrWidth-1:0] address;
	//bit sel, enable;

	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(Kmeans_transaction)
		`uvm_field_int(address, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		//`uvm_field_int(ready, UVM_ALL_ON)
		//`uvm_field_int(sel, UVM_ALL_ON)
		//`uvm_field_int(enable, UVM_ALL_ON)
		`uvm_field_int(write, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: APB_transaction





class Kmeans_in_sequence extends uvm_sequence#(APB_transaction);
   `uvm_object_utils (Kmeans_in_sequence)
   
	int unsigned		n_times = centroid_num;//amount of centroids

	//constructor
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	//perform sequence - push inputs to DUT - fill centroids and data points
	task body();
		`uvm_info ("KMEANS_IN_SEQUENCE", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
		//APB_transaction		apb_tx,apb_tx2;
		
		//write centroids
		for (i = 0; i < n_times; i = i + 1) begin
			
			//when creating apb_tx, data and addr are generated.
			APB_transaction apb_tx = APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			apb_tx.address	= register_num[2+i];//2 is first centroid, until 9 which is last centroid's address
			apb_tx.write	= 1'b1;
			
			start_item(apb_tx);
				//make sure randomize data field occurred
				if (!apb_tx.randomize()) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error");
			finish_item(apb_tx);
		end
		
		//read centroids
		for (i = 0; i < n_times; i = i + 1) begin
			
			//when creating apb_tx, data and addr are generated.
			APB_transaction apb_tx = APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			apb_tx.address	= register_num[2+i];//2 is first centroid, until 9 which is last centroid's address
			apb_tx.write	= 1'b0;
			apb_tx.data		= 91'b0;
			
			start_item(apb_tx);
			finish_item(apb_tx);
		end
		
		//write data points to DUT - TODO later
	endtask: body
	
	
endclass: Kmeans_in_sequence

typedef uvm_sequencer#(APB_transaction) Kmeans_sequencer;