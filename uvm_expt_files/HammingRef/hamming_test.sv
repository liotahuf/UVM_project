class hamming_test extends uvm_test;
		`uvm_component_utils(hamming_test)

		hamming_env hm_env;

		function new(string name, uvm_component parent);
			super.new(name, parent);
            //`uvm_info("", "New of hamming_test", UVM_MEDIUM);
		endfunction: new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			hm_env = hamming_env::type_id::create(.name("hm_env"), .parent(this));
            //`uvm_info("", "Build Phase of hamming_test", UVM_MEDIUM);
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			hamming_sequence hm_seq;

			phase.raise_objection(.obj(this));
				hm_seq = hamming_sequence::type_id::create(.name("hm_seq"), .contxt(get_full_name()));
				assert(hm_seq.randomize());
				hm_seq.start(hm_env.hm_agent.hm_seqr);
			phase.drop_objection(.obj(this));
            //`uvm_info("", "Run Phase of hamming_test", UVM_MEDIUM);
		endtask: run_phase
endclass: hamming_test
