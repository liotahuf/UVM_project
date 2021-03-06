/*

*File: C:\Users\liora.000\Documents\Semester summer 2020\UVM_project\Matlab scripts\codegen\dll\refModel2\refModel2_dpi.c
*Created: 2020-09-01 09:44:50
*Generated by MATLAB 9.7 and HDL Verifier 6.0

*/

#include "refModel2.h"
#include "refModel2_dpi.h"
#include <string.h>



void get13BitBy56ArrayFromSignedCData(svBitVecVal * SVBitData,short CData[56])
{
short	idx;
for(idx=0;idx<56;idx++)
{

SVBitData[idx]=(svBitVecVal)CData[idx]&0x00001FFF;

}
}
void getSignedCDataFrom13By3584BitArray(short CData[3584],const svBitVecVal * SVBitData)
{
short TempData;
short	idx;
for(idx=0;idx<3584;idx++)
{
TempData=((SVBitData[idx])&0x00001000)!=0 ? (short)(((short)(SVBitData[idx]&0x00001FFF)) | 0xFFFFE000) : (short)(SVBitData[idx]&0x00001FFF);
memcpy(&CData[idx],&TempData,sizeof(short));

}}
void getSignedCDataFrom13By56BitArray(short CData[56],const svBitVecVal * SVBitData)
{
short TempData;
short	idx;
for(idx=0;idx<56;idx++)
{
TempData=((SVBitData[idx])&0x00001000)!=0 ? (short)(((short)(SVBitData[idx]&0x00001FFF)) | 0xFFFFE000) : (short)(SVBitData[idx]&0x00001FFF);
memcpy(&CData[idx],&TempData,sizeof(short));

}}


DPI_DLL_EXPORT void * DPI_refModel2_initialize(void* existhandle)
{
    
    refModel2_initialize();
    existhandle=NULL;
    return NULL;
    
}

DPI_DLL_EXPORT void * DPI_refModel2_reset(void* objhandle,svBitVecVal * inputMatrix_bit,svBitVecVal * inputCent_bit,svBitVecVal * finalCent_bit)
{
    DPI_refModel2_terminate(objhandle);
    objhandle=NULL;
    objhandle=DPI_refModel2_initialize(NULL);
    DPI_refModel2(objhandle,inputMatrix_bit,inputCent_bit,finalCent_bit);
    DPI_refModel2_terminate(objhandle);
    objhandle=NULL;
    return DPI_refModel2_initialize(NULL);
    
}

DPI_DLL_EXPORT void DPI_refModel2(void* objhandle,svBitVecVal * inputMatrix_bit,svBitVecVal * inputCent_bit,svBitVecVal * finalCent_bit)
{
    short finalCent[56];
    short inputCent[56];
    short inputMatrix[3584];
    
    getSignedCDataFrom13By56BitArray(inputCent,inputCent_bit);
    getSignedCDataFrom13By3584BitArray(inputMatrix,inputMatrix_bit);
    
    refModel2(inputMatrix,inputCent,finalCent); 
     objhandle=NULL; 
    
    get13BitBy56ArrayFromSignedCData(finalCent_bit,finalCent);
    
    
}

DPI_DLL_EXPORT void DPI_refModel2_terminate(void* existhandle)
{
    existhandle=NULL;
    refModel2_terminate();
    
}
