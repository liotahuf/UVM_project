class NeuralNet_agent extends uvm_agent;
	`uvm_component_utils(NeuralNet_agent)
	
	uvm_analysis_port#(NeuralNet_transaction) agent_ap_dut;

	NeuralNet_sequencer		ml_seqr;
	NeuralNet_driver		ml_drvr;
	NeuralNet_monitor_dut   ml_mon_dut;
	NeuralNet_monitor_ref   ml_mon_ref;


	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent_ap_dut    = new(.name("agent_ap_dut"), .parent(this));

		ml_seqr		= NeuralNet_sequencer::type_id::create(.name("ml_seqr"), .parent(this));
		ml_drvr		= NeuralNet_driver::type_id::create(.name("ml_drvr"), .parent(this));
		ml_mon_dut  = NeuralNet_monitor_dut::type_id::create(.name("ml_mon_dut"), .parent(this));
		ml_mon_ref  = NeuralNet_monitor_ref::type_id::create(.name("ml_mon_ref"), .parent(this));
		//`uvm_info("", "Build of Agent", UVM_MEDIUM)
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		ml_drvr.seq_item_port.connect(ml_seqr.seq_item_export);
		//`uvm_info("", "Connect Phase of Agent", UVM_MEDIUM)
		ml_mon_dut.mon_ap_dut.connect(agent_ap_dut);

	endfunction: connect_phase
endclass: NeuralNet_agent
