/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_refModel3_api.h
 *
 * Code generation for function '_coder_refModel3_api'
 *
 */

#ifndef _CODER_REFMODEL3_API_H
#define _CODER_REFMODEL3_API_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
#ifdef __cplusplus

extern "C" {

#endif

  extern void refModel3(int16_T inputMatrix[3584], int16_T inputCent[56],
                        int16_T inputThreshold, uint16_T inputFirstPoint,
                        uint16_T inputLastPoint, int16_T finalCent[56]);
  extern void refModel3_api(const mxArray * const prhs[5], int32_T nlhs, const
    mxArray *plhs[1]);
  extern void refModel3_atexit(void);
  extern void refModel3_initialize(void);
  extern void refModel3_terminate(void);
  extern void refModel3_xil_shutdown(void);
  extern void refModel3_xil_terminate(void);

#ifdef __cplusplus

}
#endif
#endif

/* End of code generation (_coder_refModel3_api.h) */
