`timescale 1ns/100fs

`define NoOfKernels 2
`define NoOfShapes 4
`define numAddr 5

module NeuralNet ( input clk, 
    input [3:0] [7:0] pixels,
    input rst, learn, classify,
    input [31:0] KIDATA1, KIDATA2, W1IDATA1, W1IDATA2, W2IDATA1, W2IDATA2, 
    output logic [7:0] result);

logic [`NoOfKernels-1:0] [7:0] convResult;
logic [3:0] [7:0] pooledPixelArray[`NoOfKernels-1:0];
logic [`numAddr-1:0] KMEM_A1;
logic [`numAddr-1:0] KMEM_A2;
logic [`numAddr-1:0] WMEM_A1;
logic [`numAddr-1:0] WMEM_A2;
logic KMEM_WEB1, KMEM_OEB1, KMEM_CSB1;
logic KMEM_WEB2, KMEM_OEB2, KMEM_CSB2;
logic WMEM_WEB1, WMEM_OEB1, WMEM_CSB1;
logic WMEM_WEB2, WMEM_OEB2, WMEM_CSB2;
logic [1:0][31:0] KODATA;
logic [31:0] W1ODATA1, W1ODATA2,W2ODATA1, W2ODATA2;
logic En;

NeuralNet_cont U1(.*);

genvar k;
generate for (k = 0; k <`NoOfKernels ; k = k + 1) begin
    CNeuron I_CNeuron(.clk(clk), .kernel(KODATA[k]), .pixels(pixels), .convResult(convResult[k]));
    pooling I_pooling(.clk(clk), .En(En), .convResult(convResult[k]), .pooledPixels(pooledPixelArray[k]));
 end
endgenerate

FCNeuron I_FCNeuron(.clk(clk), .pooledPixelArray({pooledPixelArray[0],pooledPixelArray[1]}), .weight({W1ODATA1,W2ODATA1}), .result(result));

dpram32x32_cb K1(.A1(KMEM_A1), .A2(KMEM_A2), .CEB1(clk), .CEB2(clk), .WEB1(KMEM_WEB1), .WEB2(KMEM_WEB2), .OEB1(KMEM_OEB1), .OEB2(KMEM_OEB2), .CSB1(KMEM_CSB1), .CSB2(KMEM_CSB2), .I1(KIDATA1), .I2(KIDATA2), .O1(KODATA[0]), .O2(KODATA[1]) );
dpram32x32_cb W1(.A1(WMEM_A1), .A2(WMEM_A2), .CEB1(clk), .CEB2(clk), .WEB1(WMEM_WEB1), .WEB2(WMEM_WEB2), .OEB1(WMEM_OEB1), .OEB2(WMEM_OEB2), .CSB1(WMEM_CSB1), .CSB2(WMEM_CSB2), .I1(W1IDATA1), .I2(W1IDATA2), .O1(W1ODATA1), .O2(W1ODATA2) );
dpram32x32_cb W2(.A1(WMEM_A1), .A2(WMEM_A2), .CEB1(clk), .CEB2(clk), .WEB1(WMEM_WEB1), .WEB2(WMEM_WEB2), .OEB1(WMEM_OEB1), .OEB2(WMEM_OEB2), .CSB1(WMEM_CSB1), .CSB2(WMEM_CSB2), .I1(W2IDATA1), .I2(W2IDATA2), .O1(W2ODATA1), .O2(W2ODATA2) );


endmodule
