/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include files */
#include "main.h"
#include "refModel3.h"

/* Function Declarations */
static void argInit_512x7_sfix13_En10(short result[3584]);
static void argInit_8x7_sfix13_En10(short result[56]);
static short argInit_sfix13_En10(void);
static unsigned short argInit_ufix13(void);
static void main_refModel3(void);

/* Function Definitions */
static void argInit_512x7_sfix13_En10(short result[3584])
{
  int idx0;
  int idx1;

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 512; idx0++) {
    for (idx1 = 0; idx1 < 7; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result[idx1 + 7 * idx0] = argInit_sfix13_En10();
    }
  }
}

static void argInit_8x7_sfix13_En10(short result[56])
{
  int idx0;
  int idx1;

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 8; idx0++) {
    for (idx1 = 0; idx1 < 7; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result[idx1 + 7 * idx0] = argInit_sfix13_En10();
    }
  }
}

static short argInit_sfix13_En10(void)
{
  return 0;
}

static unsigned short argInit_ufix13(void)
{
  return 0U;
}

static void main_refModel3(void)
{
  short inputMatrix[3584];
  short inputCent[56];
  short inputThreshold;
  unsigned short inputFirstPoint_tmp;
  short finalCent[56];

  /* Initialize function 'refModel3' input arguments. */
  /* Initialize function input argument 'inputMatrix'. */
  argInit_512x7_sfix13_En10(inputMatrix);

  /* Initialize function input argument 'inputCent'. */
  argInit_8x7_sfix13_En10(inputCent);
  inputThreshold = argInit_sfix13_En10();
  inputFirstPoint_tmp = argInit_ufix13();

  /* Call the entry-point 'refModel3'. */
  refModel3(inputMatrix, inputCent, inputThreshold, inputFirstPoint_tmp,
            inputFirstPoint_tmp, finalCent);
}

int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  refModel3_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_refModel3();

  /* Terminate the application.
     You do not need to do this more than one time. */
  refModel3_terminate();
  return 0;
}

/* End of code generation (main.c) */
