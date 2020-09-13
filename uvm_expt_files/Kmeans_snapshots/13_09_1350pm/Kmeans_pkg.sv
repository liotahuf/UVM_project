/*------------------------------------------------------------------------------
 * File          : Kmeans_pkg.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

package Kmeans_pkg;
	import uvm_pkg::*;
	
	`include "Kmeans_sequencer.sv"
	`include "Kmeans_monitor.sv"
	`include "Kmeans_driver.sv"
	`include "Kmeans_agent.sv"
	`include "Kmeans_scoreboard.sv"
	`include "Kmeans_env.sv"
	`include "Kmeans_test.sv"
endpackage: Kmeans_pkg