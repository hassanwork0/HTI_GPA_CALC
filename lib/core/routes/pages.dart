library;

import 'package:flutter/material.dart';
import 'package:myapp/entites/course.dart';
import 'package:myapp/screens/course_parser_screen.dart';
import 'package:myapp/core/utils/department_tables.dart';
import 'package:myapp/screens/gpa_calc_screen.dart';

import '../error/error.dart';
import 'routes.dart';

class AppRoute {
  static const initial = RoutesName.initial;
  static Route<dynamic> generate(RouteSettings? settings) {
    switch (settings?.name) {
      case RoutesName.initial:
        return MaterialPageRoute(
          builder: (context) => const CourseParserScreen(),
        );

      case RoutesName.home:
        final courses = settings?.arguments as List<Course>;
        Map<String, List<Course>> studentDepTree = {};
        Electrical.departmentTree.forEach((key, value) {
          for (int i = 0; i < value.length; i++) {
            // Check if it's an elective (contains '(')
            if (value[i].code.contains('(')) {
              // It's an elective - check electivePatterns
              if (Electrical.electivePatterns.containsKey(value[i].code)) {
                List<Course> electiveList =
                    Electrical.electivePatterns[value[i].code]!;

                // Iterate through the elective list to find a completed course
                for (Course electiveCourse in electiveList) {
                  try {
                    Course checker = courses.firstWhere(
                      (course) => course.code == electiveCourse.code,
                    );
                    // Found a completed elective - replace and remove
                    value[i] = checker;
                    courses.remove(
                      checker,
                    ); // Remove from courses to prevent repetition
                    break; // Exit the loop after finding one match
                  } catch (e) {
                    continue; // Try next elective course
                  }
                }
                // If no completed elective found, value[i] remains as the placeholder
              }
            } else {
              // It's a regular course
              try {
                Course checker = courses.firstWhere(
                  (course) => course.code == value[i].code,
                );
                value[i] = checker;
                courses.remove(
                  checker,
                ); // Remove from courses to prevent repetition
              } catch (e) {
                continue;
              }
            }
          }
          studentDepTree[key] = value;
        });

        return MaterialPageRoute(
          builder: (context) =>
              GPACalculatorScreen(departmentTree: studentDepTree),
        );

      default:
        // If there is no such named route in the switch statement
        throw const RouteException('Route not found!');
    }
  }
}
