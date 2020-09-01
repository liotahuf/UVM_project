/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_refModel2_api.c
 *
 * Code generation for function '_coder_refModel2_api'
 *
 */

/* Include files */
#include "_coder_refModel2_api.h"
#include "_coder_refModel2_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
static const mxArray *eml_mx;
static const mxArray *b_eml_mx;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131483U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "refModel2",                         /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

static emlrtMCInfo emlrtMCI = { -1,    /* lineNo */
  -1,                                  /* colNo */
  "",                                  /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, int16_T y[3584]);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *inputCent,
  const char_T *identifier, int16_T y[56]);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, int16_T y[56]);
static void e_emlrt_marshallIn(const mxArray *src, int16_T ret[3584]);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *inputMatrix,
  const char_T *identifier, int16_T y[3584]);
static const mxArray *emlrt_marshallOut(const emlrtStack *sp, const int16_T u[56]);
static void f_emlrt_marshallIn(const mxArray *src, int16_T ret[56]);
static const mxArray *fimath(const emlrtStack *sp, const char * b, const char
  * c, const char * d, const char * e, const char * f, const char * g, const
  char * h, const char * i, const char * j, const char * k, const char * l,
  const char * m, const char * n, real_T o, const char * p, real_T q, const char
  * r, real_T s, const char * t, real_T u, const char * v, real_T w, const char *
  x, real_T y, const char * ab, real_T bb, const char * cb, real_T db, const
  char * eb, real_T fb, const char * gb, real_T hb, const char * ib, real_T jb,
  const char * kb, real_T lb, const char * mb, boolean_T nb, const char * ob,
  real_T pb, const char * qb, real_T rb, emlrtMCInfo *location);
static const mxArray *numerictype(const emlrtStack *sp, const char * b, real_T c,
  const char * d, real_T e, const char * f, real_T g, const char * h, real_T i,
  const char * j, real_T k, emlrtMCInfo *location);
static void refModel2_once(const emlrtStack *sp);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, int16_T y[3584])
{
  static const int32_T dims[2] = { 512, 7 };

  emlrtCheckFiR2012b(sp, parentId, u, false, 2U, dims, eml_mx, b_eml_mx);
  e_emlrt_marshallIn(emlrtAlias(u), y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *inputCent,
  const char_T *identifier, int16_T y[56])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  d_emlrt_marshallIn(sp, emlrtAlias(inputCent), &thisId, y);
  emlrtDestroyArray(&inputCent);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, int16_T y[56])
{
  static const int32_T dims[2] = { 8, 7 };

  emlrtCheckFiR2012b(sp, parentId, u, false, 2U, dims, eml_mx, b_eml_mx);
  f_emlrt_marshallIn(emlrtAlias(u), y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const mxArray *src, int16_T ret[3584])
{
  const mxArray *mxInt;
  int16_T (*r)[3584];
  int32_T i;
  mxInt = emlrtImportFiIntArrayR2008b(src);
  r = (int16_T (*)[3584])emlrtMxGetData(mxInt);
  for (i = 0; i < 3584; i++) {
    ret[i] = (*r)[i];
  }

  emlrtDestroyArray(&mxInt);
  emlrtDestroyArray(&src);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *inputMatrix,
  const char_T *identifier, int16_T y[3584])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(inputMatrix), &thisId, y);
  emlrtDestroyArray(&inputMatrix);
}

static const mxArray *emlrt_marshallOut(const emlrtStack *sp, const int16_T u[56])
{
  const mxArray *y;
  const mxArray *b_y;
  const mxArray *m;
  static const int32_T iv[2] = { 8, 7 };

  int16_T *pData;
  int32_T i;
  int32_T b_i;
  int32_T c_i;
  y = NULL;
  b_y = NULL;
  m = emlrtCreateNumericArray(2, iv, mxINT16_CLASS, mxREAL);
  pData = (int16_T *)emlrtMxGetData(m);
  i = 0;
  for (b_i = 0; b_i < 7; b_i++) {
    for (c_i = 0; c_i < 8; c_i++) {
      pData[i] = u[c_i + (b_i << 3)];
      i++;
    }
  }

  emlrtAssign(&b_y, m);
  emlrtAssign(&y, emlrtCreateFIR2013b(sp, eml_mx, b_eml_mx, "simulinkarray", b_y,
    false, false));
  return y;
}

static void f_emlrt_marshallIn(const mxArray *src, int16_T ret[56])
{
  const mxArray *mxInt;
  int16_T (*r)[56];
  int32_T i;
  mxInt = emlrtImportFiIntArrayR2008b(src);
  r = (int16_T (*)[56])emlrtMxGetData(mxInt);
  for (i = 0; i < 56; i++) {
    ret[i] = (*r)[i];
  }

  emlrtDestroyArray(&mxInt);
  emlrtDestroyArray(&src);
}

static const mxArray *fimath(const emlrtStack *sp, const char * b, const char
  * c, const char * d, const char * e, const char * f, const char * g, const
  char * h, const char * i, const char * j, const char * k, const char * l,
  const char * m, const char * n, real_T o, const char * p, real_T q, const char
  * r, real_T s, const char * t, real_T u, const char * v, real_T w, const char *
  x, real_T y, const char * ab, real_T bb, const char * cb, real_T db, const
  char * eb, real_T fb, const char * gb, real_T hb, const char * ib, real_T jb,
  const char * kb, real_T lb, const char * mb, boolean_T nb, const char * ob,
  real_T pb, const char * qb, real_T rb, emlrtMCInfo *location)
{
  const mxArray *pArrays[42];
  const mxArray *b_m;
  pArrays[0] = emlrtCreateString(b);
  pArrays[1] = emlrtCreateString(c);
  pArrays[2] = emlrtCreateString(d);
  pArrays[3] = emlrtCreateString(e);
  pArrays[4] = emlrtCreateString(f);
  pArrays[5] = emlrtCreateString(g);
  pArrays[6] = emlrtCreateString(h);
  pArrays[7] = emlrtCreateString(i);
  pArrays[8] = emlrtCreateString(j);
  pArrays[9] = emlrtCreateString(k);
  pArrays[10] = emlrtCreateString(l);
  pArrays[11] = emlrtCreateString(m);
  pArrays[12] = emlrtCreateString(n);
  pArrays[13] = emlrtCreateDoubleScalar(o);
  pArrays[14] = emlrtCreateString(p);
  pArrays[15] = emlrtCreateDoubleScalar(q);
  pArrays[16] = emlrtCreateString(r);
  pArrays[17] = emlrtCreateDoubleScalar(s);
  pArrays[18] = emlrtCreateString(t);
  pArrays[19] = emlrtCreateDoubleScalar(u);
  pArrays[20] = emlrtCreateString(v);
  pArrays[21] = emlrtCreateDoubleScalar(w);
  pArrays[22] = emlrtCreateString(x);
  pArrays[23] = emlrtCreateDoubleScalar(y);
  pArrays[24] = emlrtCreateString(ab);
  pArrays[25] = emlrtCreateDoubleScalar(bb);
  pArrays[26] = emlrtCreateString(cb);
  pArrays[27] = emlrtCreateDoubleScalar(db);
  pArrays[28] = emlrtCreateString(eb);
  pArrays[29] = emlrtCreateDoubleScalar(fb);
  pArrays[30] = emlrtCreateString(gb);
  pArrays[31] = emlrtCreateDoubleScalar(hb);
  pArrays[32] = emlrtCreateString(ib);
  pArrays[33] = emlrtCreateDoubleScalar(jb);
  pArrays[34] = emlrtCreateString(kb);
  pArrays[35] = emlrtCreateDoubleScalar(lb);
  pArrays[36] = emlrtCreateString(mb);
  pArrays[37] = emlrtCreateLogicalScalar(nb);
  pArrays[38] = emlrtCreateString(ob);
  pArrays[39] = emlrtCreateDoubleScalar(pb);
  pArrays[40] = emlrtCreateString(qb);
  pArrays[41] = emlrtCreateDoubleScalar(rb);
  return emlrtCallMATLABR2012b(sp, 1, &b_m, 42, pArrays, "fimath", true,
    location);
}

static const mxArray *numerictype(const emlrtStack *sp, const char * b, real_T c,
  const char * d, real_T e, const char * f, real_T g, const char * h, real_T i,
  const char * j, real_T k, emlrtMCInfo *location)
{
  const mxArray *pArrays[10];
  const mxArray *m;
  pArrays[0] = emlrtCreateString(b);
  pArrays[1] = emlrtCreateDoubleScalar(c);
  pArrays[2] = emlrtCreateString(d);
  pArrays[3] = emlrtCreateDoubleScalar(e);
  pArrays[4] = emlrtCreateString(f);
  pArrays[5] = emlrtCreateDoubleScalar(g);
  pArrays[6] = emlrtCreateString(h);
  pArrays[7] = emlrtCreateDoubleScalar(i);
  pArrays[8] = emlrtCreateString(j);
  pArrays[9] = emlrtCreateDoubleScalar(k);
  return emlrtCallMATLABR2012b(sp, 1, &m, 10, pArrays, "numerictype", true,
    location);
}

static void refModel2_once(const emlrtStack *sp)
{
  emlrtAssignP(&b_eml_mx, NULL);
  emlrtAssignP(&eml_mx, NULL);
  emlrtAssignP(&b_eml_mx, numerictype(sp, "WordLength", 13.0, "FractionLength",
    10.0, "BinaryPoint", 10.0, "Slope", 0.0009765625, "FixedExponent", -10.0,
    &emlrtMCI));
  emlrtAssignP(&eml_mx, fimath(sp, "RoundMode", "nearest", "RoundingMethod",
    "Nearest", "OverflowMode", "saturate", "OverflowAction", "Saturate",
    "ProductMode", "FullPrecision", "SumMode", "FullPrecision",
    "ProductWordLength", 32.0, "SumWordLength", 32.0, "MaxProductWordLength",
    65535.0, "MaxSumWordLength", 65535.0, "ProductFractionLength", 30.0,
    "ProductFixedExponent", -30.0, "SumFractionLength", 30.0, "SumFixedExponent",
    -30.0, "SumSlopeAdjustmentFactor", 1.0, "SumBias", 0.0,
    "ProductSlopeAdjustmentFactor", 1.0, "ProductBias", 0.0, "CastBeforeSum",
    true, "SumSlope", 9.3132257461547852E-10, "ProductSlope",
    9.3132257461547852E-10, &emlrtMCI));
  emlrtCheckDefaultFimathR2008b(&eml_mx);
}

void refModel2_api(const mxArray * const prhs[2], int32_T nlhs, const mxArray
                   *plhs[1])
{
  int16_T inputMatrix[3584];
  int16_T inputCent[56];
  int16_T finalCent[56];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  (void)nlhs;
  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "inputMatrix", inputMatrix);
  c_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "inputCent", inputCent);

  /* Invoke the target function */
  refModel2(inputMatrix, inputCent, finalCent);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(&st, finalCent);
}

void refModel2_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  refModel2_xil_terminate();
  refModel2_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
  emlrtDestroyArray(&eml_mx);
  emlrtDestroyArray(&b_eml_mx);
}

void refModel2_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 3U, "ForceOff");
  emlrtEnterRtStackR2012b(&st);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    refModel2_once(&st);
  }
}

void refModel2_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (_coder_refModel2_api.c) */
