/*------------------------------------------------------------------------------
 * File          : Kmeans_test.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

class Kmeans_test extends uvm_test;
	`uvm_component_utils(Kmeans_test)

	Kmeans_env kmeans_env;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		kmeans_env = Kmeans_env::type_id::create(.name("kmeans_env"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		Kmeans_in_sequence kmeans_seq;

		phase.raise_objection(.obj(this));
		kmeans_seq = Kmeans_in_sequence::type_id::create(.name("kmeans_seq"), .contxt(get_full_name()));
			
		//TODO: do something here:
		assert(kmeans_seq.randomize());
		kmeans_seq.start(kmeans_env.kmeans_agent.kmeans_seqr);
		
		phase.drop_objection(.obj(this));
	endtask: run_phase
endclass: Kmeans_test
