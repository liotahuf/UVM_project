class Centroids_transaction extends uvm_sequence_item;
	logic [90:0] centroid;
endclass: Centroids_transaction

class Write_Ram_transaction extends uvm_sequence_item;
	//made of apb write of ram addr, afterwards apb write of ram data
endclass: Write_Ram_transaction

class APB_read_transaction extends uvm_sequence_item;
	
	//TODO:
	//gen amount of data points - restricted to RAM size
	//gen data points according to amount gen'd before
	//then push them inside and work it out
	
	//input
	logic [71:0] InputImage;
	//output
	logic [7:0][90:0] centroids;
	
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
	
	//input
	logic [71:0] InputImage;
	//output
	logic [7:0][90:0] centroids;
	
	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(Kmeans_transaction)
		`uvm_field_int(InputImage, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: Kmeans_transaction

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
