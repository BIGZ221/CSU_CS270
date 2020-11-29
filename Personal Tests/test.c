#include <stdio.h>
int main() {
    /*bitsneeded = hi-lo+1;
    x = 1 << bitsneeded;
    y = x - 1
    z = val >> lo
    y & z*/
    int isSigned = 1;
    int value = 9;
    int hi = 2;
    int lo = 1;
if (isSigned){
        printf("%i\n",(~(value >> lo) & (~((~0) << (hi))))+1);
    } else {
        printf("%i\n",(value >> lo) & (~((~0) << (hi-1))));
    }
}