/*------------------------------------------------------------------------------
 * File          : Kmeans_sequencer.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

`define addrWidth 9
`define dataWidth 91
`define wordDepth 512
`define centroid_num 8



//transaction under APB protocol
class APB_transaction extends uvm_sequence_item;
	bit write;
	rand bit [91-1:0] data;//dataWidth
	bit [9-1:0] address;//addrWidth
	//bit sel, enable;

	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(APB_transaction)
		`uvm_field_int(address, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(write, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: APB_transaction





class Kmeans_in_sequence extends uvm_sequence#(APB_transaction);
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
   `uvm_object_utils (Kmeans_in_sequence)
   
   	//body task local variables
   	int num_points = 10; //TODO - must gen this, but maybe not..
   	logic [90:9] points [0:10-1];//TODO change 10 to num_points later   
	int unsigned n_times = 8;//amount of centroids
	APB_transaction apb_tx;
	
	
	//constructor
	function new(string name = "");
		super.new(name);
	endfunction: new
	
	//TODO - find how to allow such function and edit later body task
	/*function send_APB_transaction(int addr,bit write, int to_rand, int data);
		APB_transaction apb_tx	= APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
		apb_tx.address			= addr;//2 is first centroid, until 9 which is last centroid's address
		apb_tx.write			= write;
		start_item(apb_tx);
		if (!to_rand) begin
			apb_tx.data = data;
		end
		else if (!apb_tx.randomize()) begin
			//make sure randomize data field occurred
			`uvm_error("USER_DEFINED_FLAG", "This is a randomize error");
		end
		finish_item(apb_tx);
	endfunction*/

	//perform sequence - push inputs to DUT - fill centroids and data points
	task body();
		`uvm_info ("KMEANS_IN_SEQUENCE", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
		
		//write centroids
		for (int i = 1; i <= n_times; i++) begin
			//when creating apb_tx, data field generated.
			apb_tx	= APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			apb_tx.address			= 2+i-1;//2 is first centroid, until 9 which is last centroid's address
			apb_tx.write			= 1'b1;
			apb_tx.data				= i;
			start_item(apb_tx);
			/*//make sure randomize data field occurred
			if (!apb_tx.randomize()) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error");*/
			finish_item(apb_tx);
		end
		
		//configure first RAM adresses
		apb_tx	= APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
		apb_tx.address			= first_ram_addr_reg;
		apb_tx.write			= 1'b1;
		apb_tx.data				= 91'd1;
		start_item(apb_tx);
		finish_item(apb_tx);
		
		num_points = 10;// TODO - later gen this size
		
		//configure last RAM adresses
		apb_tx	= APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
		apb_tx.address			= last_ram_addr_reg;//2 is first centroid, until 9 which is last centroid's address
		apb_tx.write			= 1'b1;
		//TODO: change data to amount of points generated!
		apb_tx.data				= num_points;
		start_item(apb_tx);
		finish_item(apb_tx);
		
		//write data points to DUT
		points = {91'd11,91'd12,91'd13,91'd14,91'd15,91'd16,91'd17,
				91'd18,{65'd0,13'd7,13'd0},{52'd0,13'd17,13'd0,13'd7} };
		for (int i = 1; i <= num_points; i++) begin
			//1st cycle - ram_addr_reg
			apb_tx	= APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			apb_tx.address			= ram_addr_reg;//2 is first centroid, until 9 which is last centroid's address
			apb_tx.write			= 1'b1;
			apb_tx.data				= i;
			start_item(apb_tx);
			/*//make sure randomize data field occurred
			if (!apb_tx.randomize()) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error");*/
			finish_item(apb_tx);
			
			//2nd cycle - ram_data_reg
			apb_tx	= APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			apb_tx.address			= ram_data_reg;//2 is first centroid, until 9 which is last centroid's address
			apb_tx.write			= 1'b1;
			apb_tx.data				= points[i-1];
			$display("point is<%h>", points[i-1], UVM_LOW);
			start_item(apb_tx);
			/*//make sure randomize data field occurred
			if (!apb_tx.randomize()) `uvm_error("USER_DEFINED_FLAG", "This is a randomize error");*/
			finish_item(apb_tx);
		end
		
		//send a go to DUT
		apb_tx	= APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
		apb_tx.address			= GO_reg;//2 is first centroid, until 9 which is last centroid's address
		apb_tx.write			= 1'b1;
		apb_tx.data				= 91'b1;
		start_item(apb_tx);
		//here we wait - we come back only after DUT raises interrupt
		finish_item(apb_tx);
		$display("sequencer reached after interrupt",UVM_LOW);
		
		
		//read centroids
		for (int i = 0; i <= n_times; i++) begin
			
			//when creating apb_tx, data field generated.
			apb_tx = APB_transaction::type_id::create(.name("apb_tx"), .contxt(get_full_name()));
			apb_tx.address	= 2 + i;//2 is first centroid, until 9 which is last centroid's address
			apb_tx.write	= 1'b0;
			apb_tx.data		= 91'b0;//
			
			start_item(apb_tx);
				$display("sequencer read centroid <%d>" ,i+1 ,UVM_LOW);

			finish_item(apb_tx);
		end
	endtask: body
	
	
endclass: Kmeans_in_sequence

typedef uvm_sequencer#(APB_transaction) Kmeans_sequencer;