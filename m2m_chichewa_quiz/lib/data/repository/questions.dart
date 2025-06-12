import 'package:m2m_chichewa_quiz/data/models/answer_model.dart';
import 'package:m2m_chichewa_quiz/data/models/question_model.dart';

List<Question> createQuestion(int lessonId) {
  final Map<int, List<Question>> questions = {
    1: [
      Question(
        question: "How do you say 'Hello' in Chichewa",
        answers: [
          Answer("Zikomo"),
          Answer("Moni"),
          Answer("Pepani"),
          Answer("Muli bwanji?"),
        ],
        corrextAnswer: 1,
      ),
      Question(
        question: "When would you use 'Bo bo'?",
        answers: [
          Answer("Informal greeting to children"),
          Answer("Informal greeting to adults"),
          Answer("Formal greeting to children"),
          Answer("Formal greeting to adults"),
        ],
        corrextAnswer: 0,
      ),
      Question(
        question: "What is the response to 'Muli bwanji'?",
        answers: [
          Answer("Ndadzuka bwino kaya inu?"),
          Answer("Ndili bwino kaya inu?"),
          Answer("Ndaswera bwino kaya inu?"),
          Answer("Bo bo"),
        ],
        corrextAnswer: 1,
      ),
    ],
  };
  return questions[lessonId] ?? [];
}
