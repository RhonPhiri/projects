import 'package:flutter/material.dart';
import 'package:m2m_chichewa_quiz/data/models/question_model.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.question});
  final Question? question;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Text(
          question?.question ?? "",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
