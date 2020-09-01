/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * refModel2.c
 *
 * Code generation for function 'refModel2'
 *
 */

/* Include files */
#include "refModel2.h"
#include "rt_nonfinite.h"
#include <math.h>
#include <string.h>

/* Function Declarations */
static void batchUpdate(const double X_data[], const int X_size[2], int
  idx_data[], int idx_size[1], double C[56], double D_data[], const int D_size[2],
  int counts[8], const int iSorted_data[], const int iSorted_size[2], boolean_T *
  converged, int *iter);
static int findchanged(int changed[8], const int idx_data[], const int
  previdx_data[], const int moved_data[], const int moved_size[1], int nmoved);
static void gcentroids(double C[56], int counts[8], const double X_data[], const
  int X_size[2], const int idx_data[], const int clusters[8], int nclusters,
  const int iSorted_data[], const int iSorted_size[2]);
static void kmeans(double X_data[], int X_size[2], const double varargin_6[56],
                   double idxbest_data[], int idxbest_size[1], double Cbest[56]);
static void local_kmeans(const double X_data[], const int X_size[2], const
  double startInput[56], int idxbest_data[], int idxbest_size[1], double Cbest
  [56]);
static void loopBody(const double X_data[], const int X_size[2], const double
                     Cinput[56], const int iSorted_data[], const int
                     iSorted_size[2], double *totsumD, int idx_data[], int
                     idx_size[1], double C[56]);
static void mindim2(const double D_data[], const int D_size[2], double d_data[],
                    int d_size[1], int idx_data[], int idx_size[1]);
static double rt_roundd_snf(double u);

/* Function Definitions */
static void batchUpdate(const double X_data[], const int X_size[2], int
  idx_data[], int idx_size[1], double C[56], double D_data[], const int D_size[2],
  int counts[8], const int iSorted_data[], const int iSorted_size[2], boolean_T *
  converged, int *iter)
{
  int n;
  int i;
  int previdx_size_idx_0;
  int empties[8];
  int b_n;
  int previdx_data[512];
  int moved_size[1];
  int moved_data[512];
  int j;
  int nchanged;
  int changed[8];
  double prevtotsumD;
  int exitg1;
  int cr;
  int r;
  double totsumD;
  int b_i;
  double d_data[512];
  int d_size[1];
  int nidx_data[512];
  int nidx_size[1];
  n = X_size[0] - 1;
  for (i = 0; i < 8; i++) {
    empties[i] = 0;
  }

  previdx_size_idx_0 = X_size[0];
  b_n = X_size[0];
  if (0 <= b_n - 1) {
    memset(&previdx_data[0], 0, b_n * sizeof(int));
  }

  moved_size[0] = X_size[0];
  b_n = X_size[0];
  if (0 <= b_n - 1) {
    memset(&moved_data[0], 0, b_n * sizeof(int));
  }

  for (j = 0; j < 8; j++) {
    changed[j] = j + 1;
  }

  nchanged = 8;
  prevtotsumD = rtInf;
  *iter = 0;
  *converged = false;
  do {
    exitg1 = 0;
    (*iter)++;
    gcentroids(C, counts, X_data, X_size, idx_data, changed, nchanged,
               iSorted_data, iSorted_size);
    b_n = X_size[0] - 1;
    for (i = 0; i < nchanged; i++) {
      cr = changed[i] - 1;
      for (r = 0; r <= b_n; r++) {
        D_data[r + D_size[0] * cr] = fabs(X_data[r] - C[changed[i] - 1]);
      }

      for (j = 0; j < 6; j++) {
        for (r = 0; r <= b_n; r++) {
          b_i = r + D_size[0] * cr;
          D_data[b_i] += fabs(X_data[r + X_size[0] * (j + 1)] - C[cr + ((j + 1) <<
            3)]);
        }
      }
    }

    b_n = 0;
    for (j = 0; j < nchanged; j++) {
      if (counts[changed[j] - 1] == 0) {
        b_n++;
        empties[b_n - 1] = changed[j];
      }
    }

    if (b_n > 0) {
      for (j = 0; j < b_n; j++) {
        for (i = 0; i <= n; i++) {
          D_data[i + D_size[0] * (empties[j] - 1)] = rtNaN;
        }
      }

      nchanged -= b_n;
      b_n = 0;
      cr = 0;
      while (b_n + 1 <= nchanged) {
        if (changed[b_n] == empties[cr]) {
          cr++;
        } else {
          changed[b_n - cr] = changed[b_n];
        }

        b_n++;
      }
    }

    totsumD = 0.0;
    for (i = 0; i <= n; i++) {
      totsumD += D_data[i + D_size[0] * (idx_data[i] - 1)];
    }

    if (prevtotsumD <= totsumD) {
      idx_size[0] = previdx_size_idx_0;
      if (0 <= previdx_size_idx_0 - 1) {
        memcpy(&idx_data[0], &previdx_data[0], previdx_size_idx_0 * sizeof(int));
      }

      gcentroids(C, counts, X_data, X_size, previdx_data, changed, nchanged,
                 iSorted_data, iSorted_size);
      (*iter)--;
      exitg1 = 1;
    } else if (*iter >= 100) {
      exitg1 = 1;
    } else {
      previdx_size_idx_0 = idx_size[0];
      b_n = idx_size[0];
      if (0 <= b_n - 1) {
        memcpy(&previdx_data[0], &idx_data[0], b_n * sizeof(int));
      }

      prevtotsumD = totsumD;
      mindim2(D_data, D_size, d_data, d_size, nidx_data, nidx_size);
      b_n = 0;
      for (i = 0; i <= n; i++) {
        if ((nidx_data[i] != previdx_data[i]) && (D_data[i + D_size[0] *
             (previdx_data[i] - 1)] > d_data[i])) {
          b_n++;
          moved_data[b_n - 1] = i + 1;
          idx_data[i] = nidx_data[i];
        }
      }

      if (b_n == 0) {
        *converged = true;
        exitg1 = 1;
      } else {
        nchanged = findchanged(changed, idx_data, previdx_data, moved_data,
          moved_size, b_n);
      }
    }
  } while (exitg1 == 0);
}

static int findchanged(int changed[8], const int idx_data[], const int
  previdx_data[], const int moved_data[], const int moved_size[1], int nmoved)
{
  int nchanged;
  int b_size_idx_0;
  int loop_ub;
  boolean_T b_data[512];
  b_size_idx_0 = (short)moved_size[0];
  loop_ub = (short)moved_size[0];
  if (0 <= loop_ub - 1) {
    memset(&b_data[0], 0, loop_ub * sizeof(boolean_T));
  }

  for (loop_ub = 0; loop_ub < nmoved; loop_ub++) {
    b_data[idx_data[moved_data[loop_ub] - 1] - 1] = true;
    b_data[previdx_data[moved_data[loop_ub] - 1] - 1] = true;
  }

  nchanged = 0;
  for (loop_ub = 0; loop_ub < b_size_idx_0; loop_ub++) {
    if (b_data[loop_ub]) {
      nchanged++;
      changed[nchanged - 1] = loop_ub + 1;
    }
  }

  return nchanged;
}

static void gcentroids(double C[56], int counts[8], const double X_data[], const
  int X_size[2], const int idx_data[], const int clusters[8], int nclusters,
  const int iSorted_data[], const int iSorted_size[2])
{
  int n;
  int ic;
  int i;
  int j;
  int cc;
  int idxCount[56];
  int lowerCount[8];
  short lowerRowIndex[56];
  int upperCount[8];
  short upperRowIndex[56];
  int medianCount[8];
  short medianRowIndex[56];
  int ndone;
  int ntodo;
  int idxCount_tmp;
  boolean_T exitg1;
  n = X_size[0] - 1;
  for (ic = 0; ic < nclusters; ic++) {
    counts[clusters[ic] - 1] = 0;
    for (j = 0; j < 7; j++) {
      C[(clusters[ic] + (j << 3)) - 1] = rtNaN;
    }
  }

  if (nclusters == 8) {
    for (i = 0; i <= n; i++) {
      counts[idx_data[i] - 1]++;
    }
  } else {
    for (ic = 0; ic < nclusters; ic++) {
      cc = 0;
      for (i = 0; i <= n; i++) {
        if (idx_data[i] == clusters[ic]) {
          cc++;
        }
      }

      counts[clusters[ic] - 1] = cc;
    }
  }

  n = X_size[0];
  for (i = 0; i < 8; i++) {
    lowerCount[i] = 0;
    upperCount[i] = 0;
    medianCount[i] = 0;
  }

  memset(&idxCount[0], 0, 56U * sizeof(int));
  memset(&lowerRowIndex[0], 0, 56U * sizeof(short));
  memset(&upperRowIndex[0], 0, 56U * sizeof(short));
  memset(&medianRowIndex[0], 0, 56U * sizeof(short));
  ndone = 0;
  ntodo = nclusters * 7;
  for (ic = 0; ic < nclusters; ic++) {
    idxCount_tmp = counts[clusters[ic] - 1];
    if (idxCount_tmp == 0) {
      ndone += 7;
    } else if (idxCount_tmp == 1) {
      lowerCount[clusters[ic] - 1] = 1;
      upperCount[clusters[ic] - 1] = 1;
      medianCount[clusters[ic] - 1] = 1;
    } else if ((idxCount_tmp & 1) != 0) {
      cc = counts[clusters[ic] - 1] >> 1;
      lowerCount[clusters[ic] - 1] = cc;
      upperCount[clusters[ic] - 1] = cc + 2;
      medianCount[clusters[ic] - 1] = cc + 1;
    } else {
      cc = idxCount_tmp >> 1;
      lowerCount[clusters[ic] - 1] = cc;
      upperCount[clusters[ic] - 1] = cc + 1;
    }
  }

  for (i = 0; i < n; i++) {
    j = 0;
    exitg1 = false;
    while ((!exitg1) && (j < 7)) {
      cc = iSorted_data[i + iSorted_size[0] * j] - 1;
      idxCount_tmp = (idx_data[cc] + (j << 3)) - 1;
      idxCount[idxCount_tmp]++;
      if (idxCount[idxCount_tmp] == lowerCount[idx_data[cc] - 1]) {
        lowerRowIndex[idxCount_tmp] = (short)(cc + 1);
      }

      if (idxCount[idxCount_tmp] == medianCount[idx_data[cc] - 1]) {
        medianRowIndex[idxCount_tmp] = (short)(cc + 1);
      }

      if (idxCount[idxCount_tmp] == upperCount[idx_data[cc] - 1]) {
        upperRowIndex[idxCount_tmp] = (short)(cc + 1);
        ndone++;
        if (ndone == ntodo) {
          exitg1 = true;
        } else {
          j++;
        }
      } else {
        j++;
      }
    }
  }

  for (j = 0; j < 7; j++) {
    for (ic = 0; ic < nclusters; ic++) {
      idxCount_tmp = (clusters[ic] + (j << 3)) - 1;
      if (lowerRowIndex[idxCount_tmp] == 0) {
        C[idxCount_tmp] = rtNaN;
      } else if (medianRowIndex[idxCount_tmp] == 0) {
        cc = X_size[0] * j;
        C[idxCount_tmp] = 0.5 * (X_data[(lowerRowIndex[idxCount_tmp] + cc) - 1]
          + X_data[(upperRowIndex[idxCount_tmp] + cc) - 1]);
      } else {
        C[idxCount_tmp] = X_data[(medianRowIndex[idxCount_tmp] + X_size[0] * j)
          - 1];
      }
    }
  }
}

static void kmeans(double X_data[], int X_size[2], const double varargin_6[56],
                   double idxbest_data[], int idxbest_size[1], double Cbest[56])
{
  int n;
  int loop_ub;
  boolean_T wasnan_data[512];
  boolean_T hadnans;
  int i;
  boolean_T exitg1;
  int idx_data[512];
  int idx_size[1];
  int trueCount;
  int partialTrueCount;
  double b_X_data[3584];
  n = X_size[0];
  loop_ub = X_size[0];
  if (0 <= loop_ub - 1) {
    memset(&wasnan_data[0], 0, loop_ub * sizeof(boolean_T));
  }

  hadnans = false;
  for (i = 0; i < n; i++) {
    loop_ub = 0;
    exitg1 = false;
    while ((!exitg1) && (loop_ub < 7)) {
      if (rtIsNaN(X_data[i + X_size[0] * loop_ub])) {
        hadnans = true;
        wasnan_data[i] = true;
        exitg1 = true;
      } else {
        loop_ub++;
      }
    }
  }

  if (hadnans) {
    loop_ub = X_size[0] - 1;
    trueCount = 0;
    for (i = 0; i <= loop_ub; i++) {
      if (!wasnan_data[i]) {
        trueCount++;
      }
    }

    partialTrueCount = 0;
    for (i = 0; i <= loop_ub; i++) {
      if (!wasnan_data[i]) {
        idx_data[partialTrueCount] = i + 1;
        partialTrueCount++;
      }
    }

    for (partialTrueCount = 0; partialTrueCount < 7; partialTrueCount++) {
      for (loop_ub = 0; loop_ub < trueCount; loop_ub++) {
        b_X_data[loop_ub + trueCount * partialTrueCount] = X_data
          [(idx_data[loop_ub] + X_size[0] * partialTrueCount) - 1];
      }
    }

    X_size[0] = trueCount;
    X_size[1] = 7;
    loop_ub = trueCount * 7;
    if (0 <= loop_ub - 1) {
      memcpy(&X_data[0], &b_X_data[0], loop_ub * sizeof(double));
    }
  }

  local_kmeans(X_data, X_size, varargin_6, idx_data, idx_size, Cbest);
  if (hadnans) {
    idxbest_size[0] = n;
    loop_ub = -1;
    for (i = 0; i < n; i++) {
      if (wasnan_data[i]) {
        idxbest_data[i] = rtNaN;
      } else {
        loop_ub++;
        idxbest_data[i] = idx_data[loop_ub];
      }
    }
  } else {
    idxbest_size[0] = idx_size[0];
    loop_ub = idx_size[0];
    for (partialTrueCount = 0; partialTrueCount < loop_ub; partialTrueCount++) {
      idxbest_data[partialTrueCount] = idx_data[partialTrueCount];
    }
  }
}

static void local_kmeans(const double X_data[], const int X_size[2], const
  double startInput[56], int idxbest_data[], int idxbest_size[1], double Cbest
  [56])
{
  int n;
  short unnamed_idx_0;
  int iSorted_size[2];
  int i;
  int iSorted_data[3584];
  int b_i;
  double b;
  int k;
  int offset;
  int b_k;
  int i2;
  int j;
  int pEnd;
  int p;
  int q;
  int qEnd;
  int kEnd;
  int b_tmp_tmp;
  int iwork_data[512];
  int i1;
  n = X_size[0];
  unnamed_idx_0 = (short)X_size[0];
  iSorted_size[0] = unnamed_idx_0;
  iSorted_size[1] = 7;
  i = unnamed_idx_0 * 7;
  if (0 <= i - 1) {
    memset(&iSorted_data[0], 0, i * sizeof(int));
  }

  if (X_size[0] != 0) {
    b_i = X_size[0] - 1;
    for (k = 0; k < 7; k++) {
      offset = k * n - 1;
      for (b_k = 1; b_k <= b_i; b_k += 2) {
        i = offset + b_k;
        i2 = i + 1;
        if ((X_data[i] <= X_data[i2]) || rtIsNaN(X_data[i2])) {
          iSorted_data[i] = b_k;
          iSorted_data[i2] = b_k + 1;
        } else {
          iSorted_data[i] = b_k + 1;
          iSorted_data[i2] = b_k;
        }
      }

      if ((n & 1) != 0) {
        iSorted_data[offset + n] = n;
      }

      i = 2;
      while (i < n) {
        i2 = i << 1;
        j = 1;
        for (pEnd = i + 1; pEnd < n + 1; pEnd = qEnd + i) {
          p = j;
          q = pEnd;
          qEnd = j + i2;
          if (qEnd > n + 1) {
            qEnd = n + 1;
          }

          b_k = 0;
          kEnd = qEnd - j;
          while (b_k + 1 <= kEnd) {
            b_tmp_tmp = offset + q;
            b = X_data[offset + iSorted_data[b_tmp_tmp]];
            i1 = offset + p;
            if ((X_data[offset + iSorted_data[i1]] <= b) || rtIsNaN(b)) {
              iwork_data[b_k] = iSorted_data[i1];
              p++;
              if (p == pEnd) {
                while (q < qEnd) {
                  b_k++;
                  iwork_data[b_k] = iSorted_data[offset + q];
                  q++;
                }
              }
            } else {
              iwork_data[b_k] = iSorted_data[b_tmp_tmp];
              q++;
              if (q == qEnd) {
                while (p < pEnd) {
                  b_k++;
                  iwork_data[b_k] = iSorted_data[offset + p];
                  p++;
                }
              }
            }

            b_k++;
          }

          for (b_k = 0; b_k < kEnd; b_k++) {
            iSorted_data[(offset + j) + b_k] = iwork_data[b_k];
          }

          j = qEnd;
        }

        i = i2;
      }
    }
  }

  loopBody(X_data, X_size, startInput, iSorted_data, iSorted_size, &b,
           idxbest_data, idxbest_size, Cbest);
}

static void loopBody(const double X_data[], const int X_size[2], const double
                     Cinput[56], const int iSorted_data[], const int
                     iSorted_size[2], double *totsumD, int idx_data[], int
                     idx_size[1], double C[56])
{
  int n;
  int cr;
  int D_size[2];
  int crows[8];
  double D_data[4096];
  int b_n;
  int i;
  double d_data[512];
  int d_size[1];
  int r;
  int j;
  signed char nonEmpties[8];
  boolean_T converged;
  int D_data_tmp;
  int cr_tmp;
  double sumD[8];
  n = X_size[0] - 1;
  for (cr = 0; cr < 8; cr++) {
    crows[cr] = cr + 1;
  }

  D_size[0] = X_size[0];
  D_size[1] = 8;
  cr = X_size[0] << 3;
  if (0 <= cr - 1) {
    memset(&D_data[0], 0, cr * sizeof(double));
  }

  b_n = X_size[0] - 1;
  for (i = 0; i < 8; i++) {
    cr = crows[i] - 1;
    for (r = 0; r <= b_n; r++) {
      D_data[r + D_size[0] * cr] = fabs(X_data[r] - Cinput[crows[i] - 1]);
    }

    for (j = 0; j < 6; j++) {
      for (r = 0; r <= b_n; r++) {
        D_data_tmp = r + D_size[0] * cr;
        D_data[D_data_tmp] += fabs(X_data[r + X_size[0] * (j + 1)] - Cinput[cr +
          ((j + 1) << 3)]);
      }
    }

    crows[i] = 0;
  }

  mindim2(D_data, D_size, d_data, d_size, idx_data, idx_size);
  for (i = 0; i <= n; i++) {
    crows[idx_data[i] - 1]++;
  }

  for (i = 0; i < 8; i++) {
    nonEmpties[i] = 0;
  }

  memcpy(&C[0], &Cinput[0], 56U * sizeof(double));
  batchUpdate(X_data, X_size, idx_data, idx_size, C, D_data, D_size, crows,
              iSorted_data, iSorted_size, &converged, &cr);
  cr = -1;
  for (i = 0; i < 8; i++) {
    if (crows[i] > 0) {
      cr++;
      nonEmpties[cr] = (signed char)(i + 1);
    }
  }

  b_n = X_size[0] - 1;
  for (i = 0; i <= cr; i++) {
    cr_tmp = nonEmpties[i] - 1;
    for (r = 0; r <= b_n; r++) {
      D_data[r + D_size[0] * cr_tmp] = fabs(X_data[r] - C[cr_tmp]);
    }

    for (j = 0; j < 6; j++) {
      for (r = 0; r <= b_n; r++) {
        D_data_tmp = r + D_size[0] * cr_tmp;
        D_data[D_data_tmp] += fabs(X_data[r + X_size[0] * (j + 1)] - C[cr_tmp +
          ((j + 1) << 3)]);
      }
    }
  }

  for (i = 0; i <= n; i++) {
    d_data[i] = D_data[i + D_size[0] * (idx_data[i] - 1)];
  }

  memset(&sumD[0], 0, 8U * sizeof(double));
  for (i = 0; i <= n; i++) {
    sumD[idx_data[i] - 1] += d_data[i];
  }

  *totsumD = 0.0;
  for (i = 0; i <= cr; i++) {
    *totsumD += sumD[nonEmpties[i] - 1];
  }
}

static void mindim2(const double D_data[], const int D_size[2], double d_data[],
                    int d_size[1], int idx_data[], int idx_size[1])
{
  int n;
  int loop_ub;
  int i;
  double d;
  n = D_size[0];
  d_size[0] = (short)D_size[0];
  loop_ub = (short)D_size[0];
  for (i = 0; i < loop_ub; i++) {
    d_data[i] = rtInf;
  }

  idx_size[0] = D_size[0];
  loop_ub = D_size[0];
  for (i = 0; i < loop_ub; i++) {
    idx_data[i] = 1;
  }

  for (loop_ub = 0; loop_ub < 8; loop_ub++) {
    for (i = 0; i < n; i++) {
      d = D_data[i + D_size[0] * loop_ub];
      if (d < d_data[i]) {
        idx_data[i] = loop_ub + 1;
        d_data[i] = d;
      }
    }
  }
}

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

void refModel2(const short inputMatrix[3584], const short inputCent[56], short
               finalCent[56])
{
  int i2;
  int i;
  boolean_T c[3584];
  boolean_T zeroRowsVector[512];
  int i1;
  int j;
  int ix;
  boolean_T exitg1;
  double initialCent[56];
  int inputMatrix_size[2];
  double inputMatrix_data[3584];
  double idx_data[512];
  int idx_size[1];
  double R_round[56];
  double u;
  double v;
  short b_i;

  /* Summary of this function goes here */
  /*    This function receives a fi matrix and a fi vector of 7 columns , where each line */
  /*    represents a point in the 7 dim, represented in fixed point(MSB sign, 2 */
  /*    integer bits and 10 fractional bits) */
  /*    It converts the matrix and vector to double, does k means on the matrix with initial values as in the vector */
  /*    and returns the 8 centroids in a vector, also in fixed point */
  /*     */
  /*  convert matrix to double */
  /* codegen */
  /* cut the rows which are 0 */
  for (i2 = 0; i2 < 3584; i2++) {
    c[i2] = (inputMatrix[i2] == 0);
  }

  for (i = 0; i < 512; i++) {
    zeroRowsVector[i] = true;
  }

  i = -1;
  i1 = 0;
  i2 = 3072;
  for (j = 0; j < 512; j++) {
    i1++;
    i2++;
    i++;
    ix = i1;
    exitg1 = false;
    while ((!exitg1) && (ix <= i2)) {
      if (!c[ix - 1]) {
        zeroRowsVector[i] = false;
        exitg1 = true;
      } else {
        ix += 512;
      }
    }
  }

  i = zeroRowsVector[0];
  for (i1 = 0; i1 < 511; i1++) {
    i += zeroRowsVector[i1 + 1];
  }

  if (1.0 > 512.0 - (double)i) {
    i = 0;
  } else {
    i = 512 - i;
  }

  for (i2 = 0; i2 < 56; i2++) {
    initialCent[i2] = (double)inputCent[i2] * 0.0009765625;
  }

  /*  do k means */
  inputMatrix_size[0] = i;
  inputMatrix_size[1] = 7;
  for (i2 = 0; i2 < 7; i2++) {
    for (i1 = 0; i1 < i; i1++) {
      inputMatrix_data[i1 + i * i2] = (double)inputMatrix[i1 + (i2 << 9)] *
        0.0009765625;
    }
  }

  kmeans(inputMatrix_data, inputMatrix_size, initialCent, idx_data, idx_size,
         R_round);

  /* round like this duo to code gen limitation : "Code generation supports only the syntax Y = round(X)." */
  for (i1 = 0; i1 < 56; i1++) {
    R_round[i1] = rt_roundd_snf(R_round[i1] * 1000.0) / 1000.0;
  }

  for (i = 0; i < 8; i++) {
    for (i1 = 0; i1 < 7; i1++) {
      i2 = i + (i1 << 3);
      if (rtIsNaN(R_round[i2])) {
        R_round[i2] = initialCent[i2];
      }
    }
  }

  /*  convert centroid vector to fixed point */
  for (i2 = 0; i2 < 56; i2++) {
    u = R_round[i2] * 1024.0;
    v = fabs(u);
    if (v < 4.503599627370496E+15) {
      if (v >= 0.5) {
        u = floor(u + 0.5);
      } else {
        u *= 0.0;
      }
    }

    if (u < 4096.0) {
      if (u >= -4096.0) {
        b_i = (short)u;
      } else {
        b_i = -4096;
      }
    } else if (u >= 4096.0) {
      b_i = 4095;
    } else {
      b_i = 0;
    }

    finalCent[i2] = b_i;
  }
}

void refModel2_initialize(void)
{
  rt_InitInfAndNaN();
}

void refModel2_terminate(void)
{
  /* (no terminate code required) */
}

/* End of code generation (refModel2.c) */
