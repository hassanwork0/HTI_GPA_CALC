import 'package:flutter/material.dart';
import 'package:myapp/entites/course.dart';
import 'package:myapp/utils/conversions.dart';
import 'package:myapp/utils/gpa_calc.dart';
import 'package:myapp/widgets/course_card.dart';

class GPACalculatorScreen extends StatefulWidget {
  final Map<String, List<Course>> departmentTree;
  const GPACalculatorScreen({super.key, required this.departmentTree});

  @override
  State<GPACalculatorScreen> createState() => _GPACalculatorScreenState();
}

class _GPACalculatorScreenState extends State<GPACalculatorScreen> {
  late List<Course> _originalCourses;
  late List<Course> _courses;
  double _totalGPA = 0;
  int _totalCreditHours = 0;
  String _selectedYear = 'prep'; // Default to prep year

  @override
  void initState() {
    super.initState();
    // Initialize with prep year courses
    _originalCourses = _getCoursesForYear(_selectedYear);
    _courses = List.from(_originalCourses);
    _calculateTotalGPA();
  }

  List<Course> _getCoursesForYear(String year) {
    final yearData = widget.departmentTree[year];
    if (yearData == null) return [];

    // Return the actual courses with their real grades from the department tree
    return yearData
        .map(
          (course) => Course(
            code: course.code,
            name: course.name,
            creditHours: course.creditHours,
            gpa: course.gpa,
            gpaLetter: course.gpaLetter,
          ),
        )
        .toList();
  }

  void _calculateTotalGPA() {
    // Collect all courses from departmentTree
    List<Course> allCourses = widget.departmentTree.values
        .expand((courses) => courses)
        .toList();
    _totalGPA = GPACalculator.calculateGPA(allCourses);
    _totalCreditHours = allCourses.fold(0, (sum, course) {
      // Include credit hours for courses that are part of GPA calculation
      if (course.gpa > 0 || (course.gpaLetter != 'NF' && course.gpa == 0)) {
        return sum + course.creditHours;
      }
      return sum;
    });
  }

  void _updateCourseGrade(int index, String newGrade) {
    setState(() {
      // Calculate the corresponding numeric GPA based on the new letter grade
      int newGpa = Conversions().convertLetterToGpa(newGrade);

      // Update the course in the current year's course list
      _courses[index] = Course(
        code: _courses[index].code,
        name: _courses[index].name,
        gpa: newGpa, // Update the numeric GPA
        gpaLetter: newGrade, // Update the letter grade
        creditHours: _courses[index].creditHours,
      );

      // Update the course in the departmentTree to persist the change
      final yearCourses = widget.departmentTree[_selectedYear]!;
      int departmentIndex = yearCourses.indexWhere(
        (course) => course.code == _courses[index].code,
      );
      if (departmentIndex != -1) {
        yearCourses[departmentIndex] = _courses[index];
      }

      _calculateTotalGPA();
    });
  }

  void _resetToOriginal() {
    setState(() {
      _courses = List.from(_originalCourses);
      // Update departmentTree with original courses for the selected year
      widget.departmentTree[_selectedYear] = List.from(_originalCourses);
      _calculateTotalGPA();
    });
  }

  void _switchYear(String year) {
    setState(() {
      _selectedYear = year;
      _originalCourses = _getCoursesForYear(year);
      _courses = List.from(_originalCourses);
      _calculateTotalGPA();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('GPA Calculator'),

            Row(
              children: [
                //screen width > 700
                if(MediaQuery.of(context).size.width > 700)
                const Text(
                  'Total GPA',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Text(
                  _totalGPA.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(MediaQuery.of(context).size.width > 700)
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Total Hours: $_totalCreditHours',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _resetToOriginal,
            tooltip: 'Reset to original grades',
          ),
        ],
      ),
      body: Column(
        children: [
          // Year Selection Buttons
          _buildYearButtons(),
          const SizedBox(height: 16),
          // Courses List Header
          _buildCoursesHeader(),
          const SizedBox(height: 8),
          // Courses List
          _buildCoursesList(),
        ],
      ),
      // bottomNavigationBar: _buildGPASummary(),
    );
  }

  Widget _buildYearButtons() {
    final years = ['prep', 'year1', 'year2', 'year3', 'year4'];
    final yearTitles = {
      'prep': 'Prep Year',
      'year1': 'Year 1',
      'year2': 'Year 2',
      'year3': 'Year 3',
      'year4': 'Year 4',
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: years.map((year) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                onPressed: () => _switchYear(year),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedYear == year
                      ? Colors.blue
                      : Colors.grey[300],
                  foregroundColor: _selectedYear == year
                      ? Colors.white
                      : Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  yearTitles[year]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCoursesHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            '${_selectedYear == 'prep' ? 'Prep Year' : 'Year ${_selectedYear.substring(4)}'} Courses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          const Spacer(),
          Text(
            'Green = Original grade',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
    if (_courses.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'No courses found for ${_selectedYear == 'prep' ? 'Prep Year' : 'Year ${_selectedYear.substring(4)}'}',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];

          return CourseCard(
            course: course,
            onGradeChanged: (newGrade) => _updateCourseGrade(index, newGrade),
          );
        },
      ),
    );
  }
}
