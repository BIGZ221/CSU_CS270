/**
 *  @author  Zachary Fuchs
 */

#include <stdio.h>

/** @todo implement in <code>numconv.c</code> based on documentation contained 
 *  in <code>numconv.h</code>.
 */
char int2char (int radix, int value) {
  if (value >= radix)  return '?';
  if (value+48 > 57){
        return value+55;
    } else {
        return value+48;
    }
}

/** @todo implement in <code>numconv.c</code> based on documentation contained 
 *  in <code>numconv.h</code>.
 */
int char2int (int radix, char digit) {
  if (122 >= digit && digit >=97) digit -= 32;
  if (57 >= digit && digit >= 48 && digit-48 < radix) return digit-48;
  if (90 >= digit && digit >= 65 && digit-55 < radix) return digit-55;
  return -1;
}

/** @todo implement in <code>numconv.c</code> based on documentation contained 
 *  in <code>numconv.h</code>.
 */
void divRem (int numerator, int divisor, int* quotient, int* remainder) {
  *quotient = 0;
  while (numerator >= divisor){
    numerator -= divisor;
    *quotient += 1;
  }  
  *remainder = numerator;
}

/** @todo implement in <code>numconv.c</code> based on documentation contained 
 *  in <code>numconv.h</code>.
 */
int ascii2int (int radix, int valueOfPrefix) {
  char currChar = getchar();
  if (currChar == '\n') return valueOfPrefix;
  return ascii2int(radix, valueOfPrefix*radix+char2int(radix,currChar));
}

/** @todo implement in <code>numconv.c</code> based on documentation contained 
 *  in <code>numconv.h</code>.
 */
void int2ascii (int radix, int value) {
  int quotient = 0;
  int remainder = 0;
  divRem(value,radix,&quotient,&remainder);
  if (quotient != 0) int2ascii(radix,quotient);
  putchar(int2char(radix, remainder));
}

/** @todo implement in <code>numconv.c</code> based on documentation contained 
 *  in <code>numconv.h</code>.
 */
double frac2double (int radix) {
  char currChar = getchar();
  if (currChar == '\n') return 0;
  return char2int(radix, currChar)/(double)radix + frac2double(radix*radix);
}

