#include "Debug.h"
#include "iFloat.h"

/** @file iFloat.c
 *  @brief You will modify this file and implement nine functions
 *  @details Your implementation of the functions defined in iFloat.h.
 *  You may add other function if you find it helpful. Added function
 *  should be declared <b>static</b> to indicate they are only used
 *  within this file.
 *  <p>
 *  @author <b>Zachary Fuchs</b> goes here
 */

/* declaration for useful function contained in testFloat.c */
const char* getBinary (iFloat_t value);

/** @todo Implement based on documentation contained in iFloat.h */
iFloat_t floatGetSign (iFloat_t x) {
  return x >> 16 & 1;
}

/** @todo Implement based on documentation contained in iFloat.h */
iFloat_t floatGetExp (iFloat_t x) {
  return (x & 0x7C00) >> 10;
}

/** @todo Implement based on documentation contained in iFloat.h */
iFloat_t floatGetVal (iFloat_t x) {
  return floatGetSign(x) ? (~((x & 0x03FF) | 0x0400)) + 1 : (x & 0x03FF) | 0x0400;
}

/** @todo Implement based on documentation contained in iFloat.h */
void floatGetAll(iFloat_t x, iFloat_t* sign, iFloat_t* exp, iFloat_t* val) {
    *sign = floatGetSign(x);
    *exp = floatGetExp(x);
    *val = floatGetVal(x);
}

/** @todo Implement based on documentation contained in iFloat.h */
iFloat_t floatLeftMost1 (iFloat_t bits) {
    int mask = 1 << 15;
    if (bits == 0)
        return -1;
    for (int i = 0; i < 16; i++){
        if ((bits & (mask >> i)) != 0) {
            return 15-i;
        }
    }
    return -1;
}

/** @todo Implement based on documentation contained in iFloat.h */
iFloat_t floatAbs (iFloat_t x) {
  return x & 0x7FFF;
}

/** @todo Implement based on documentation contained in iFloat.h */
iFloat_t floatNegate (iFloat_t x) {
  return x != 0 ? (floatGetSign(x) ? x & 0x7FFF : x | 0x8000) : 0;
}

/** @todo Implement based on documentation contained in iFloat.h */
iFloat_t floatAdd (iFloat_t x, iFloat_t y) {
    iFloat_t xVal, yVal, xExp, yExp, xSign, ySign, expDiff, retVal, retSign = 0, retExp = 0;
    floatGetAll(x, &xSign, &xExp, &xVal);
    floatGetAll(y, &ySign, &yExp, &yVal);       // Step 1: Get Values and Exponents
    
    debug("Value x: %s\n",getBinary(x));
    debug("Value y: %s\n",getBinary(y));
    debug("xVal: %s\n",getBinary(xVal));
    debug("yVal: %s\n",getBinary(yVal));
    debug("xExp: %s\n",getBinary(xExp));
    debug("yExp: %s\n",getBinary(yExp));
    debug("xSign: %s\n",getBinary(xSign));
    debug("ySign: %s\n",getBinary(ySign));
    debug("\n STEP 1 DONE \n\n");
   if (x == 0 && y ==0) return 0; 
    
    if (xExp > yExp) {
        expDiff = xExp - yExp;
        retExp = yExp + expDiff;
        yVal = yVal >> expDiff;
    } else if (xExp < yExp) {
        expDiff = yExp - xExp;
        retExp = xExp + expDiff;
        xVal = xVal >> expDiff;
    } else {
        retExp = xExp;
    }                                           // Step 2: Equalize the exponents
    
    debug("xVal: %s\n",getBinary(xVal));
    debug("yVal: %s\n",getBinary(yVal));
    debug("xExp: %s\n",getBinary(xExp));
    debug("yExp: %s\n",getBinary(yExp));
    debug("retExp: %s\n",getBinary(retExp));
    debug("\n STEP 2 DONE\n\n");
    
    
    retVal = xVal + yVal;                       // Step 3: Integer Addition of xVal and yVal
    
    debug("retVal: %s\n",getBinary(retVal));
    debug("\n STEP 3 DONE\n\n");
    
    if (retVal < 0) {
        retVal = ~retVal + 1;
        retSign = 1;
    }                                           // Step 4: Convert the two's complement back to sign magnitude
    
    
    debug("retVal: %s\n",getBinary(retVal));
    debug("retSign: %s\n",getBinary(retSign));
    debug("retExp: %s\n",getBinary(retExp));
    debug("\n STEP 4 DONE\n\n");
    
    iFloat_t lm1 = floatLeftMost1(retVal);
    debug("lm1: %d\n",lm1);
    if (lm1 != 10) {
        iFloat_t shift;
        if (lm1 == -1){
            retExp = 0;
        } else if (lm1 > 10) {
            shift = lm1-10;
            retVal = retVal >> shift;
            retExp += shift;            
        } else {
            shift = 10-lm1;
            retVal = retVal << shift;
            retExp -= shift;
        }
    }                                           // Step 5: Normalize the result
    
    debug("retVal: %s\n",getBinary(retVal));
    debug("retExp: %s\n",getBinary(retExp));
    debug("\n STEP 5 DONE\n\n");
    
    retSign = retSign << 15;
    retExp = retExp << 10;
    retVal = retVal & 0x03FF;
    retVal = retVal | retSign | retExp;         // Step 6: Re-assmble all the components into a 16-bit value
    
    return retVal;
}

/** @todo Implement based on documentation contained in iFloat.h */
iFloat_t floatSub (iFloat_t x, iFloat_t y) {
  return y!=0 ? floatAdd(x,floatNegate(y)) : x;
}

