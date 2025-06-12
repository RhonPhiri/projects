import 'package:flutter/material.dart';
import 'package:m2m_chichewa_quiz/data/models/answer_model.dart';

class AnswerCards extends StatelessWidget {
  const AnswerCards({
    super.key,
    required this.answers,
    required this.onAnswerTapped,
    this.correctAnswer,
  });
  final List<Answer> answers;
  final ValueChanged onAnswerTapped;
  final int? correctAnswer;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 5 / 1,
      crossAxisCount: 1,
      children: List.generate(answers.length, (int index) {
        final answer = answers[index];
        Color color = Theme.of(context).colorScheme.primaryContainer;
        if (correctAnswer == index) {
          color = Colors.green.shade100;
        }
        return InkWell(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          splashColor: Theme.of(context).colorScheme.primaryContainer,
          key: ValueKey(answer.answer),
          onTap: () => onAnswerTapped(index),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.all(16),
            child: Text(
              answer.answer,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        );
      }),
    );
  }
}
