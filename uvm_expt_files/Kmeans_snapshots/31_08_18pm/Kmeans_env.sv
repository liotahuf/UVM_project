/*------------------------------------------------------------------------------
 * File          : Kmeans_env.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

class Kmeans_env extends uvm_env;
	`uvm_component_utils(Kmeans_env)

	Kmeans_agent 		kmeans_agent;
	Kmeans_scoreboard 	kmeans_sb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		kmeans_agent	= Kmeans_agent::type_id::create(.name("kmeans_agent"), .parent(this));
		kmeans_sb       = Kmeans_scoreboard::type_id::create(.name("kmeans_sb"), .parent(this));
	endfunction: build_phase
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		kmeans_agent.agent_ap_dut.connect(kmeans_sb.sb_export_dut);
		//kmeans_agent.agent_ap_ref.connect(kmeans_sb.sb_export_ref);
		`uvm_info("", "Connect Phase of kmeans_env", UVM_MEDIUM);
	endfunction: connect_phase

endclass: Kmeans_env
