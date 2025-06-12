import 'package:go_router/go_router.dart';
import 'package:m2m_chichewa_quiz/ui/home_page.dart';
import 'package:m2m_chichewa_quiz/ui/lessons/lesson_page.dart';
import 'package:m2m_chichewa_quiz/ui/question/widget/question_page.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      name: "HomePage",
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(
          path: "/LessonPage",
          name: "LessonPage",
          builder: (context, state) => LessonPage(),
          routes: [
            GoRoute(
              path: "QuestionPage/:id",
              name: "QuestionPage",
              builder: (context, state) => QuestionPage(
                lessonId: int.parse(state.pathParameters["id"]!),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
