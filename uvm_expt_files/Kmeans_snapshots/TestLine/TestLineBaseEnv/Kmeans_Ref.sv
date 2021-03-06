/*------------------------------------------------------------------------------
 * File          : Kmeans_Ref.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

module Kmeans_Ref #( 
  parameter
	addrWidth       = 9,
	dataWidth       = 91,
	reg_amount      =4,
	manhatten_width = 16
) (
	//APB signals - IF with STUB
	input                              clk,
	input                              rst_n,
	input        [addrWidth-1:0]       paddr,
	input                              pwrite,
	input                              psel,
	input                              penable,
	input        [dataWidth-1:0]       pwdata,
	//
	output logic [dataWidth-1:0]       prdata,
	output logic                       pready,
);

//cmd interface regs
reg	go_register;
reg	[addrWidth-1:0]internal_status ;

//read or write reg's

reg [dataWidth-1:0] ram_addr;
reg	[dataWidth-1:0] ram_data;
reg [addrWidth-1:0] first_ram_addr;
reg [addrWidth-1:0] last_ram_addr;
reg [manhatten_width-1:0] threshold;
reg [dataWidth-1:0] data2core_tmp;

//centroids
reg [dataWidth-1:0] centroid_1;
reg [dataWidth-1:0] centroid_2;
reg [dataWidth-1:0] centroid_3;
reg [dataWidth-1:0] centroid_4;
reg [dataWidth-1:0] centroid_5;
reg [dataWidth-1:0] centroid_6;
reg [dataWidth-1:0] centroid_7;
reg [dataWidth-1:0] centroid_8;

//reg [dataWidth-1:0] regFile [256];
enum logic [reg_amount-1:0] { internal_status_reg,
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

enum logic [1:0] {SETUP = 2'b0, W_ENABLE = 2'd1, R_ENABLE = 2'd2} apb_curr_st;
reg [dataWidth-1:0] last_paddr ;
reg w_to_ram_flag;

/*--comb logic--*/
assign first_ram_address_out = first_ram_addr;
assign last_ram_address_out =last_ram_addr;
assign threshold_value =threshold;

/*--Matrix for refModel func input and output--*/
bit signed [12:0] inputMatrix_bit [0:3583];
bit signed [12:0] inputCent_bit [0:55];
bit signed [12:0] finalCent_bit [0:55];



/* ---------------------------------- Interface with APB master ----------------------------------*/
// Interface with APB master- indirect access read or write process state machine
always @(negedge rst_n or posedge clk) begin
	if (rst_n == 0) begin
		apb_curr_st 		<= SETUP;
	end
	else begin
		case (apb_curr_st)
			SETUP : begin
				if (~go_register && psel && ~penable) begin
					// Move to ENABLE when the psel is asserted
					if (pwrite) begin
						apb_curr_st <= W_ENABLE;
					end
					else begin
						apb_curr_st<= R_ENABLE;
						
					end
				end
			end
			W_ENABLE : begin
				if (psel && penable && pwrite) begin
					apb_curr_st <= SETUP;// return to SETUP
				end
			end
			
			R_ENABLE : begin
				if (psel && penable && !pwrite) begin
					apb_curr_st <= SETUP;// return to SETUP
				end
			end
			
		endcase
	end
end

//signals changing due to state machines curr_state
always @(negedge rst_n or posedge clk) begin
	if (rst_n == 0) begin
		go_register	<=0;
		
		ram_addr 		<=0;
		ram_data 		<=0;
		first_ram_addr 	<=0;
		last_ram_addr   <=0;
		threshold <= 0;
		internal_status <=0; //core in idle state
		
	end
	else begin
		//APB
		if (go_register == 1'b0) begin
			case (apb_curr_st)
				
				SETUP : begin
					// clear the prdata
					prdata <= 0;
					pready<=1'b0;
					
				end
				
				
				
				W_ENABLE : begin
					// write pwdata to memorydataWidth
					if (psel && penable && pwrite) begin
						case(paddr)
							//internal_status_reg :
							GO_reg 		 		: go_register	 <= pwdata[0];
							cent_1_reg   		: centroid_1     <= pwdata[dataWidth-1:0];
							cent_2_reg   		: centroid_2     <= pwdata[dataWidth-1:0];
							cent_3_reg   		: centroid_3     <= pwdata[dataWidth-1:0];
							cent_4_reg   		: centroid_4     <= pwdata[dataWidth-1:0];
							cent_5_reg   		: centroid_5     <= pwdata[dataWidth-1:0];
							cent_6_reg   		: centroid_6     <= pwdata[dataWidth-1:0];
							cent_7_reg   		: centroid_7     <= pwdata[dataWidth-1:0];
							cent_8_reg   		: centroid_8     <= pwdata[dataWidth-1:0];
							ram_addr_reg 		: ram_addr 		 <= pwdata[dataWidth-1:0];
							ram_data_reg 		: ram_data 		 <= pwdata[dataWidth-1:0];
							first_ram_addr_reg  : first_ram_addr <= pwdata[addrWidth-1:0];
							last_ram_addr_reg   : last_ram_addr  <= pwdata[addrWidth-1:0];
							threshold_reg       : threshold 	 <= pwdata[manhatten_width-1:0];
							
						endcase
						pready<=1'b1;
						last_paddr <= paddr;
					end
					
				end
				
				R_ENABLE : begin
					// read prdata from memory
					if (psel && penable && !pwrite) begin
						
						pready<=1'b1;
						
						case(paddr)
							internal_status_reg : begin
								prdata[addrWidth-1:0]         <= internal_status;
								prdata[dataWidth-1:addrWidth] <=0;
							end
							GO_reg 		 		: begin
								prdata[0]	 <= go_register;
								prdata[dataWidth-1:1] <=0;
							end
							cent_1_reg   		: prdata     <= centroid_1;
							cent_2_reg   		: prdata     <= centroid_2 ;
							cent_3_reg   		: prdata     <= centroid_3 ;
							cent_4_reg   		: prdata     <= centroid_4;
							cent_5_reg   		: prdata     <= centroid_5 ;
							cent_6_reg   		: prdata     <= centroid_6 ;
							cent_7_reg   		: prdata     <= centroid_7 ;
							cent_8_reg   		: prdata     <= centroid_8 ;
							ram_addr_reg 		: prdata 	 <= ram_addr ;
							ram_data_reg 		: prdata     <= ram_data ;
							first_ram_addr_reg  : begin
								prdata <= 0;
								prdata[addrWidth-1:0]     <=first_ram_addr ;
							end
							
							
							last_ram_addr_reg   : begin
								prdata <= 0;
								prdata[addrWidth-1:0]     <= last_ram_addr ;
							end
							threshold_reg       : begin
								prdata <= 0;
								prdata[manhatten_width-1:0] 	 <= threshold;
							end
						endcase
					end
					
				end
			endcase
		end
		
		// if interrupt signal is high then the host cannot give go
		if (interupt ==1'b1) begin
			go_register	<=1'b0;
			internal_status <=2'b 10;//core done,interrupt is togled
		end
		
		if (go_register==1'b1) begin
			internal_status <=2'b 01;//core busy,algorithm running
		end		

		//Interface with core- read and write to registers in RegFile
		if((go_register==1'b1) && (reg_write==1'b1) ) begin
			//write to register number "reg_num" of RegFile
			case(reg_num)
				
				cent_1_reg   		  : centroid_1     <= reg_write_data[dataWidth-1:0];
				cent_2_reg   		  : centroid_2     <= reg_write_data[dataWidth-1:0];
				cent_3_reg   		  : centroid_3     <= reg_write_data[dataWidth-1:0];
				cent_4_reg   		  : centroid_4     <= reg_write_data[dataWidth-1:0];
				cent_5_reg   		  : centroid_5     <= reg_write_data[dataWidth-1:0];
				cent_6_reg   		  : centroid_6     <= reg_write_data[dataWidth-1:0];
				cent_7_reg   		  : centroid_7     <= reg_write_data[dataWidth-1:0];
				cent_8_reg   	    : centroid_8     <= reg_write_data[dataWidth-1:0];				
			endcase
		end
	end
end



endmodule