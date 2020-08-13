`timescale 1ns/100fs

module FCNeuron ( input clk,
    input [7:0][7:0] pooledPixelArray, 
    input [63:0] weight, 
	output logic [7:0] result);
 
    logic [7:0] sum;
    integer i;

    always_comb 
     begin
       sum = pooledPixelArray[0] * weight[7:0];
       for (i=1; i<8; i=i+1) 
           //sum = sum + pooledPixelArray[i] * weight[(i+1)*8-1,(i+1)*8-8];
           sum = sum + pooledPixelArray[i] * weight[(i*8)+7 -: 8];
     end

	
	always_ff @(posedge clk)
		begin
			result <= sum;
		end
endmodule
