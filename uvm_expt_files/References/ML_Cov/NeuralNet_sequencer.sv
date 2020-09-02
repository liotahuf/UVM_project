class NeuralNet_transaction extends uvm_sequence_item;
	
	rand logic [71:0] InputImage;
	logic [7:0] result;
	
	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(NeuralNet_transaction)
		`uvm_field_int(InputImage, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: NeuralNet_transaction

class NeuralNet_sequence extends uvm_sequence#(NeuralNet_transaction);
	`uvm_object_utils(NeuralNet_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
		NeuralNet_transaction ml_pkt;
		`uvm_info("", "Randomize Try0", UVM_MEDIUM)
		repeat(9) begin
		ml_pkt = NeuralNet_transaction::type_id::create(.name("ml_pkt"), .contxt(get_full_name()));
	    //`uvm_info("ml_pkt_sequence", ml_pkt.sprint(), UVM_LOW);
		start_item(ml_pkt);
		   //goel below is recommended assert(ml_pkt.randomize());
           //if (!ml_pkt.randomize() ) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error")
           //if (!ml_pkt.randomize() with { ml_pkt.InputImage[1:0] == 2'b0; }) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error")
		   if (!ml_pkt.randomize() with { ml_pkt.InputImage inside {72'h01ff01ff01ff01ff01,72'hff01ff01ff01ff01ff,72'h01ffffff01ffffff01,72'hffff01ff01ff01ffff} ; }) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error")
		   //`uvm_info("ml_sequence", ml_pkt.sprint(), UVM_LOW)
		finish_item(ml_pkt);
		end
	endtask: body 
endclass: NeuralNet_sequence

typedef uvm_sequencer#(NeuralNet_transaction) NeuralNet_sequencer;
