
import 'package:myapp/utils/conversions.dart';

class Course {
  final String code;
  final String name;
  final int gpa;
  final String gpaLetter;
  final int creditHours;

  const Course({
    required this.code,
    required this.name,
    required this.gpa,
     this.gpaLetter = 'N/A',
    required this.creditHours,
  });

  String get letter {
    return gpaLetter == 'N/A' ? Conversions.calculateGpaLetter(gpa) : gpaLetter;
  }

  @override
  String toString() {
    return 'Course(code: $code, name: $name, gpa: $gpa, gpaLetter: $gpaLetter, creditHours: $creditHours)';
  }
}