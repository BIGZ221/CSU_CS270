#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){

    int **a;
    int *b;
    int g = 5566554;
    b = &g;
    a = &b;
    double radius = atof(argv[1]);

    printf("%p\n",a);
    printf("%p\n",*a);
    printf("%p\n",b);
    printf("%i\n",**a);
    printf("%f\n",radius);
    return 0;    
}