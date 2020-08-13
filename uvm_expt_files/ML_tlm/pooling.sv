`timescale 1ns/100fs

module pooling ( input clk, En,
    input [7:0]  convResult, 
	output logic [3:0][7:0] pooledPixels);
 
    integer i;
    logic [2:0] [7:0] convolution;
    logic [3:0] [7:0] pooledReg;

	always_ff @(posedge clk)
		begin
               convolution[2]   <= convResult ;
               convolution[1]   <= convolution[2] ;
               convolution[0]   <= convolution[1] ;
        end

	always_ff @(negedge clk)
		begin
          if (En == 1'b1)
          begin
            for (i=0; i<3; i=i+1)
              begin
			    pooledReg[i]   <= ($signed(convolution[i]) > 2) ? 1 : -1;
              end
            pooledReg[3] <= ($signed(convResult) > 2) ? 1 : -1;
          end
		end
     
     assign pooledPixels = pooledReg;
endmodule
