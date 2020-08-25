/*------------------------------------------------------------------------------
 * File          : Kmeans_driver.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

class Kmeans_driver extends uvm_driver#(APB_transaction);
	`uvm_component_utils(Kmeans_driver)
	enum logic [8-1:0] {//8 is reg_amount
		internal_status_reg,
		GO_reg,
		cent_1_reg,
		cent_2_reg,
		cent_3_reg,
		cent_4_reg,
		cent_5_reg,
		cent_6_reg,
		cent_7_reg,
		cent_8_reg,
		ram_addr_reg,
		ram_data_reg,
		first_ram_addr_reg,
		last_ram_addr_reg,
		threshold_reg
	} register_num;

	virtual Kmeans_if vif;
	//virtual Kmeans_Ref_if vrefif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual Kmeans_if)::read_by_name (.scope("ifs"), .name("Kmeans_if"), .val(vif)));
		//void'(uvm_resource_db#(virtual Kmeans_Ref_if)::read_by_name (.scope("ifs"), .name("Kmeans_Ref_if"), .val(vrefif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		drive();
	endtask: run_phase

	virtual task drive();
		//apb transactions:
		APB_transaction in_pkt;
		`uvm_info("", "Drive Function of Driver", UVM_MEDIUM)
		vif.penable = 1'b0;
		vif.psel = 1'b0;
		//forever begin
		//for(int i=0 ; i < 8+1+1+2*10+1 ; i++) begin
		repeat(8+1+1+2*10+1+8) begin// with go register
			//`uvm_info("", "Forever of Driver", UVM_LOW)
			
			//wait until we get apb_tx into in_pkt
			seq_item_port.get_next_item(in_pkt);
			`uvm_info("got new packet to drive", in_pkt.sprint(), UVM_LOW)
			//1st cycle of transer
			@(posedge vif.clk)
			begin
				//vif.penable = 1'b0; - not needed for now but might add back
				vif.psel 	= 1'b1;
				vif.pwrite 	= in_pkt.write;
				vif.paddr 	= in_pkt.address;
				vif.pwdata 	= (in_pkt.write ? in_pkt.data : 91'b0);
			end
			//2nd cycle of transfer
			@(posedge vif.clk)
			begin
				vif.penable = 1'b1;
				if (vif.paddr == GO_reg) begin
					`uvm_info("got a GO packet to drive", in_pkt.sprint(), UVM_LOW)
					@(posedge vif.interupt) begin
						
					end
					`uvm_info("got a INTERUP at driver", in_pkt.sprint(), UVM_LOW)

				end
				seq_item_port.item_done();
			end
			//TODO - might find way to get rid of this: whys its here?
			//becuase we dont want to get stuck with penable and psel on until next pkt arrives
			@(posedge vif.clk)
			begin
				vif.penable = 1'b0;
				vif.psel 	= 1'b0;
				vif.paddr	= 9'b0;
				vif.pwdata	= 91'b0;
			end
		end
	endtask: drive
endclass:Kmeans_driver
