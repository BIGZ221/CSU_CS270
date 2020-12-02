/* CS270 
 *
 * Author: Zachary Fuchs
 * Date:   12/2/2020
 */
 
/********** STRUCTURE DEFINITION **********************************************/

// Structure that represents a student
typedef struct
{
    char firstName[80];
    float qualityPoints;
    int numCredits;
} Student;

// Structure that represents a class roster
typedef struct
{
    int numStudents;
    Student **students;
} ClassRoster;

/********** FUNCTION PROTOTYPES ***********************************************/

void readStudentAndEnroll(Student **slot);

void displayStudent(Student s);
