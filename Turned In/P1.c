// P1 Assignment
// Author: Zachary Fuchs
// Date:   8/27/2020
// Class:  CS270
// Email:  zachf@colostate.edu

// Include files
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

double input[4];
double output[4];

void computeCircle(double radius, double *output) {
    double result = 3.141593 * radius * radius;
    *output = result;
}

void computeTriangle(double side, double *output){
    double result = 0.433013 * side * side;
    *output = result;
}

void computeSquare(double side, double *output){
    double result = side * side;
    *output = result;
}

void computePentagon(double side, double *output){
    double result = 1.720477 * side * side;
    *output = result;
}

int main(int argc, char *argv[])
{

    if (argc != 5) {
        printf("usage: ./P1 <double> <double> <double> <double>\n");
        return EXIT_FAILURE;
    }

    for (int i =1; i < 5; i++){
        input[i-1] = atof(argv[i]);
    }
    
    computeCircle(input[0], &output[0]);
    computeTriangle(input[1], &output[1]);
    computeSquare(input[2], &output[2]);
    computePentagon(input[3], &output[3]);

    printf("CIRCLE, radius = %.5f, area = %.5f.\n",input[0],output[0]);
    printf("TRIANGLE, length = %.5f, area = %.5f.\n",input[1],output[1]);
    printf("SQUARE, length = %.5f, area = %.5f.\n",input[2],output[2]);
    printf("PENTAGON, length = %.5f, area = %.5f.\n",input[3],output[3]);

    // Return success
    return EXIT_SUCCESS;
}