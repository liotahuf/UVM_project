class hamming_env extends uvm_env;
	`uvm_component_utils(hamming_env)

	hamming_agent hm_agent;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		hm_agent	= hamming_agent::type_id::create(.name("hm_agent"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction: connect_phase
endclass: hamming_env
