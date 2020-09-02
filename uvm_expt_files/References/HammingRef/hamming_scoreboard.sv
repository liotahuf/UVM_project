class hamming_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(hamming_scoreboard)

         uvm_analysis_export #(hamming_transaction) sb_export_dut;
         uvm_analysis_export #(hamming_transaction) sb_export_ref;

	uvm_tlm_analysis_fifo #(hamming_transaction) dut_fifo;
	uvm_tlm_analysis_fifo #(hamming_transaction) ref_fifo;

	hamming_transaction transaction_dut;
	hamming_transaction transaction_ref;

	function new(string name, uvm_component parent);
		super.new(name, parent);

		transaction_dut	= new("transaction_dut");
		transaction_ref	= new("transaction_ref");
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		sb_export_dut	= new("sb_export_dut", this);
		sb_export_ref	= new("sb_export_ref", this);

   		dut_fifo		= new("dut_fifo", this);
		ref_fifo		= new("ref_fifo", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		sb_export_dut.connect(dut_fifo.analysis_export);
		sb_export_ref.connect(ref_fifo.analysis_export);
	endfunction: connect_phase

	task run();
		forever begin
			dut_fifo.get(transaction_dut);
			ref_fifo.get(transaction_ref);
			compare();
		end
	endtask: run

	virtual function void compare();
		if(transaction_dut.z == transaction_ref.z) begin
			`uvm_info("compare", {"Test: OK!"}, UVM_LOW);
		end else begin
			`uvm_info("compare", {"Test: Fail!"}, UVM_LOW);
		end
	endfunction: compare
endclass: hamming_scoreboard
