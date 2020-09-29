/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * refModel3.c
 *
 * Code generation for function 'refModel3'
 *
 */

/* Include files */
#include "refModel3.h"
#include <math.h>
#include <string.h>

/* Function Declarations */
static double rt_roundd_snf(double u);

/* Function Definitions */
static double rt_roundd_snf(double u)
{
  double y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

void refModel3(const short inputMatrix[3584], const short inputCent[56], short
               inputThreshold, unsigned short inputFirstPoint, unsigned short
               inputLastPoint, short finalCent[56])
{
  int i;
  int numRows;
  int converged;
  short acummulators[56];
  double acummuCnts[8];
  short currentCent[56];
  int b_i;
  int j;
  double convegrnceCnt;
  double distances[8];
  int k;
  short X[7];
  short i1;
  int Y;
  short i2;
  int i3;
  double d;
  int i4;
  int b_acummulators;

  /* Summary of this function goes here */
  /*    */
  /*     */
  /*     */
  /*    */
  /*     */
  /*  initiate  */
  memcpy(&finalCent[0], &inputCent[0], 56U * sizeof(short));

  /* finalCent.RoundingMethod ='Floor' */
  if (inputFirstPoint > inputLastPoint) {
    i = 0;
  } else {
    i = inputFirstPoint - 1;
  }

  numRows = inputLastPoint - inputFirstPoint;

  /* initialCent = double(inputCent); */
  /*  do k means */
  converged = 0;

  /* currentCent.RoundingMethod = 'Floor' */
  while (converged == 0) {
    memset(&acummulators[0], 0, 56U * sizeof(short));

    /* acummulators.RoundingMethod = 'Floor' */
    memset(&acummuCnts[0], 0, 8U * sizeof(double));
    memcpy(&currentCent[0], &finalCent[0], 56U * sizeof(short));

    /* currentCent.RoundingMethod = 'Floor' */
    /* calculate distance and add to acumulator  */
    for (b_i = 0; b_i <= numRows; b_i++) {
      for (j = 0; j < 8; j++) {
        for (k = 0; k < 7; k++) {
          i1 = finalCent[k + 7 * j];
          i2 = inputMatrix[k + 7 * (i + b_i)];
          if ((i1 & 8192) != 0) {
            i3 = i1 | -8192;
          } else {
            i3 = i1 & 8191;
          }

          if ((i2 & 8192) != 0) {
            i4 = i2 | -8192;
          } else {
            i4 = i2 & 8191;
          }

          i1 = (short)(i3 - i4);
          if ((i1 & 8192) != 0) {
            i1 = (short)(i1 | -8192);
          } else {
            i1 = (short)(i1 & 8191);
          }

          i3 = -i1;
          if (i3 > 8191) {
            i3 = 8191;
          }

          if (i1 < 0) {
            X[k] = (short)i3;
          } else {
            X[k] = i1;
          }
        }

        if ((X[0] & 65536) != 0) {
          Y = X[0] | -65536;
        } else {
          Y = X[0] & 65535;
        }

        for (k = 0; k < 6; k++) {
          i3 = X[k + 1];
          if ((i3 & 65536) != 0) {
            i3 |= -65536;
          } else {
            i3 &= 65535;
          }

          Y += i3;
          if (Y > 65535) {
            Y = 65535;
          } else {
            if (Y < -65536) {
              Y = -65536;
            }
          }
        }

        distances[j] = (double)Y * 0.0009765625;
      }

      convegrnceCnt = distances[0];
      j = 0;
      for (k = 2; k < 9; k++) {
        d = distances[k - 1];
        if (convegrnceCnt > d) {
          convegrnceCnt = d;
          j = k - 1;
        }
      }

      for (i3 = 0; i3 < 7; i3++) {
        Y = i3 + 7 * j;
        i1 = inputMatrix[i3 + 7 * (i + b_i)];
        if ((acummulators[Y] & 8192) != 0) {
          b_acummulators = acummulators[Y] | -8192;
        } else {
          b_acummulators = acummulators[Y] & 8191;
        }

        if ((i1 & 8192) != 0) {
          i4 = i1 | -8192;
        } else {
          i4 = i1 & 8191;
        }

        i1 = (short)(b_acummulators + i4);
        if ((i1 & 8192) != 0) {
          i1 = (short)(i1 | -8192);
        } else {
          i1 = (short)(i1 & 8191);
        }

        if (i1 > 4095) {
          i1 = 4095;
        } else {
          if (i1 < -4096) {
            i1 = -4096;
          }
        }

        acummulators[Y] = i1;
      }

      acummuCnts[j]++;
    }

    /* calculate new centroids and check convergence */
    convegrnceCnt = 0.0;
    for (b_i = 0; b_i < 8; b_i++) {
      if (acummuCnts[b_i] > 0.0) {
        /* currentCent(i,:) = (floor(currentCent(i,:).*1000))/1000; */
        for (k = 0; k < 7; k++) {
          i3 = k + 7 * b_i;
          Y = acummulators[i3] * 4000;
          if ((Y & 33554432) != 0) {
            Y |= -33554432;
          } else {
            Y &= 33554431;
          }

          d = floor(rt_roundd_snf((double)Y * 0.000244140625) / 1000.0 /
                    acummuCnts[b_i] * 1024.0);
          if (d < 4096.0) {
            if (d >= -4096.0) {
              i1 = (short)d;
            } else {
              i1 = -4096;
            }
          } else if (d >= 4096.0) {
            i1 = 4095;
          } else {
            i1 = 0;
          }

          currentCent[i3] = i1;
          if ((i1 & 8192) != 0) {
            i4 = i1 | -8192;
          } else {
            i4 = i1 & 8191;
          }

          if ((finalCent[i3] & 8192) != 0) {
            b_acummulators = finalCent[i3] | -8192;
          } else {
            b_acummulators = finalCent[i3] & 8191;
          }

          i1 = (short)(i4 - b_acummulators);
          if ((i1 & 8192) != 0) {
            i1 = (short)(i1 | -8192);
          } else {
            i1 = (short)(i1 & 8191);
          }

          i3 = -i1;
          if (i3 > 8191) {
            i3 = 8191;
          }

          if (i1 < 0) {
            X[k] = (short)i3;
          } else {
            X[k] = i1;
          }
        }

        if ((X[0] & 65536) != 0) {
          Y = X[0] | -65536;
        } else {
          Y = X[0] & 65535;
        }

        for (k = 0; k < 6; k++) {
          i3 = X[k + 1];
          if ((i3 & 65536) != 0) {
            i3 |= -65536;
          } else {
            i3 &= 65535;
          }

          Y += i3;
          if (Y > 65535) {
            Y = 65535;
          } else {
            if (Y < -65536) {
              Y = -65536;
            }
          }
        }

        if (Y <= inputThreshold) {
          convegrnceCnt++;
        }
      } else {
        convegrnceCnt++;
      }
    }

    if (convegrnceCnt == 8.0) {
      converged = 1;
    } else {
      memcpy(&finalCent[0], &currentCent[0], 56U * sizeof(short));
    }
  }
}

void refModel3_initialize(void)
{
}

void refModel3_terminate(void)
{
  /* (no terminate code required) */
}

/* End of code generation (refModel3.c) */
