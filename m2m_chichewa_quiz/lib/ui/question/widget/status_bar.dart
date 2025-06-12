import 'package:flutter/material.dart';
import 'package:m2m_chichewa_quiz/ui/question/view/question_view_model.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key, required this.viewModel});
  final QuestionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Question ${viewModel.answeredQuestionCount} of ${viewModel.totalQuestions}",
          ),
          Text("Score: ${viewModel.score}"),
        ],
      ),
    );
  }
}
