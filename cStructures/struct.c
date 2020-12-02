/* CS270 
 *
 * Author: Zachary Fuchs
 * Date:   12/2/2020
 */

#include "struct.h"
#include<stdio.h>
#include<stdlib.h>

/********** FUNCTION DEFINITIONS **********************************************/

void readStudentAndEnroll(Student **slot)
{
    Student *newStudent = malloc(sizeof(Student));
    scanf("%s\n%f\n%d\n", newStudent->firstName, &newStudent->qualityPoints, &newStudent->numCredits);
    *slot = newStudent;
}

void displayStudent(Student s)
{
    float GPA = s.qualityPoints / s.numCredits;
    printf("%s, %.02f\n", s.firstName, GPA);
}
