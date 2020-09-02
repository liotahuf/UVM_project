/*------------------------------------------------------------------------------
 * File          : NeuralNet_if.sv
 * Project       : Ver_MLExpt
 * Author        : goel
 * Creation date : Feb 10, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

interface NeuralNet_if;

logic [3:0] [7:0] pixels;
logic clk, rst, learn, classify;
logic [31:0] KIDATA1, KIDATA2, W1IDATA1, W1IDATA2, W2IDATA1, W2IDATA2; 
logic [7:0] result;

endinterface : NeuralNet_if
