//`uvm_analysis_imp_decl(_dut)
//`uvm_analysis_imp_decl(_ref)

class NeuralNet_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(NeuralNet_scoreboard)

        uvm_analysis_export #(NeuralNet_transaction) sb_export_dut;

	uvm_tlm_analysis_fifo #(NeuralNet_transaction) dut_fifo;

	NeuralNet_transaction transaction_dut;
	NeuralNet_transaction transaction_ref;

	function new(string name, uvm_component parent);
		super.new(name, parent);

		transaction_dut	= new("transaction_dut");
		transaction_ref	= new("transaction_ref");
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		sb_export_dut	= new("sb_export_dut", this);

   		dut_fifo		= new("dut_fifo", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		sb_export_dut.connect(dut_fifo.analysis_export);
	endfunction: connect_phase

	task run();
		forever begin
                   //`uvm_info("", "run method of NeuralNet_scoreboard", UVM_MEDIUM);
		   dut_fifo.get(transaction_dut);
	           compare();
		end
	endtask: run

	virtual function void compare();
		if(transaction_dut.result == transaction_ref.result) begin
			`uvm_info("compare", {"Test: OK!"}, UVM_LOW)
		end else begin
			`uvm_info("compare", {"Test: Fail!"}, UVM_LOW)
		end
	endfunction: compare
endclass: NeuralNet_scoreboard
