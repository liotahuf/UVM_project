/*------------------------------------------------------------------------------
 * File          : Kmeans_driver.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

class Kmeans_driver extends uvm_driver#(Kmeans_transaction);
	`uvm_component_utils(Kmeans_driver)
	
	//local variables
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
	
	const int num_centroids = 8;
	const int dataWidth = 91;//TODO - rmv this
	logic [90:9] points [0:10-1] = {91'd11,91'd12,91'd13,91'd14,91'd15,91'd16,91'd17,
			91'd18,{65'd0,13'd7,13'd0},{52'd0,13'd17,13'd0,13'd7} };
	Kmeans_transaction kmeans_tx;
	
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
	
	
	task read_apb_tx(APB_transaction apb_tx);
		//1st cycle of transer
		@(posedge vif.clk)
		begin
			vif.penable = 1'b0;
			vif.psel 	= 1'b1;
			vif.pwrite 	= apb_tx.write;
			vif.paddr 	= apb_tx.address;
			vif.pwdata 	= 91'b0;
		end
		//2nd cycle of transfer
		@(posedge vif.clk) begin
			vif.penable = 1'b1;
		end
	endtask : read_apb_tx
	
	
	task write_apb_tx(APB_transaction apb_tx);
		//1st cycle of transer
		@(posedge vif.clk)
		begin
			vif.penable = 1'b0;
			vif.psel 	= 1'b1;
			vif.pwrite 	= apb_tx.write;
			vif.paddr 	= apb_tx.address;
			vif.pwdata 	= apb_tx.data;
		end
		//2nd cycle of transfer
		@(posedge vif.clk) begin
			vif.penable = 1'b1;
			if (vif.paddr == GO_reg) begin
				`uvm_info("got a GO packet to drive", apb_tx.sprint(), UVM_LOW)
				@(posedge vif.interupt) //TODO - might add behavior
						`uvm_info("got a INTERUP at driver", apb_tx.sprint(), UVM_LOW)
			end
		end
	endtask : write_apb_tx
	
	
	task send_APB_transaction(int addr,bit write, int data);
		//assigning values for transaction
		APB_transaction apb_tx	= APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
		
		apb_tx.address	= addr;//2 is first centroid, until 9 which is last centroid's address
		apb_tx.write	= write;
		apb_tx.data		= data;
		
		//apply transaction - write or read
		if (apb_tx.write) begin
			write_apb_tx(apb_tx);
		end
		else begin
			read_apb_tx(apb_tx);
		end
		
		//TODO - might rmv the following:
		//reset apb signals after transaction - after either write or read tx
		@(posedge vif.clk) begin
			vif.penable = 1'b0;
			vif.psel 	= 1'b0;
			vif.paddr	= 9'b0;
			vif.pwdata	= 91'b0;
		end
		
	endtask : send_APB_transaction
	
	task k_means_calculation(Kmeans_transaction kmeans_tx);
		//write centroids
		for (int i = 1; i <= num_centroids; i++) begin
			$display("CENTROID %d is h'%h DONE",i,kmeans_tx.centroids[i] ,UVM_LOW);
			send_APB_transaction(2+i-1, 1'b1, kmeans_tx.centroids[i]);
		end
		$display("WRITE CENTROIDS DONE" ,UVM_LOW);
		
		//configure RAM adresses - first & last
		send_APB_transaction(first_ram_addr_reg, 1'b1, 91'd1);//no rand here always
		send_APB_transaction(last_ram_addr_reg, 1'b1, kmeans_tx.num_points);
		$display("WRITE_RAM_BOUNDARIES_DONE, num points is <%d>",kmeans_tx.num_points ,UVM_LOW);
		
		
		//write data points to DUT
		for (int i = 1; i <= kmeans_tx.num_points; i++) begin
			//1st cycle - ram_addr_reg
			send_APB_transaction(ram_addr_reg, 1'b1, i);//no rand here always
			//2nd cycle - ram_data_reg
			send_APB_transaction(ram_data_reg, 1'b1, kmeans_tx.data_points[i]);
		end
		$display("WRITE_DATA_POINTS_DONE" ,UVM_LOW);
		
		
		//send a go to DUT, will continue after DUT raises interrupt
		send_APB_transaction(GO_reg, 1'b1, 91'b1);
		$display("GO_AND_INTERUPT_DONE",UVM_LOW);
		
		
		//read centroids - adresses 2 to 9 - first to last centroid's adresses
		//TODO - rmv 1 extra read req because monitor print problem
		for (int i = 0; i <= num_centroids; i++) begin
			$display("sequencer read centroid <%d>" ,i+1 ,UVM_LOW);
			send_APB_transaction(2 + i, 1'b0, 91'b0);
		end
		$display("READ_CENTROIDS_DONE",UVM_LOW);
		
	endtask : k_means_calculation
	
	virtual task drive();
		`uvm_info("", "Drive Function of Driver", UVM_MEDIUM)
		vif.penable = 1'b0;
		vif.psel = 1'b0;
		forever begin
			//`uvm_info("", "Forever of Driver", UVM_LOW)
			
			//wait until we get request for kmeans calculation
			seq_item_port.get_next_item(kmeans_tx);
			`uvm_info("got new kmeans transaction", kmeans_tx.sprint(), UVM_LOW)
			
			k_means_calculation(kmeans_tx);
			
			seq_item_port.item_done();
			
		end
		
	endtask: drive
endclass:Kmeans_driver
