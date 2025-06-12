import 'package:m2m_chichewa_quiz/data/models/question_model.dart';
import 'package:m2m_chichewa_quiz/data/repository/questions.dart';
import 'dart:math' as math;

class QuestionBank {
  final int lessonId;
  late final List<Question> _questions;

  QuestionBank({required this.lessonId}) {
    _questions = createQuestion(lessonId);
  }

  bool get hasNextQuestion => _questions.isNotEmpty;
  int get remainingQuestions => _questions.length;

  Question? getRandomQuestion() {
    if (_questions.isEmpty) {
      return null;
    }

    final i = math.Random().nextInt(_questions.length);
    final question = _questions[i];

    _questions.removeAt(i);
    return question;
  }
}
