UVM_HOME = /tools/synopsys78/FEV/vcs_mx_vN-2017.12-1/etc/uvm-1.2
UVM_VERBOSITY = UVM_MEDIUM
TEST = Kmeans_test
CFLAGS = full64
	
VCS = vcs -sverilog -full64 -timescale=1ns/1ns \
	+acc +vpi -PP \
	+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
	+incdir+/users/epedlh/UVM_Project/Matlab/codegen/dll/refModel2 \
	-cm line+cond+fsm+branch+tgl -cm_dir ./coverage.vdb \
	$(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS -debug -debug_all
		
SIMV = ./simv +UVM_VERBOSITY=$(UVM_VERBOSITY) \
	+UVM_TESTNAME=$(TEST) +UVM_TR_RECORD +UVM_LOG_RECORD \
	+verbose=1 +ntb_random_seed=244 -l vcs.log
	
x: comp run
	
comp:
	$(VCS) +incdir+. Kmeans_test_tb.sv -debug
	
run:
	$(SIMV) -sv_lib /users/epedlh/UVM_Project/Matlab/codegen/dll/refModel2/librefModel2_dpi
	
clean:
	rm -rf coverage.vdb csrc DVEfiles inter.vpd simv simv.daidir ucli.key vc_hdrs.h vcs.log .inter.vpd.uvm
