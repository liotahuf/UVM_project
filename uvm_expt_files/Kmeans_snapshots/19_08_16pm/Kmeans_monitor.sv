/*------------------------------------------------------------------------------
 * File          : Kmeans_monitor.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/
 class Kmeans_monitor_dut extends uvm_monitor;
	`uvm_component_utils(Kmeans_monitor_dut)
	
	uvm_analysis_port#(APB_transaction) mon_ap_dut;
	//we somehow get the transaction virtually from this variable below?
	virtual Kmeans_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		void'(uvm_resource_db#(virtual Kmeans_if)::read_by_name (.scope("ifs"), .name("Kmeans_if"), .val(vif)));
		mon_ap_dut = new(.name("mon_ap_dut"), .parent(this));
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		
		APB_transaction out_pkt;
		out_pkt = APB_transaction::type_id::create (.name("out_pkt"), .contxt(get_full_name()));
		
		forever begin
			@(posedge vif.clk)
			begin
				out_pkt.centroid = vif.prdata;
				//TODO - fill pkt with output data from DUT
				//probably need special transactions after interrupt
			   //Send the transaction to the analysis port
				//TODO - some other place need to make sure this will be a valid centroid value
				if (vif.interupt && vif.pready && vif.psel && ~vif.pwrite) begin
					start_item(mon_ap_dut.write(out_pkt));
					mon_ap_dut.write(out_pkt);
				end
				//TODO - might print here or in scoreboard when have all 8 centroids?
				//$display ("Result_dut=%d", out_pkt.centroid);
			end
		end
	endtask: run_phase
endclass: Kmeans_monitor_dut
 
 
//TODO reference monitor - depend on matalab behavior , will implement succesfully after making sure dut monitor done
class Kmeans_monitor_ref extends uvm_monitor;
	`uvm_component_utils(Kmeans_monitor_ref)
	
	uvm_analysis_port#(APB_transaction) mon_ap_ref;
	
	virtual Kmeans_Ref_if vrefif;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		void'(uvm_resource_db#(virtual Kmeans_Ref_if)::read_by_name (.scope("ifs"), .name("Kmeans_Ref_if"), .val(vrefif)));
		mon_ap_ref = new(.name("mon_ap_ref"), .parent(this));
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		
		APB_transaction out_ref_pkt;
		out_ref_pkt = APB_transaction::type_id::create (.name("out_ref_pkt"), .contxt(get_full_name()));
		
		forever begin
			@(posedge vrefif.clk)
			begin
			//TODO - fill pkt with output data from REF
			   //Send the transaction to the analysis port
			end
		end
	endtask: run_phase
endclass: Kmeans_monitor_ref

