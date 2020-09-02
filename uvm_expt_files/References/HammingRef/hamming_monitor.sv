class hamming_monitor_dut extends uvm_monitor;
	`uvm_component_utils(hamming_monitor_dut)

	virtual hamming_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual hamming_if)::read_by_name (.scope("ifs"), .name("hamming_if"), .val(vif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase);

		hamming_transaction hm_tx;
		hm_tx = hamming_transaction::type_id::create (.name("hm_tx"), .contxt(get_full_name()));

		forever begin @(posedge vif.sig_clock) 
                   begin 
                     hm_tx.z = vif.sig_z;
                     hm_tx.x = vif.sig_x; 
                     //Send the transaction to the analysis port
                   end 
                end 
        endtask: run_phase endclass:

hamming_monitor_dut

