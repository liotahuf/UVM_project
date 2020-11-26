/*------------------------------------------------------------------------------
 * File          : Kmeans_driver.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

class last_point extends uvm_sequence_item;
	rand logic [90:0] data;
	
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	`uvm_object_utils_begin(last_point)
		`uvm_field_int(data, UVM_ALL_ON)
	`uvm_object_utils_end
endclass

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
	
	logic [90:0] points [0:9] = {91'd11,91'd12,91'd13,91'd14,91'd15,91'd16,91'd17,
			91'd18,{52'd0,13'd0,13'd7,13'd0},91'd0 };
	last_point last;
	
	Kmeans_transaction kmeans_tx;
	int i,j;
	logic [91] single_point;
	
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
	
	task reset_DUT();
		@(posedge vif.clk) begin
			vif.rst_n		= 1'b0 ;
		end
		
		@(posedge vif.clk) begin
			vif.rst_n  = 1'b1 ;
		end
	endtask : reset_DUT
	
	task reset_REFMODEL();
		@(posedge vif.clk) begin
			vrefif.rst	= 1'b1 ;
		end
		
		@(posedge vif.clk) begin
			vrefif.rst  = 1'b0 ;
		end
	endtask : reset_REFMODEL
	
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
	
	
	task send_APB_transaction(int addr,bit write, logic [90:0] data);
		//assigning values for transaction
		APB_transaction apb_tx	= APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
		
		apb_tx.address	= addr;//2 is first centroid, until 9 which is last centroid's address
		apb_tx.write	= write;
		apb_tx.data		= data;
		
		//$display("DRIVER, send_APB_transaction, DUT: data = %h",apb_tx.data,UVM_LOW);
		
		
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
		
		reset_DUT();
		
		//write centroids
		for (int i = 0; i < num_centroids; i++) begin
			send_APB_transaction(2+i, 1'b1, kmeans_tx.centroids[i]);
		end
		$display("WRITE CENTROIDS DONE" ,UVM_LOW);
		
		//configure RAM adresses - first & last
		send_APB_transaction(first_ram_addr_reg, 1'b1, kmeans_tx.first_point_index);
		send_APB_transaction(last_ram_addr_reg, 1'b1, kmeans_tx.first_point_index + kmeans_tx.num_points - 1);
		send_APB_transaction(threshold_reg, 1'b1, kmeans_tx.threshold);
		$display("DUT first idx %d",kmeans_tx.first_point_index,UVM_LOW);
		$display("DUT last point %d",kmeans_tx.first_point_index + kmeans_tx.num_points - 1,UVM_LOW);
		$display("DUT numpoints %d",kmeans_tx.num_points,UVM_LOW);
		$display("DUT threshold %d",kmeans_tx.threshold,UVM_LOW);
		$display("WRITE_RAM_BOUNDARIES_DONE",UVM_LOW);
		
		//write data points to DUT
		for (int i = kmeans_tx.first_point_index; i <= kmeans_tx.last_point_index; i++) begin
			//1st cycle - ram_addr_reg
			send_APB_transaction(ram_addr_reg, 1'b1, i);//no rand here always
			//2nd cycle - ram_data_reg
			send_APB_transaction(ram_data_reg, 1'b1, kmeans_tx.data_points[i-1]);
		end
		$display("WRITE_DATA_POINTS_DONE" ,UVM_LOW);
		
		//send a go to DUT, will continue after DUT raises interrupt
		send_APB_transaction(GO_reg, 1'b1, 91'b1);
		$display("GO_AND_INTERUPT_DONE",UVM_LOW);
		
		
		//read centroids - addresses 2 to 9 - first to last centroid's adresses
		for (int i = 0; i < num_centroids; i++) begin
			send_APB_transaction(2 + i, 1'b0, 91'b0);
		end
		$display("READ_CENTROIDS_DONE",UVM_LOW);
		
	endtask : k_means_calculation
	
	
	task k_means_ref_calculation(Kmeans_transaction kmeans_tx);
		reset_REFMODEL();
		
		//WRITE RAM BOUNDARIES, threshold
		vrefif.first_point_index =  kmeans_tx.first_point_index;//13'b1;
		vrefif.last_point_index = kmeans_tx.last_point_index;
		vrefif.threshold = kmeans_tx.threshold;
		$display("Ref Model first point %d",vrefif.first_point_index,UVM_LOW);
		$display("Ref Model last point %d",vrefif.last_point_index,UVM_LOW);
		$display("Ref Model numpoints %d",kmeans_tx.num_points,UVM_LOW);
		$display("Ref Model threshold %d",kmeans_tx.threshold,UVM_LOW);
		
		//WRITE DATA POINTS TO REFMODEL
		for(i= kmeans_tx.first_point_index - 13'b1 ; i <= kmeans_tx.last_point_index - 13'b1 ; i++) begin
			single_point = kmeans_tx.data_points[i];
			for(j=0;j<7;j++) begin
				vrefif.matrix[7*i+j] = single_point[13*j +:13];
			end
		end
		
		//WRITE IN_CENTROIDS TO REFMODEL
		//vrefif.in_centroids = {>>{kmeans_tx.centroids}};
		for(i=0 ; i < num_centroids ; i++) begin
			single_point = kmeans_tx.centroids[i];
			for(j=0 ; j<7 ; j++) begin
				vrefif.in_centroids[7*i+j] = single_point[13*j +:13];
			end
		end
		
		
		//SEND A GO TO REFMODEL2
		@(posedge vrefif.clk) begin
			vrefif.go = 1'b1;
			
		end
		@(posedge vrefif.clk) begin
			vrefif.go = 1'b0;
			
		end
		
	endtask
	
	
	virtual task drive();
		`uvm_info("", "Drive Function of Driver", UVM_MEDIUM)
		vif.penable = 1'b0;
		vif.psel = 1'b0;
		
		forever begin
			`uvm_info("", "Forever of Driver", UVM_LOW)
			
			seq_item_port.get_next_item(kmeans_tx);
			
			k_means_calculation(kmeans_tx);
			k_means_ref_calculation(kmeans_tx);
			
			seq_item_port.item_done();
			
		end
		
	endtask: drive
endclass:Kmeans_driver
