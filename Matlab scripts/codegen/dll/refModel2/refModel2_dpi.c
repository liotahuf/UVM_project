/*

*File: C:\Users\liora.000\Documents\Semester summer 2020\UVM_project\Matlab scripts\codegen\dll\refModel2\refModel2_dpi.c
*Created: 2020-08-18 11:28:42
*Generated by MATLAB 9.7 and HDL Verifier 6.0

*/

#include "refModel2.h"
#include "refModel2_dpi.h"
#include <string.h>





DPI_DLL_EXPORT void * DPI_refModel2_initialize(void* existhandle)
{
    
    refModel2_initialize();
    existhandle=NULL;
    return NULL;
    
}

DPI_DLL_EXPORT void * DPI_refModel2_reset(void* objhandle,short * inputMatrix,short * inputCent,short * finalCent)
{
    DPI_refModel2_terminate(objhandle);
    objhandle=NULL;
    objhandle=DPI_refModel2_initialize(NULL);
    DPI_refModel2(objhandle,inputMatrix,inputCent,finalCent);
    DPI_refModel2_terminate(objhandle);
    objhandle=NULL;
    return DPI_refModel2_initialize(NULL);
    
}

DPI_DLL_EXPORT void DPI_refModel2(void* objhandle,short * inputMatrix,short * inputCent,short * finalCent)
{
    
    
    refModel2(inputMatrix,inputCent,finalCent); 
     objhandle=NULL; 
    
    
    
}

DPI_DLL_EXPORT void DPI_refModel2_terminate(void* existhandle)
{
    existhandle=NULL;
    refModel2_terminate();
    
}
