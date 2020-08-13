class NeuralNet_monitor_dut extends uvm_monitor;
	`uvm_component_utils(NeuralNet_monitor_dut)
	
	uvm_analysis_port#(NeuralNet_transaction) mon_ap_dut;
	
	virtual NeuralNet_if vif;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		void'(uvm_resource_db#(virtual NeuralNet_if)::read_by_name (.scope("ifs"), .name("NeuralNet_if"), .val(vif)));
		mon_ap_dut = new(.name("mon_ap_dut"), .parent(this));
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		
		NeuralNet_transaction ml_pkt;
		ml_pkt = NeuralNet_transaction::type_id::create (.name("ml_pkt"), .contxt(get_full_name()));
		
		forever begin
			@(posedge vif.clk)
			begin
				ml_pkt.result = vif.result;
				//Send the transaction to the analysis port
				mon_ap_dut.write(ml_pkt);
				//`uvm_info("ml_sequence", ml_pkt.sprint(), UVM_LOW)
			end
		end
	endtask: run_phase
endclass: NeuralNet_monitor_dut

class NeuralNet_monitor_ref extends uvm_monitor;
	`uvm_component_utils(NeuralNet_monitor_ref)
	
	uvm_analysis_port#(NeuralNet_transaction) mon_ap_ref;
	
	virtual NeuralNet_Ref_if vrefif;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		void'(uvm_resource_db#(virtual NeuralNet_Ref_if)::read_by_name (.scope("ifs"), .name("NeuralNet_Ref_if"), .val(vrefif)));
		mon_ap_ref = new(.name("mon_ap_ref"), .parent(this));
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		
		NeuralNet_transaction ml_pkt;
		ml_pkt = NeuralNet_transaction::type_id::create (.name("ml_pkt"), .contxt(get_full_name()));
		
		forever begin
			@(posedge vrefif.clk)
			begin
				ml_pkt.result = vrefif.result;
				//Send the transaction to the analysis port
				mon_ap_ref.write(ml_pkt);
				//`uvm_info("ml_sequence", ml_pkt.sprint(), UVM_LOW)
			end
		end
	endtask: run_phase
endclass: NeuralNet_monitor_ref

