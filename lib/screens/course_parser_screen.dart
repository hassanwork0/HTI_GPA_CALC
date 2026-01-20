import 'package:flutter/material.dart';
import 'package:myapp/core/error/app_error_text.dart';
import 'package:myapp/core/routes/routes.dart';
import 'package:myapp/utils/text_parser.dart';
import 'package:myapp/widgets/app_header.dart';
import 'package:myapp/widgets/app_instructions.dart';
import 'package:myapp/widgets/app_textfield.dart';
import 'package:myapp/widgets/parse_button.dart';

class CourseParserScreen extends StatefulWidget {
  const CourseParserScreen({super.key});

  @override
  State<CourseParserScreen> createState() => _CourseParserScreenState();
}

class _CourseParserScreenState extends State<CourseParserScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  void _parseCourses() {
    if (_textController.text.isEmpty) {
      setState(() => _errorText = 'Please paste your course data');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        final lines = _textController.text.trim().split('\n');
        final courses = TextParser.parseCourses(lines);

        if (courses.isEmpty) {
          setState(() => _errorText = 'No valid courses found in the text');
          return;
        }

        Navigator.pushNamed(
          context,
          RoutesName.home,
          arguments: courses.values.toList(),
        );
      } catch (e) {
        setState(() => _errorText = 'Error parsing courses: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                AppHeader(),
                const SizedBox(height: 32),

                // Text Field
                AppTextField(textController: _textController),
                if (_errorText != null) ErrorText(errorText: _errorText!),

                const SizedBox(height: 24),

                // Button
                ParseCoursesButton(
                  isLoading: _isLoading,
                  parseCourses: _parseCourses,
                ),
                const SizedBox(height: 16),

                // Instructions
                AppInstructions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
