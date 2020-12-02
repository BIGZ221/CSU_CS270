 /** @mainpage 
   *  \htmlinclude "STRUCTS.html"
   */
/* CS270 
 *
 * Author: Zachary Fuchs
 * Date:   12/2/2020
 */
#include<stdio.h>
#include <stdlib.h>
#include "struct.h"

int main(int argc, const char **argv)
{
    int numStudents;
    scanf("%d", &numStudents);
    ClassRoster roster;
    roster.numStudents = numStudents;
    roster.students = calloc(sizeof(Student), numStudents);
    for (int i = 0; i < roster.numStudents; i++) {
        readStudentAndEnroll(&roster.students[i]);
    }
    for (int i = 0; i < roster.numStudents; i++) {
        displayStudent(*roster.students[i]);
        free(roster.students[i]);
    }
    free(roster.students);
    return 0;
}
