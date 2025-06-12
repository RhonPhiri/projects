import 'package:m2m_chichewa_quiz/data/models/answer_model.dart';

class Question {
  final String question;
  final List<Answer> answers;
  final int corrextAnswer;

  Question({
    required this.question,
    required this.answers,
    required this.corrextAnswer,
  });
}
