/*------------------------------------------------------------------------------
 * File          : Kmeans_driver.v
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 18, 2020
 * Description   :
 *------------------------------------------------------------------------------*/
/*
module Kmeans_driver #() ();

endmodule*/

class Kmeans_driver extends uvm_driver#(Kmeans_transaction);
	`uvm_component_utils(Kmeans_driver)

	virtual Kmeans_if vif;
	virtual Kmeans_Ref_if vrefif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual Kmeans_if)::read_by_name (.scope("ifs"), .name("Kmeans_if"), .val(vif)));
		void'(uvm_resource_db#(virtual Kmeans_Ref_if)::read_by_name (.scope("ifs"), .name("Kmeans_Ref_if"), .val(vrefif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		drive();
	endtask: run_phase

	virtual task drive();
		//apb transactions:
		`uvm_info("", "Drive Function of Driver", UVM_MEDIUM)
		vif.penable = 1'b0;
		vif.psel = 1'b0;
		forever begin
			`uvm_info("", "Forever of Driver", UVM_LOW)
			APB_transaction in_pkt = APB_transaction::type_id::create(.name("in_pkt"), .contxt(get_full_name()));
			//wait until we get apb_tx into in_pkt
			seq_item_port.get_next_item(in_pkt);
			`uvm_info("got new packet to drive", in_pkt.sprint(), UVM_LOW)
			//1st cycle of transer
			@(posedge vif.clk)
			begin
				//vif.penable = 1'b0; - not needed for now but might add back
				vif.psel 	= 1'b1;
				vif.pwrite 	= in_pkt.write;
				vif.paddr 	= paddr;
				vif.pwdata 	= (vif.pwrite ? in_pkt.data : 91'b0);
			end
			//2nd cycle of transfer
			@(posedge vif.clk)
			begin
				vif.penable = 1'b1;
				vif.psel 	= 1'b1;
				vif.pwrite 	= in_pkt.write;
				vif.paddr 	= paddr;
				vif.pwdata 	= (vif.pwrite ? in_pkt.data : 91'b0);			
			end
			//TODO - might find way to get rid of this: whys its here?
			//becuase we dont want to get stuck with penable and psel on until next pkt arrives
			@(posedge vif.clk)
			begin
				vif.penable = 1'b0;
				vif.psel 	= 1'b0;
			end
		end
		
	endtask: drive
endclass:Kmeans_driver
