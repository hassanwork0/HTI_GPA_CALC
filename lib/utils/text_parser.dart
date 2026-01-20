

import 'package:myapp/entites/course.dart';
import 'package:myapp/utils/conversions.dart';

class TextParser {
  static bool isEnglishLetter(String line) {
    if (line.isEmpty) return false;
    
    String char = line.substring(0, 1);
    int asciiCode = char.codeUnitAt(0);
    
    return (asciiCode >= 65 && asciiCode <= 90) || // Uppercase
           (asciiCode >= 97 && asciiCode <= 122); // Lowercase
  }

  static Map<String, Course> parseCourses(List<String> lines) {
    Map<String, Course> courses = {};

    for (var line in lines) {
      if (isEnglishLetter(line)) {
        var temp = line.trim().split('	');
        
          try {
            final course = _parseCourseLine(temp);
            if (course != null) {
              if (!courses.containsKey(course.code) || 
                  courses[course.code]!.gpa < course.gpa) {
                courses[course.code] = course;
              }
            }
          } catch (e) {
            print('Error parsing line: $line, error: $e');
          }
        }
      }
    

    return courses;
  }

  static Course? _parseCourseLine(List<String> temp) {
    final code = temp[0];
    final name = temp[1];
    final creditHours = int.parse(temp[2].split(',')[0]);
    int grade;
    String gpaLetter;

    if (temp[3].contains('(')) {
      grade = int.parse(temp[3].substring(temp[3].length - 2));
      gpaLetter = Conversions.calculateGpaLetter(grade);
    } else {
      grade = int.parse(temp[4]);
      gpaLetter = temp[5];
    }

    return Course(
      code: code,
      name: name,
      gpa: grade,
      gpaLetter: gpaLetter,
      creditHours: creditHours,
    );
  }
}