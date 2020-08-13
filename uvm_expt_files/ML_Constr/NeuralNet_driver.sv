class NeuralNet_driver extends uvm_driver#(NeuralNet_transaction);
	`uvm_component_utils(NeuralNet_driver)

	virtual NeuralNet_if vif;
	virtual NeuralNet_Ref_if vrefif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual NeuralNet_if)::read_by_name (.scope("ifs"), .name("NeuralNet_if"), .val(vif)));
		void'(uvm_resource_db#(virtual NeuralNet_Ref_if)::read_by_name (.scope("ifs"), .name("NeuralNet_Ref_if"), .val(vrefif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		drive();
	endtask: run_phase

	virtual task drive();
		NeuralNet_transaction ml_pkt;
		integer state = 0;
		//vif.rst = 1'b1; driven from tb
		//vrefif.rst = 1'b1;
		vif.learn = 1'b0;
		vif.classify = 1'b0;
		`uvm_info("", "Drive Function of Driver", UVM_MEDIUM)
		forever begin
			`uvm_info("", "Forever of Driver", UVM_LOW)
			$display ("Pstate1=%d", state);
			
			//seq_item_port.get_next_item(ml_pkt);
			//`uvm_info("NeuralNet_driver", ml_pkt.sprint(), UVM_LOW)
			

			@(negedge vif.clk)
			begin
				$display ("Pstate2=%d", state);
				
				case(state)
					0: begin   //reset
						//vif.rst = 1'b1;
						//vrefif.rst = 1'b1;
					    state = 1;
					end
					1: begin   //learn 2 cycles - first
						 vif.learn = 1'b1;
						 vif.classify = 1'b0;
						 state = 2;
						end
					2: begin   //learn 2 cycles - second
						  vif.learn = 1'b1;
						  vif.classify = 1'b0;
						  state = 3;
					   end
					3: begin   //start classify
						vif.learn = 1'b0;
						vif.classify = 1'b1;
						state = 4;
				      end
					4: begin   //classify 1
						 seq_item_port.get_next_item(ml_pkt);
						 state = 5;
						 vif.pixels = {ml_pkt.InputImage[71:64],ml_pkt.InputImage[63:56],ml_pkt.InputImage[47:40],ml_pkt.InputImage[39:32]};
						 vrefif.InputImage = ml_pkt.InputImage[71:0];
					   end
					5: begin //classify 2
						 state = 6;
						 vif.pixels = {ml_pkt.InputImage[63:56],ml_pkt.InputImage[55:48],ml_pkt.InputImage[39:32],ml_pkt.InputImage[31:24]};
					   end
					6: begin //classify 3
						 state = 7;
						 vif.pixels = {ml_pkt.InputImage[47:40],ml_pkt.InputImage[39:32],ml_pkt.InputImage[23:16],ml_pkt.InputImage[15:8]};
					   end
					7: begin //classify 4
						 vif.pixels = {ml_pkt.InputImage[39:32],ml_pkt.InputImage[31:24],ml_pkt.InputImage[15:8],ml_pkt.InputImage[7:0]};
						 state = 4;
						 seq_item_port.item_done();
					   end
				
				endcase
			end
		end
	endtask: drive
endclass:NeuralNet_driver
