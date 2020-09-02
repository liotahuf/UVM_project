class Kmeans_agent extends uvm_agent;
	`uvm_component_utils(Kmeans_agent)
	
	uvm_analysis_port#(Kmeans_transaction) agent_ap_dut;
	uvm_analysis_port#(Kmeans_transaction) agent_ap_ref;

	Kmeans_sequence		kmeans_seqr;
	Kmeans_driver		kmeans_drvr;
	Kmeans_monitor_dut  kmeans_mon_dut;
	Kmeans_monitor_ref  kmeans_mon_ref;


	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent_ap_dut    = new(.name("agent_ap_dut"), .parent(this));

		kmeans_seqr		= Kmeans_sequencer::type_id::create(.name("kmeans_seqr"), .parent(this));
		kmeans_drvr		= Kmeans_driver::type_id::create(.name("kmeans_drvr"), .parent(this));
		kmeans_mon_dut  = Kmeans_monitor_dut::type_id::create(.name("kmeans_mon_dut"), .parent(this));
		kmeans_mon_ref  = Kmeans_monitor_ref::type_id::create(.name("kmeans_mon_ref"), .parent(this));
		
		`uvm_info("", "Build of Agent", UVM_MEDIUM)
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		//connect driver to sequncer , driver is getting input from sequncer
		kmeans_drvr.seq_item_port.connect(kmeans_seqr.seq_item_export);
				
		//connect 2 ports towards connecting to scoreboard under ENV hierarchy, agent here is the output and monitors are inputs
		kmeans_mon_dut.mon_ap_dut.connect(agent_ap_dut);
		kmeans_mon_ref.mon_ap_ref.connect(agent_ap_ref);

		`uvm_info("", "Connect Phase of Agent", UVM_MEDIUM)
	endfunction: connect_phase
endclass: Kmeans_agent
