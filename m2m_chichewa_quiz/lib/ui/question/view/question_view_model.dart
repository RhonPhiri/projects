import 'package:flutter/material.dart';
import 'package:m2m_chichewa_quiz/data/models/question_model.dart';
import 'package:m2m_chichewa_quiz/data/repository/question_bank.dart';

class QuestionViewModel with ChangeNotifier {
  late final QuestionBank _questionBank;
  late int totalQuestions;
  Question? currentQUestion;
  int answeredQuestionCount = 0;
  int score = 0;
  bool didAnswerQUestion = false;
  bool get hasNextQuestion => answeredQuestionCount < totalQuestions;

  final VoidCallback onQuizOver;

  QuestionViewModel({required int lessonId, required this.onQuizOver}) {
    _questionBank = QuestionBank(lessonId: lessonId);
    totalQuestions = _questionBank.remainingQuestions;
    getNextQuestion();
  }

  void getNextQuestion() {
    if (_questionBank.hasNextQuestion) {
      currentQUestion = _questionBank.getRandomQuestion();
      answeredQuestionCount++;
    }

    didAnswerQUestion = false;

    notifyListeners();
  }

  void checkAnswer(int selectedIndex) {
    if (!didAnswerQUestion && currentQUestion?.corrextAnswer == selectedIndex) {
      score++;
    }
    didAnswerQUestion = true;

    if (!_questionBank.hasNextQuestion) {
      onQuizOver();
    }

    notifyListeners();
  }
}
