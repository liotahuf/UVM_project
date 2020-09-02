//---------------------------------------------------------------------------
// This is a Verilog file that defines a hamming encoder. 
//
//---------------------------------------------------------------------------
module hamming_ref (input clk, input [7:1] x , output logic [11:1] z );

 
    logic [3:0] h ;

always @(posedge clk)
begin
    h = 4'b0000 ; 
    if (x[7] == 1)  h = h ^ 4'b1011 ;
    if (x[6] == 1)  h = h ^ 4'b1010 ;
    if (x[5] == 1)  h = h ^ 4'b1001 ;
    if (x[4] == 1)  h = h ^ 4'b0111 ;
    if (x[3] == 1)  h = h ^ 4'b0110 ;
    if (x[2] == 1)  h = h ^ 4'b0101 ;
    if (x[1] == 1)  h = h ^ 4'b0011 ;

    z[11] =  x[7] ;
    // intentional error
    //z[11] =  x[6] ;
    z[10] =  x[6] ;
    z[9] =  x[5] ;
    z[8] =  h[3] ;
    z[7] =  x[4] ;
    z[6] =  x[3] ;
    z[5] =  x[2] ;
    z[4] =  h[2] ;
    z[3] =  x[1] ;
    z[2] =  h[1] ;
    z[1] =  h[0] ;
end 

endmodule

