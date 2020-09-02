class NeuralNet_test extends uvm_test;
		`uvm_component_utils(NeuralNet_test)

		NeuralNet_env ml_env;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction: new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			ml_env = NeuralNet_env::type_id::create(.name("ml_env"), .parent(this));
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			NeuralNet_sequence ml_seq;

			phase.raise_objection(.obj(this));
				ml_seq = NeuralNet_sequence::type_id::create(.name("ml_seq"), .contxt(get_full_name()));
				assert(ml_seq.randomize());
				ml_seq.start(ml_env.ml_agent.ml_seqr);
			phase.drop_objection(.obj(this));
		endtask: run_phase
endclass: NeuralNet_test
