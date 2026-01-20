
import 'package:myapp/entites/course.dart';
import 'package:myapp/utils/conversions.dart';

class GPACalculator {
  static double calculateGPA(List<Course> courses) {
    double totalGradePoints = 0;
    double totalCreditHours = 0;

    for (var course in courses) {
      // Skip courses with gpa == 0
      if (course.gpa == 0 && course.gpaLetter == 'NF') continue;

      double gradePoint = Conversions.convertGradeToPoints(course.gpaLetter);
      totalGradePoints += gradePoint * course.creditHours;
      totalCreditHours += course.creditHours;
    }

    return totalCreditHours > 0 ? totalGradePoints / totalCreditHours : 0;
  }

}