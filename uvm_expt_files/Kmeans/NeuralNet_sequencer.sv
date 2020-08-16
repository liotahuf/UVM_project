`define addrWidth 9
`define dataWidth 91
`define wordDepth 512
`define centroid_num 8


/* class Centroids_transaction extends uvm_sequence_item;
	logic [90:0] centroid;
	logic valid;
	
	function new(string name = "");
		super.new(name);
	endfunction: new
	
endclass: Centroids_transaction */


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

class Write_Ram_transaction extends uvm_sequence_item;
	//made of apb write of ram addr, afterwards apb write of ram data
	
		
	function new(string name = "");
		super.new(name);
	endfunction: new
	
endclass: Write_Ram_transaction

class APB_read_transaction extends uvm_sequence_item;
	
	//TODO:
	//gen amount of data points - restricted to RAM size
	//gen data points according to amount gen'd before
	//then push them inside and work it out

	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(Kmeans_transaction)
		`uvm_field_int(InputImage, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: APB_read_transaction

class APB_write_transaction extends uvm_sequence_item;
	
	//TODO:
	//gen amount of data points - restricted to RAM size
	//gen data points according to amount gen'd before
	//then push them inside and work it out
	
	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(Kmeans_transaction)
		`uvm_field_int(InputImage, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: Kmeans_transaction

//transaction under APB protocol
class APB_transaction extends uvm_sequence_item;
	bit [addrWidth-1:0] address;
	bit [dataWidth-1:0] data;
	bit sel, ready, enable, write;
	
	//might rmv those logic:
		//logic [2:0] cent_index;
		//logic amount_of_points?
	
	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(Kmeans_transaction)
		`uvm_field_int(address, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(ready, UVM_ALL_ON)
		`uvm_field_int(sel, UVM_ALL_ON)
		`uvm_field_int(enable, UVM_ALL_ON)
		`uvm_field_int(write, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: Kmeans_transaction





class Kmeans_in_sequence extends uvm_sequence#(APB_transaction);
   `uvm_object_utils (Kmeans_in_sequence)
   
	int unsigned		n_times = centroid_num;//amount of centroids

	//constructor
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	//perform sequence - push inputs to DUT - fill centroids and data points
	task body();
		`uvm_info ("BASE_SEQ", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
		APB_transaction		apb_tx;
		
		//write centroids to DUT
		repeat(n_times) begin
			apb_tx = APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			start_item(apb_tx);
				if (!hm_tx.randomize()) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error");
			finish_item(apb_tx);
		end
		
		//write data points to DUT
		repeat(n_times) begin
			apb_tx = APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			start_item(apb_tx);
				if (!hm_tx.randomize()) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error");
			finish_item(apb_tx);
		end
		
		
		

	endtask: body
	
	
endclass: Write_Ram_transaction

class Kmeans_sequence extends uvm_sequence#(Kmeans_transaction);
	`uvm_object_utils(Kmeans_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
		Kmeans_transaction ml_pkt;
		`uvm_info("", "Randomize Try0", UVM_MEDIUM)
		repeat(2) begin
		in_pkt = Kmeans_transaction::type_id::create(.name("in_pkt"), .contxt(get_full_name()));
	    //`uvm_info("ml_pkt_sequence", ml_pkt.sprint(), UVM_LOW);
		start_item(in_pkt);
			
			//TODO add some assert as recommended
		   //goel below is recommended assert(ml_pkt.randomize());
           //if (!ml_pkt.randomize() ) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error")
           //if (!ml_pkt.randomize() with { ml_pkt.InputImage[1:0] == 2'b0; }) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error")
		   //if (!in_pkt.randomize() with { ml_pkt.InputImage inside {72'h01ff01ff01ff01ff01,72'hff01ff01ff01ff01ff,72'h01ffffff01ffffff01,72'hffff01ff01ff01ffff} ; }) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error")		   
		   //`uvm_info("ml_sequence", ml_pkt.sprint(), UVM_LOW)
		   
		finish_item(in_pkt);
		end
	endtask: body 
endclass: Kmeans_sequence

typedef uvm_sequencer#(Kmeans_transaction) Kmeans_sequencer;
