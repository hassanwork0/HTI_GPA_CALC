import 'package:flutter/material.dart';
import 'package:myapp/core/constants/grades.dart';
import 'package:myapp/entites/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Function(String)? onGradeChanged;

  const CourseCard({
    super.key,
    required this.course,
    this.onGradeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:  Colors.grey[300]!,
          width:  1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Course Code
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                course.code,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(width: 12),

            // Course Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${course.creditHours} credit hours',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Grade with dropdown for editing
            _buildGradeSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeSection() {
    // Handle special grades like "P" (Pass)
    final hasValidGrade = Grades.validGrades.contains(course.gpaLetter);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:  Colors.grey[300]!,
            ),
          ),
          child: onGradeChanged != null && hasValidGrade
              ? DropdownButton<String>(
                  value: course.gpaLetter,
                  onChanged: (newGrade) => onGradeChanged!(newGrade!),
                  items: _buildGradeItems(),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down_rounded, size: 16),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                )
              : Text(
                  course.gpaLetter,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:  Colors.blue,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          '${course.gpa}',
          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildGradeItems() {
    return Grades.validGrades.map((grade) {
      return DropdownMenuItem<String>(
        value: grade,
        child: Text(
          grade,
          style: TextStyle(
            color:  Colors.green ,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }
}
