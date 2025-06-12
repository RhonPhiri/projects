import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2m_chichewa_quiz/data/repository/lessons.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: ScrollConfiguration(
            behavior: ScrollBehavior().copyWith(
              scrollbars: false,
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
              },
            ),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Choose a Lesson",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: lessons.length,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        splashColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        onTap: () {
                          Timer(
                            Duration(milliseconds: 180),
                            () => context.goNamed(
                              "QuestionPage",
                              pathParameters: {"id": lesson.id.toString()},
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SvgPicture.asset(
                                    lesson.imageUrl,
                                    key: ValueKey(lesson.id),
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Text(
                                  lesson.title,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
