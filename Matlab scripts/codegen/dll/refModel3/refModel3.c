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
#include <string.h>

/* Function Declarations */
static int div_s22s32_near(int numerator, int denominator);

/* Function Definitions */
static int div_s22s32_near(int numerator, int denominator)
{
  int quotient;
  unsigned int absNumerator;
  unsigned int absDenominator;
  boolean_T quotientNeedsNegation;
  unsigned int tempAbsQuotient;
  if (denominator == 0) {
    if (numerator >= 0) {
      quotient = 2097151;
    } else {
      quotient = -2097152;
    }
  } else {
    if (numerator < 0) {
      absNumerator = ~(unsigned int)numerator + 1U;
    } else {
      absNumerator = (unsigned int)numerator;
    }

    if (denominator < 0) {
      absDenominator = ~(unsigned int)denominator + 1U;
    } else {
      absDenominator = (unsigned int)denominator;
    }

    quotientNeedsNegation = ((numerator < 0) != (denominator < 0));
    tempAbsQuotient = absNumerator / absDenominator;
    absNumerator %= absDenominator;
    absNumerator <<= 1U;
    if ((absNumerator >= absDenominator) && ((!quotientNeedsNegation) ||
         (absNumerator > absDenominator))) {
      tempAbsQuotient++;
    }

    if (quotientNeedsNegation) {
      quotient = -(int)tempAbsQuotient;
    } else {
      quotient = (int)tempAbsQuotient;
    }

    if ((quotient & 2097152) != 0) {
      quotient |= -2097152;
    } else {
      quotient &= 2097151;
    }
  }

  return quotient;
}

void refModel3(const short inputMatrix[3584], const short inputCent[56], short
               inputThreshold, unsigned short inputFirstPoint, unsigned short
               inputLastPoint, short finalCent[56])
{
  int i;
  int numRows;
  int converged;
  int acummulators[56];
  int b_i;
  short currentCent[56];
  unsigned short acummuCnts[8];
  int c_i;
  double convegrnceCnt;
  double distances[8];
  int k;
  int iidx;
  unsigned short b;
  short X[7];
  short i1;
  int Y;
  short i2;
  int i3;
  double d;
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
    memset(&acummulators[0], 0, 56U * sizeof(int));

    /* acummulators.RoundingMethod = 'Floor' */
    for (b_i = 0; b_i < 8; b_i++) {
      acummuCnts[b_i] = 0U;
    }

    memcpy(&currentCent[0], &finalCent[0], 56U * sizeof(short));

    /* currentCent.RoundingMethod = 'Floor' */
    /* calculate distance and add to acumulator  */
    for (b_i = 0; b_i <= numRows; b_i++) {
      for (c_i = 0; c_i < 8; c_i++) {
        for (k = 0; k < 7; k++) {
          i1 = finalCent[k + 7 * c_i];
          i2 = inputMatrix[k + 7 * (i + b_i)];
          if ((i1 & 8192) != 0) {
            i3 = i1 | -8192;
          } else {
            i3 = i1 & 8191;
          }

          if ((i2 & 8192) != 0) {
            b_acummulators = i2 | -8192;
          } else {
            b_acummulators = i2 & 8191;
          }

          i1 = (short)(i3 - b_acummulators);
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

        distances[c_i] = (double)Y * 0.0009765625;
      }

      convegrnceCnt = distances[0];
      iidx = 0;
      for (k = 2; k < 9; k++) {
        d = distances[k - 1];
        if (convegrnceCnt > d) {
          convegrnceCnt = d;
          iidx = k - 1;
        }
      }

      for (i3 = 0; i3 < 7; i3++) {
        c_i = i3 + 7 * iidx;
        Y = inputMatrix[i3 + 7 * (i + b_i)];
        if ((acummulators[c_i] & 4194304) != 0) {
          b_acummulators = acummulators[c_i] | -4194304;
        } else {
          b_acummulators = acummulators[c_i] & 4194303;
        }

        if ((Y & 4194304) != 0) {
          Y |= -4194304;
        } else {
          Y &= 4194303;
        }

        Y += b_acummulators;
        if ((Y & 4194304) != 0) {
          Y |= -4194304;
        } else {
          Y &= 4194303;
        }

        if (Y > 2097151) {
          Y = 2097151;
        } else {
          if (Y < -2097152) {
            Y = -2097152;
          }
        }

        acummulators[c_i] = Y;
      }

      b = (unsigned short)(acummuCnts[iidx] + 1U);
      if (b > 511) {
        b = 511U;
      }

      acummuCnts[iidx] = b;
    }

    /* calculate new centroids and check convergence */
    convegrnceCnt = 0.0;
    for (b_i = 0; b_i < 8; b_i++) {
      b = acummuCnts[b_i];
      if (acummuCnts[b_i] > 0) {
        /* currAcummDouble = round(double(acummulators(i,:)*1000))/1000; */
        /* currCentDouble = currAcummDouble/acummuCnts(i); */
        /* currentCent(i,:) = fi(currCentDouble,1,13,10,'RoundingMethod','Floor') */
        /* currentCent(i,:) = (floor(currentCent(i,:).*1000))/1000; */
        for (Y = 0; Y < 7; Y++) {
          if (7 > Y + 1) {
            c_i = Y;
          } else {
            c_i = 6;
          }

          if (b == 0) {
            if (acummulators[c_i + 7 * b_i] < 0) {
              i3 = -2097152;
            } else {
              i3 = 2097151;
            }
          } else {
            i3 = div_s22s32_near(acummulators[c_i + 7 * b_i], b);
          }

          if (i3 > 4095) {
            i3 = 4095;
          } else {
            if (i3 < -4096) {
              i3 = -4096;
            }
          }

          i1 = (short)i3;
          c_i = Y + 7 * b_i;
          currentCent[c_i] = i1;
          if ((i1 & 8192) != 0) {
            i3 = i1 | -8192;
          } else {
            i3 = i1 & 8191;
          }

          if ((finalCent[c_i] & 8192) != 0) {
            b_acummulators = finalCent[c_i] | -8192;
          } else {
            b_acummulators = finalCent[c_i] & 8191;
          }

          i1 = (short)(i3 - b_acummulators);
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
            X[Y] = (short)i3;
          } else {
            X[Y] = i1;
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
