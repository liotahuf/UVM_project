/*------------------------------------------------------------------------------
 * File          : NeuralNet_Ref_if.sv
 * Project       : Ver_MLExpt
 * Author        : goel
 * Creation date : Feb 14, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

interface NeuralNet_Ref_if;

logic clk ;
logic rst ;
logic [71:0] InputImage; 
logic [7:0] result;

endinterface : NeuralNet_Ref_if