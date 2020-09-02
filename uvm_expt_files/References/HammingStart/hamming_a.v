//---------------------------------------------------------------------------
// This is a Verilog file that defines a hamming encoder. 
//
//---------------------------------------------------------------------------
 module hamming ( x , z );
 
    input  [7:1] x ;    // The seven-bit input 
    output  [11:1] z ;        // The 11-bit output
    reg [11:1] z ;
    reg     clk;

    initial clk = 1'b1;
    always #50 clk = ~clk;


always @(posedge clk)
begin
 
    z[11] =  x[7] ;
    z[10] =  x[6] ;
    z[9] =  x[5] ;
    z[8] =  x[5] ^ x[6] ^ x[7];
    z[7] =  x[4] ;
    z[6] =  x[3] ;
    z[5] =  x[2] ;
    z[4] =  x[4] ^ x[3] ^ x[2];
    z[3] =  x[1] ;
    z[2] =  x[7] ^ x[6] ^ x[4] ^ x[3] ^ x[1];
    z[1] =  x[7] ^ x[5] ^ x[4] ^ x[2] ^ x[1];
end 

 endmodule

