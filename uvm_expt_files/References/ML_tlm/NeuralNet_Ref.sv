/*------------------------------------------------------------------------------
 * File          : NeuralNet_Ref.sv
 * Project       : Ver_MLExpt
 * Author        : goel
 * Creation date : Feb 14, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module NeuralNet_Ref (
	input               clk,
	                    rst,
	input        [71:0] InputImage,
	output logic [7:0]  result
);
logic [3:0] state;
logic [71:0] InputImage_Cur;

always_ff @(posedge clk or posedge rst)
begin
	if (rst == 1) begin
		state <= 4'h1;
	end
	else
	
	begin
		result <= 8'h00;
		
		case(state)
			
			
			4'h1:    //learn 1
			begin
				state <= state + 1;
			end
			
			4'h2:    //learn 2
			begin
				state <= state + 1;
			end
			
			4'h3:     //classify 1
			begin
				state <= state + 1;
			end
			
			4'h4:    // convolution 1
			begin
				InputImage_Cur <= InputImage;
				state <= state + 1;
			end
			
			4'h5:    // convolution 2
			begin
				state <= state + 1;
			end
			
			4'h6:    // convolution 3
			begin
				state <= state + 1;
			end
			
			4'h7:     // convolution 4
			begin
				state <= state + 1;
			end
			
			4'h8:
			begin
				state <= state + 1;
				case(InputImage_Cur)
					72'h01ff01ff01ff01ff01:result <= 8'h08;
					72'hff01ff01ff01ff01ff:result <= 8'hf8;
					72'h01ffffff01ffffff01:result <= 8'h04;
					72'hffff01ff01ff01ffff:result <= 8'h04;
				endcase
			end
			
			4'h9:
			begin
				state <= state + 1;
				case(InputImage_Cur)
					72'h01ff01ff01ff01ff01:result <= 8'hf8;
					72'hff01ff01ff01ff01ff:result <= 8'h08;
					72'h01ffffff01ffffff01:result <= 8'hfc;
					72'hffff01ff01ff01ffff:result <= 8'hfc;
				endcase
			end
			
			4'ha:
			begin
				state <= state + 1;
				case(InputImage_Cur)
					72'h01ff01ff01ff01ff01:result <= 8'h04;
					72'hff01ff01ff01ff01ff:result <= 8'hfc;
					72'h01ffffff01ffffff01:result <= 8'h00;
					72'hffff01ff01ff01ffff:result <= 8'h08;
				endcase
			end
			
			4'hb:
			begin
				state <= 4'h8;
				case(InputImage_Cur)
					72'h01ff01ff01ff01ff01:result <= 8'h04;
					72'hff01ff01ff01ff01ff:result <= 8'hfc;
					72'h01ffffff01ffffff01:result <= 8'h08;
					72'hffff01ff01ff01ffff:result <= 8'h00;
				endcase
				InputImage_Cur <= InputImage;
			end
		endcase
	end
end
endmodule : NeuralNet_Ref