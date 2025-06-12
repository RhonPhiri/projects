import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2m_chichewa_quiz/ui/question/view/question_view_model.dart';
import 'package:m2m_chichewa_quiz/ui/question/widget/answer_cards.dart';
import 'package:m2m_chichewa_quiz/ui/question/widget/question_card.dart';
import 'package:m2m_chichewa_quiz/ui/question/widget/status_bar.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.lessonId});
  final int lessonId;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late final QuestionViewModel viewModel = QuestionViewModel(
    lessonId: widget.lessonId,
    onQuizOver: handleQuizOver,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                QuestionCard(question: viewModel.currentQUestion),
                AnswerCards(
                  answers: viewModel.currentQUestion?.answers ?? [],
                  onAnswerTapped: (index) => viewModel.checkAnswer(index),
                  correctAnswer: viewModel.didAnswerQUestion
                      ? viewModel.currentQUestion?.corrextAnswer
                      : null,
                ),
                SizedBox(height: 24),
                MaterialButton(
                  shape: StadiumBorder(),
                  color: viewModel.didAnswerQUestion
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.8)
                      : Colors.grey.shade400,
                  onPressed: () {
                    viewModel.didAnswerQUestion && viewModel.hasNextQuestion
                        ? viewModel.getNextQuestion()
                        : null;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 24,
                    ),
                    child: Text(
                      "Next Question",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                StatusBar(viewModel: viewModel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleQuizOver() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz Over"),
        content: Text("Score: ${viewModel.score}"),
        actions: [
          IconButton.filled(
            tooltip: "Lesson Page",
            onPressed: () => context.pushNamed("LessonPage"),
            icon: Icon(Icons.home_filled),
          ),
        ],
      ),
    );
  }
}
