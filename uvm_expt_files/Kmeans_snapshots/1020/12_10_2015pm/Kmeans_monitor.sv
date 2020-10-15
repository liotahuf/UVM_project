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
	APB_transaction out_pkt;
	
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
		
		out_pkt = APB_transaction::type_id::create (.name("out_pkt"), .contxt(get_full_name()));
		
		forever begin
			@(negedge vif.clk)
			begin
				out_pkt.write = vif.pwrite;
				out_pkt.data	 = (vif.pwrite ? vif.pwdata : vif.prdata);
				out_pkt.address = vif.paddr;
				/*
				$display("MONITOR, vif print pwrite <%h>", vif.pwrite, UVM_LOW);
				$display("MONITOR, vif print pwdata <%h>", vif.pwdata, UVM_LOW);
				*/
				//`uvm_info("got new packet at monitor:", out_pkt.sprint(), UVM_LOW)
				//TODO - fill pkt with output data from DUT
				//Send the transaction to the analysis port
				
				if (vif.interupt && vif.pready && vif.psel && ~vif.pwrite) begin
					//start_item(mon_ap_dut.write(out_pkt)); - no idea might rmv
					mon_ap_dut.write(out_pkt);
					$display("MONITOR, vif print paddr  <%h>", vif.paddr, UVM_LOW);
					$display("MONITOR, vif print prdata <%h>", vif.prdata, UVM_LOW);
				end
				
				
				
			end
		end
	endtask: run_phase
endclass: Kmeans_monitor_dut


//TODO reference monitor - depend on matalab behavior , will implement succesfully after making sure dut monitor done
class Kmeans_monitor_ref extends uvm_monitor;
	`uvm_component_utils(Kmeans_monitor_ref)
	
	uvm_analysis_port#(centroid_transaction) mon_ap_ref;
	centroid_transaction cent_tx;
	int num_centroids = 8;
	logic [91] single_point;
	int i,j;
	
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
		
		cent_tx = centroid_transaction::type_id::create (.name("cent_tx"), .contxt(get_full_name()));

		forever begin
			@(posedge vrefif.go)
			@(negedge vrefif.go)
			begin
				//fill pkt with output data from REF
				for(i=0 ; i < num_centroids ; i++) begin
					for(j=0 ; j<7 ; j++) begin
						single_point[13*j +:13] = vrefif.out_centroids[7*i+j];
					end
					$display("aaaa montior: single_point[%d] = %h",i+1,single_point,UVM_LOW);
					cent_tx.centroids[i] = single_point;
					//$display("monitor, ref output: centroid[%d] = %h",i+1,cent_tx.centroids[i],UVM_LOW);
				end
				//cent_tx.print();
				//Send the transaction to the analysis port
				mon_ap_ref.write(cent_tx);
			end
		end
	endtask: run_phase
endclass: Kmeans_monitor_ref

