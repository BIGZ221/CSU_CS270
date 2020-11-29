#include <stdio.h>

int main() {
    char testval;
    int blar = 36;
    if (blar+48 > 57){
        testval = blar+55;
    } else {
        testval = blar+48;
    }
    printf("%c\n",testval);
}