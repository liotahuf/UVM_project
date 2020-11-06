/*------------------------------------------------------------------------------
 * File          : Kmeans_Ref_if.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

interface Kmeans_Ref_if;

logic clk;
logic go;
logic rst;
logic [12:0] matrix [0:3583];//TODO - make sure connection of matrix work
logic [12:0] in_centroids [0:55];//TODO - make sure connection of matrix work
logic [12:0] threshold;
logic [12:0] first_point_index;
logic [12:0] last_point_index;
logic [12:0] out_centroids [0:55];

endinterface : Kmeans_Ref_if