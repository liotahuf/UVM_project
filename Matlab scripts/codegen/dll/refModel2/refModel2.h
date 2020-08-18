/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * refModel2.h
 *
 * Code generation for function 'refModel2'
 *
 */

#ifndef REFMODEL2_H
#define REFMODEL2_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "refModel2_types.h"

/* Function Declarations */
#ifdef __cplusplus

extern "C" {

#endif

  extern void refModel2(const short inputMatrix[3584], const short inputCent[56],
                        short finalCent[56]);
  extern void refModel2_initialize(void);
  extern void refModel2_terminate(void);

#ifdef __cplusplus

}
#endif
#endif

/* End of code generation (refModel2.h) */
