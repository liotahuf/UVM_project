class hamming_driver extends uvm_driver#(hamming_transaction);
	`uvm_component_utils(hamming_driver)

	virtual hamming_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual hamming_if)::read_by_name (.scope("ifs"), .name("hamming_if"), .val(vif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		drive();
	endtask: run_phase

	virtual task drive();
		hamming_transaction hm_tx;
		vif.sig_x = 7'b0000000;

		forever begin
			begin
				   seq_item_port.get_next_item(hm_tx);
					   `uvm_info("hm_sequence", hm_tx.sprint(), UVM_LOW);
					   vif.sig_x = hm_tx.x;
			end

			@(posedge vif.sig_clock)
			begin
			   seq_item_port.item_done();
			end
		end
	endtask: drive
endclass: hamming_driver
