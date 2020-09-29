/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * refModel3.h
 *
 * Code generation for function 'refModel3'
 *
 */

#ifndef REFMODEL3_H
#define REFMODEL3_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "refModel3_types.h"

/* Function Declarations */
#ifdef __cplusplus

extern "C" {

#endif

  extern void refModel3(const short inputMatrix[3584], const short inputCent[56],
                        short inputThreshold, unsigned short inputFirstPoint,
                        unsigned short inputLastPoint, short finalCent[56]);
  extern void refModel3_initialize(void);
  extern void refModel3_terminate(void);

#ifdef __cplusplus

}
#endif
#endif

/* End of code generation (refModel3.h) */
