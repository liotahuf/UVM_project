`timescale 1ns/100fs

module CNeuron ( input clk,
    input [31:0] kernel, 
    input [3:0] [7:0] pixels, 
	output logic [7:0] convResult);
 
    logic [7:0] sum;
    integer i;

    always_comb 
     begin
       sum = pixels[0] * kernel[7:0] ;
       for (i=1; i<4; i=i+1) begin
           sum = sum + pixels[i] * kernel[(i*8)+7 -: 8];
       end
     end

	
	always_ff @(posedge clk)
		begin
			convResult <= sum;
		end
endmodule
