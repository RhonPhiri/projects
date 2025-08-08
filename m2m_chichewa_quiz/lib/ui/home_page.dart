import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              SvgPicture.asset(
                "assets/images/pencil.svg",
                width: size.width * 0.2,
                height: size.height * 0.2,
              ),
              Spacer(),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Text(
                  "Welcome to the Chichewa Quiz",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.goNamed("LessonPage");
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 8,
                  ),

                  child: Text(
                    "Start",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
