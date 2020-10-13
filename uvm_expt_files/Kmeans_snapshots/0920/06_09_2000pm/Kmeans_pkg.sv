/*------------------------------------------------------------------------------
 * File          : Kmeans_pkg.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

package Kmeans_pkg;
	import uvm_pkg::*;
	
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_sequencer.sv"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_monitor.sv"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_driver.sv"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_agent.sv"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_scoreboard.sv"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_env.sv"
	`include "/users/epedlh/UVM_Project/UVMprjDir/Kmeans_test.sv"
endpackage: Kmeans_pkg