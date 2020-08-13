class hamming_transaction extends uvm_sequence_item;
	rand bit[7:1] x;
	bit[11:1] z;

	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(hamming_transaction)
		`uvm_field_int(x, UVM_ALL_ON)
		`uvm_field_int(z, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: hamming_transaction

class hamming_sequence extends uvm_sequence#(hamming_transaction);
	`uvm_object_utils(hamming_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
		hamming_transaction hm_tx;
		
		repeat(15) begin
		hm_tx = hamming_transaction::type_id::create(.name("hm_tx"), .contxt(get_full_name()));

		start_item(hm_tx);
                  if (!hm_tx.randomize()) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error");
		finish_item(hm_tx);
		end
	endtask: body 
endclass: hamming_sequence

typedef uvm_sequencer#(hamming_transaction) hamming_sequencer;
