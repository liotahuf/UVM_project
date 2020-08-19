/*------------------------------------------------------------------------------
 * File          : Kmeans_pkg.v
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 18, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

/*module Kmeans_pkg #() ();

endmodule*/

package Kmeans_pkg;
	import uvm_pkg::*;
	
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_monitor.v"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_sequencer.v"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_driver.v"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_agent.v"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_env.v"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_test.v"
endpackage: Kmeans_pkg