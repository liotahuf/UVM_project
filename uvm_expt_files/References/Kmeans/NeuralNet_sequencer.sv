`define addrWidth 9
`define dataWidth 91
`define wordDepth 512
`define centroid_num 8

enum logic [reg_amount-1:0] { internal_status_reg,
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

/* class Write_Ram_transaction extends uvm_sequence_item;
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
endclass: Kmeans_transaction */

//transaction under APB protocol
class APB_transaction extends uvm_sequence_item;
	bit [addrWidth-1:0] address;
	bit [dataWidth-1:0] data;
	bit sel, enable, write;
	
	//might rmv those logic:
		//logic [2:0] cent_index;
		//logic amount_of_points?
	
	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(Kmeans_transaction)
		`uvm_field_int(address, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		//`uvm_field_int(ready, UVM_ALL_ON)
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
		`uvm_info ("KMEANS_IN_SEQ", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
		APB_transaction		apb_tx,apb_tx2;
		rand logic [centroid_num-1:0][dataWidth-1:0] centroids;
		
		//write centroids to DUT
		for (i = 0; i < n_times; i = i + 1) begin
			
			apb_tx = APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			apb_tx.data		= centroids[i];//data is full centroid value
			apb_tx.address	= register_num[2+i];//2 is first centroid, until 9 which is last centroid's address
			apb_tx.sel		= 1'b0;
			apb_tx.enable	= 1'b0;
			apb_tx.write	= 1'b1;
			
			start_item(apb_tx);
			finish_item(apb_tx);
			
			//hold one cycle now - or driver should get pready signal from DUT and recognize the DUT got the transaction?
			apb_tx2 = APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			apb_tx2.data		= 0;
			apb_tx2.address	= 0;
			apb_tx2.sel		= 1'b0;//toggled off
			apb_tx2.enable	= 1'b1;
			apb_tx2.write	= 1'b1;
			
			start_item(apb_tx2);
			finish_item(apb_tx2);
			
		end
		
		//write data points to DUT - TODO later
		/* repeat(n_times) begin
			apb_tx = APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			start_item(apb_tx);
				if (!hm_tx.randomize()) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error");
			finish_item(apb_tx);
		end */
		
		
		

	endtask: body
	
	
endclass: Kmeans_in_sequence

typedef uvm_sequencer#(APB_transaction) Kmeans_sequencer;

/* 
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
endclass: Kmeans_sequence */

/* typedef uvm_sequencer#(Kmeans_transaction) Kmeans_sequencer; */
