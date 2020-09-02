class hamming_agent extends uvm_agent;
	`uvm_component_utils(hamming_agent)

	hamming_sequencer       hm_seqr;
	hamming_driver		hm_drvr;
	hamming_monitor_dut	hm_mon_dut;
	hamming_monitor_ref	hm_mon_ref;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		hm_seqr		= hamming_sequencer::type_id::create(.name("hm_seqr"), .parent(this));
		hm_drvr		= hamming_driver::type_id::create(.name("hm_drvr"), .parent(this));
		hm_mon_dut	= hamming_monitor_dut::type_id::create(.name("hm_mon_dut"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		hm_drvr.seq_item_port.connect(hm_seqr.seq_item_export);

	endfunction: connect_phase
endclass: hamming_agent
