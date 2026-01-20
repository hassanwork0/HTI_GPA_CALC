
import 'package:flutter/material.dart';

class AppInstructions extends StatelessWidget {
  const AppInstructions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to use:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            buildInstructionStep(
              1,
              'Copy your course results from the HTI portal',
            ),
            buildInstructionStep(
              2,
              'Paste the data into the text field above',
            ),
            buildInstructionStep(
              3,
              'Click "Calculate GPA" to see your results',
            ),
            buildInstructionStep(4, 'Review your courses and GPA calculation'),
          ],
        ),
      ],
    );
  }


  Widget buildInstructionStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
