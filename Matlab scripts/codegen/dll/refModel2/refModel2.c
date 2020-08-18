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
static void all(const boolean_T x[3584], boolean_T y[512]);
static void b_mergesort(int idx_data[], const double x_data[], int n);
static void batchUpdate(const double X_data[], const int X_size[2], int
  idx_data[], int idx_size[1], double C[56], double D_data[], const int D_size[2],
  int counts[8], const int iSorted_data[], boolean_T *converged, int *iter);
static int findchanged(int changed[8], const int idx_data[], const int
  previdx_data[], const int moved_data[], const int moved_size[1], int nmoved);
static void gcentroids(double C[56], int counts[8], const double X_data[], const
  int X_size[2], const int idx_data[], const int clusters[8], int nclusters,
  const int iSorted_data[]);
static void kmeans(double X_data[], int X_size[2], const double varargin_6[56],
                   double idxbest_data[], int idxbest_size[1], double Cbest[56]);
static void local_kmeans(const double X_data[], const int X_size[2], const
  double startInput[56], int idxbest_data[], int idxbest_size[1], double Cbest
  [56]);
static void loopBody(const double X_data[], const int X_size[2], const double
                     Cinput[56], const int iSorted_data[], double *totsumD, int
                     idx_data[], int idx_size[1], double C[56]);
static void mindim2(const double D_data[], const int D_size[2], double d_data[],
                    int d_size[1], int idx_data[], int idx_size[1]);
static double rt_roundd_snf(double u);

/* Function Definitions */
static void all(const boolean_T x[3584], boolean_T y[512])
{
  int k;
  int b_k;
  boolean_T exitg1;
  memset(&y[0], 0, 512U * sizeof(boolean_T));
  for (k = 0; k < 512; k++) {
    y[k] = true;
    b_k = 0;
    exitg1 = false;
    while ((!exitg1) && (b_k < 7)) {
      if (!x[b_k + 7 * k]) {
        y[k] = false;
        exitg1 = true;
      } else {
        b_k++;
      }
    }
  }
}

static void b_mergesort(int idx_data[], const double x_data[], int n)
{
  int i;
  int k;
  int i2;
  int j;
  int pEnd;
  int p;
  int q;
  int qEnd;
  int kEnd;
  double d;
  int iwork_data[512];
  i = n - 1;
  for (k = 1; k <= i; k += 2) {
    if ((x_data[k - 1] <= x_data[k]) || rtIsNaN(x_data[k])) {
      idx_data[k - 1] = k;
      idx_data[k] = k + 1;
    } else {
      idx_data[k - 1] = k + 1;
      idx_data[k] = k;
    }
  }

  if ((n & 1) != 0) {
    idx_data[n - 1] = n;
  }

  i = 2;
  while (i < n) {
    i2 = i << 1;
    j = 1;
    for (pEnd = i + 1; pEnd < n + 1; pEnd = qEnd + i) {
      p = j;
      q = pEnd - 1;
      qEnd = j + i2;
      if (qEnd > n + 1) {
        qEnd = n + 1;
      }

      k = 0;
      kEnd = qEnd - j;
      while (k + 1 <= kEnd) {
        d = x_data[idx_data[q] - 1];
        if ((x_data[idx_data[p - 1] - 1] <= d) || rtIsNaN(d)) {
          iwork_data[k] = idx_data[p - 1];
          p++;
          if (p == pEnd) {
            while (q + 1 < qEnd) {
              k++;
              iwork_data[k] = idx_data[q];
              q++;
            }
          }
        } else {
          iwork_data[k] = idx_data[q];
          q++;
          if (q + 1 == qEnd) {
            while (p < pEnd) {
              k++;
              iwork_data[k] = idx_data[p - 1];
              p++;
            }
          }
        }

        k++;
      }

      for (k = 0; k < kEnd; k++) {
        idx_data[(j + k) - 1] = iwork_data[k];
      }

      j = qEnd;
    }

    i = i2;
  }
}

static void batchUpdate(const double X_data[], const int X_size[2], int
  idx_data[], int idx_size[1], double C[56], double D_data[], const int D_size[2],
  int counts[8], const int iSorted_data[], boolean_T *converged, int *iter)
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
               iSorted_data);
    b_n = X_size[0] - 1;
    for (i = 0; i < nchanged; i++) {
      cr = changed[i] - 1;
      for (r = 0; r <= b_n; r++) {
        D_data[cr + 8 * r] = fabs(X_data[7 * r] - C[7 * (changed[i] - 1)]);
      }

      for (j = 0; j < 6; j++) {
        for (r = 0; r <= b_n; r++) {
          b_i = cr + 8 * r;
          D_data[b_i] += fabs(X_data[(j + 7 * r) + 1] - C[(j + 7 * cr) + 1]);
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
          D_data[(empties[j] + 8 * i) - 1] = rtNaN;
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
      totsumD += D_data[(idx_data[i] + 8 * i) - 1];
    }

    if (prevtotsumD <= totsumD) {
      idx_size[0] = previdx_size_idx_0;
      if (0 <= previdx_size_idx_0 - 1) {
        memcpy(&idx_data[0], &previdx_data[0], previdx_size_idx_0 * sizeof(int));
      }

      gcentroids(C, counts, X_data, X_size, previdx_data, changed, nchanged,
                 iSorted_data);
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
        if ((nidx_data[i] != previdx_data[i]) && (D_data[(previdx_data[i] + 8 *
              i) - 1] > d_data[i])) {
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
  const int iSorted_data[])
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
  boolean_T exitg1;
  n = X_size[0] - 1;
  for (ic = 0; ic < nclusters; ic++) {
    counts[clusters[ic] - 1] = 0;
    for (j = 0; j < 7; j++) {
      C[j + 7 * (clusters[ic] - 1)] = rtNaN;
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
    cc = counts[clusters[ic] - 1];
    if (cc == 0) {
      ndone += 7;
    } else if (cc == 1) {
      lowerCount[clusters[ic] - 1] = 1;
      upperCount[clusters[ic] - 1] = 1;
      medianCount[clusters[ic] - 1] = 1;
    } else if ((cc & 1) != 0) {
      cc = counts[clusters[ic] - 1] >> 1;
      lowerCount[clusters[ic] - 1] = cc;
      upperCount[clusters[ic] - 1] = cc + 2;
      medianCount[clusters[ic] - 1] = cc + 1;
    } else {
      cc >>= 1;
      lowerCount[clusters[ic] - 1] = cc;
      upperCount[clusters[ic] - 1] = cc + 1;
    }
  }

  for (i = 0; i < n; i++) {
    j = 0;
    exitg1 = false;
    while ((!exitg1) && (j < 7)) {
      cc = iSorted_data[j + 7 * i] - 1;
      ic = j + 7 * (idx_data[cc] - 1);
      idxCount[ic]++;
      if (idxCount[ic] == lowerCount[idx_data[cc] - 1]) {
        lowerRowIndex[ic] = (short)(cc + 1);
      }

      if (idxCount[ic] == medianCount[idx_data[cc] - 1]) {
        medianRowIndex[ic] = (short)(cc + 1);
      }

      if (idxCount[ic] == upperCount[idx_data[cc] - 1]) {
        upperRowIndex[ic] = (short)(cc + 1);
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
      cc = j + 7 * (clusters[ic] - 1);
      if (lowerRowIndex[cc] == 0) {
        C[cc] = rtNaN;
      } else if (medianRowIndex[cc] == 0) {
        C[cc] = 0.5 * (X_data[j + 7 * (lowerRowIndex[cc] - 1)] + X_data[j + 7 *
                       (upperRowIndex[cc] - 1)]);
      } else {
        C[cc] = X_data[j + 7 * (medianRowIndex[cc] - 1)];
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
      if (rtIsNaN(X_data[loop_ub + 7 * i])) {
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

    for (partialTrueCount = 0; partialTrueCount < trueCount; partialTrueCount++)
    {
      for (loop_ub = 0; loop_ub < 7; loop_ub++) {
        b_X_data[loop_ub + 7 * partialTrueCount] = X_data[loop_ub + 7 *
          (idx_data[partialTrueCount] - 1)];
      }
    }

    X_size[1] = 7;
    X_size[0] = trueCount;
    loop_ub = 7 * trueCount;
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
  short unnamed_idx_0;
  int iSorted_size_idx_0;
  int loop_ub;
  int iSorted_data[3584];
  double totsumDbest;
  int k;
  int i;
  int tmp_data[512];
  double b_X_data[512];
  unnamed_idx_0 = (short)X_size[0];
  iSorted_size_idx_0 = unnamed_idx_0;
  loop_ub = 7 * unnamed_idx_0;
  if (0 <= loop_ub - 1) {
    memset(&iSorted_data[0], 0, loop_ub * sizeof(int));
  }

  if (X_size[0] != 0) {
    loop_ub = X_size[0];
    for (k = 0; k < 7; k++) {
      for (i = 0; i < iSorted_size_idx_0; i++) {
        tmp_data[i] = iSorted_data[k + 7 * i];
      }

      for (i = 0; i < loop_ub; i++) {
        b_X_data[i] = X_data[k + 7 * i];
      }

      b_mergesort(tmp_data, b_X_data, X_size[0]);
      for (i = 0; i < iSorted_size_idx_0; i++) {
        iSorted_data[k + 7 * i] = tmp_data[i];
      }
    }
  }

  loopBody(X_data, X_size, startInput, iSorted_data, &totsumDbest, idxbest_data,
           idxbest_size, Cbest);
}

static void loopBody(const double X_data[], const int X_size[2], const double
                     Cinput[56], const int iSorted_data[], double *totsumD, int
                     idx_data[], int idx_size[1], double C[56])
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

  D_size[1] = 8;
  D_size[0] = X_size[0];
  cr = X_size[0] << 3;
  if (0 <= cr - 1) {
    memset(&D_data[0], 0, cr * sizeof(double));
  }

  b_n = X_size[0] - 1;
  for (i = 0; i < 8; i++) {
    cr = crows[i] - 1;
    for (r = 0; r <= b_n; r++) {
      D_data[cr + 8 * r] = fabs(X_data[7 * r] - Cinput[7 * (crows[i] - 1)]);
    }

    for (j = 0; j < 6; j++) {
      for (r = 0; r <= b_n; r++) {
        D_data_tmp = cr + 8 * r;
        D_data[D_data_tmp] += fabs(X_data[(j + 7 * r) + 1] - Cinput[(j + 7 * cr)
          + 1]);
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
              iSorted_data, &converged, &cr);
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
      D_data[cr_tmp + 8 * r] = fabs(X_data[7 * r] - C[7 * cr_tmp]);
    }

    for (j = 0; j < 6; j++) {
      for (r = 0; r <= b_n; r++) {
        D_data_tmp = cr_tmp + 8 * r;
        D_data[D_data_tmp] += fabs(X_data[(j + 7 * r) + 1] - C[(j + 7 * cr_tmp)
          + 1]);
      }
    }
  }

  for (i = 0; i <= n; i++) {
    d_data[i] = D_data[(idx_data[i] + 8 * i) - 1];
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
      d = D_data[loop_ub + 8 * i];
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
  int i;
  boolean_T b_inputMatrix[3584];
  boolean_T x[512];
  int y;
  int k;
  double initialCent[56];
  int inputMatrix_size[2];
  double inputMatrix_data[3584];
  double idx_data[512];
  int idx_size[1];
  double R_round[56];
  int R_round_tmp;
  double u;
  double v;
  short i1;

  /* Summary of this function goes here */
  /*    This function receives a fi matrix and a fi vector of 7 columns , where each line */
  /*    represents a point in the 7 dim, represented in fixed point(MSB sign, 2 */
  /*    integer bits and 10 fractional bits) */
  /*    It converts the matrix and vector to double, does k means on the matrix with initial values as in the vector */
  /*    and returns the 8 centroids in a vector, also in fixed point */
  /*     */
  /*  convert matrix to double */
  /* cut the rows which are 0 */
  for (i = 0; i < 3584; i++) {
    b_inputMatrix[i] = (inputMatrix[i] == 0);
  }

  all(b_inputMatrix, x);
  y = x[0];
  for (k = 0; k < 511; k++) {
    y += x[k + 1];
  }

  if (1.0 > 512.0 - (double)y) {
    y = 0;
  } else {
    y = 512 - y;
  }

  for (i = 0; i < 56; i++) {
    initialCent[i] = (double)inputCent[i] * 0.0009765625;
  }

  /*  do k means */
  inputMatrix_size[1] = 7;
  inputMatrix_size[0] = y;
  for (i = 0; i < y; i++) {
    for (R_round_tmp = 0; R_round_tmp < 7; R_round_tmp++) {
      k = R_round_tmp + 7 * i;
      inputMatrix_data[k] = (double)inputMatrix[k] * 0.0009765625;
    }
  }

  kmeans(inputMatrix_data, inputMatrix_size, initialCent, idx_data, idx_size,
         R_round);

  /* round like this duo to code gen limitation : "Code generation supports only the syntax Y = round(X)." */
  for (i = 0; i < 56; i++) {
    R_round[i] *= 1000.0;
  }

  for (k = 0; k < 8; k++) {
    for (y = 0; y < 7; y++) {
      R_round_tmp = y + 7 * k;
      R_round[R_round_tmp] = rt_roundd_snf(R_round[R_round_tmp]);
    }
  }

  for (i = 0; i < 56; i++) {
    R_round[i] /= 1000.0;
  }

  for (y = 0; y < 8; y++) {
    for (R_round_tmp = 0; R_round_tmp < 7; R_round_tmp++) {
      i = R_round_tmp + 7 * y;
      if (rtIsNaN(R_round[i])) {
        R_round[i] = initialCent[i];
      }
    }
  }

  /*  convert centroid vector to fixed point */
  for (i = 0; i < 56; i++) {
    u = R_round[i] * 1024.0;
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
        i1 = (short)u;
      } else {
        i1 = -4096;
      }
    } else if (u >= 4096.0) {
      i1 = 4095;
    } else {
      i1 = 0;
    }

    finalCent[i] = i1;
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
