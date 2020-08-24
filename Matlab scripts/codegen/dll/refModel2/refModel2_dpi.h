/*

*File: C:\Users\liora.000\Documents\Semester summer 2020\UVM_project\Matlab scripts\codegen\dll\refModel2\refModel2_dpi.h
*Created: 2020-08-18 11:28:42
*Generated by MATLAB 9.7 and HDL Verifier 6.0

*/

#ifndef RTW_HEADER_refModel2_dpi_h_
#define RTW_HEADER_refModel2_dpi_h_

#ifdef __cplusplus
#define DPI_LINK_DECL extern "C"
#else
#define DPI_LINK_DECL
#endif

#ifndef DPI_DLL_EXPORT
#ifdef _MSC_VER
#define DPI_DLL_EXPORT __declspec(dllexport)
#else
#define DPI_DLL_EXPORT 
#endif
#endif


DPI_LINK_DECL
DPI_DLL_EXPORT void * DPI_refModel2_initialize(void* existhandle);
DPI_LINK_DECL
DPI_DLL_EXPORT void * DPI_refModel2_reset(void* objhandle,short * inputMatrix,short * inputCent,short * finalCent);
DPI_LINK_DECL
DPI_DLL_EXPORT void DPI_refModel2(void* objhandle,short * inputMatrix,short * inputCent,short * finalCent);
DPI_LINK_DECL
DPI_DLL_EXPORT void DPI_refModel2_terminate(void* existhandle);
#endif