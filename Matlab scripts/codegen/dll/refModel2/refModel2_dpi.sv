// File: C:\Users\liora.000\Documents\Semester summer 2020\UVM_project\Matlab scripts\codegen\dll\refModel2\refModel2_dpi.sv
// Created: 2020-08-18 11:28:42
// Generated by MATLAB 9.7 and HDL Verifier 6.0

`timescale 1ns / 1ns

import refModel2_dpi_pkg::*;



module refModel2_dpi(
    input bit clk,
    input bit clk_enable,
    input bit reset,
    input shortint inputMatrix [0:3583],
    input shortint inputCent [0:55],
    output shortint finalCent [0:55]
);

    chandle objhandle=null;
    
    shortint finalCent_temp [0:55];
    
    

    initial begin
        objhandle=DPI_refModel2_initialize(objhandle);
    end

    final begin
        DPI_refModel2_terminate(objhandle);
    end

    always @(posedge clk or posedge reset) begin
        if(reset== 1'b1) begin
            objhandle=DPI_refModel2_reset(objhandle,inputMatrix,inputCent,finalCent_temp);
            finalCent<=finalCent_temp;
            
        end
        else if(clk_enable) begin
            DPI_refModel2(objhandle,inputMatrix,inputCent,finalCent_temp);
            
            finalCent<=finalCent_temp;
            
            
            
            
        end
    end
endmodule
