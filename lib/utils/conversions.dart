class Conversions{

  static double convertGradeToPoints(String grade) {
    switch (grade.toUpperCase()) {
      case 'A+':
        return 4.3;
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'C-':
        return 1.7;
      case 'D+':
        return 1.3;
      case 'D':
        return 1.0;
      case 'D-':
        return 0.7;
      case 'F':
        return 0.0;
      default:
        return 0.0; // Handle invalid grades
    }
  }

  static String calculateGpaLetter(int gpa) {
    if (gpa >= 97) return 'A+';
    if (gpa >= 93) return 'A';
    if (gpa >= 89) return 'A-';
    if (gpa >= 85) return 'B+';
    if (gpa >= 80) return 'B';
    if (gpa >= 76) return 'B-';
    if (gpa >= 73) return 'C+';
    if (gpa >= 70) return 'C';
    if (gpa >= 67) return 'C-';
    if (gpa >= 63) return 'D+';
    if (gpa >= 60) return 'D';
    return 'F';
  }

  
  int convertLetterToGpa(String letterGrade) {
    // Map letter grades to the minimum GPA score for that grade
    switch (letterGrade.toUpperCase()) {
      case 'A+':
        return 97;
      case 'A':
        return 93;
      case 'A-':
        return 89;
      case 'B+':
        return 85;
      case 'B':
        return 80;
      case 'B-':
        return 76;
      case 'C+':
        return 73;
      case 'C':
        return 70;
      case 'C-':
        return 67;
      case 'D+':
        return 63;
      case 'D':
        return 60;
      case 'F':
        return 0;
      default:
        return 0; // Handle invalid grades
    }
  }

}