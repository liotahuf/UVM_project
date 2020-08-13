UVM_HOME = /tools/synopsys78/FEV/vcs_mx_vN-2017.12-1/etc/uvm-1.2
UVM_VERBOSITY = UVM_MEDIUM
CFLAGS = full64
	
VCS = vcs -sverilog -full64 -timescale=1ns/1ns \
	+acc +vpi -PP \
	+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
	-cm line+cond+fsm+branch+tgl -cm_dir ./coverage.vdb \
	$(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS -debug -debug_all +define+nobanner
		
SIMV = ./simv +UVM_VERBOSITY=$(UVM_VERBOSITY) \
	+UVM_TR_RECORD +UVM_LOG_RECORD \
	+verbose=1 +ntb_random_seed=244 -l vcs.log
	
x: comp run
	
comp:
	$(VCS) +incdir+. dpram32x32_cb.v cneuron.sv  fcneuron.sv  NeuralNet_cont.sv pooling.sv  NeuralNet_if.sv NeuralNet_Ref.sv NeuralNet_Ref_if.sv NeuralNet_sequencer.sv NeuralNet_driver.sv NeuralNet.sv  NeuralNet_monitor.sv NeuralNet_agent.sv NeuralNet_scoreboard.sv  NeuralNet_env.sv NeuralNet_test.sv 	NeuralNet_test_tb.sv
	
run:
	$(SIMV)
	
clean:
	rm -rf coverage.vdb csrc DVEfiles inter.vpd simv simv.daidir ucli.key vc_hdrs.h vcs.log .inter.vpd.uvm
