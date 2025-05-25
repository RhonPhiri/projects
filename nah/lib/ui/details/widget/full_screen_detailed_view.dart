import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/utils/hymn_extensions.dart';

class FullScreenDetailedView extends StatefulWidget {
  const FullScreenDetailedView({super.key, required this.hymn});
  final Hymn hymn;

  @override
  State<FullScreenDetailedView> createState() => _FullScreenDetailedViewState();
}

class _FullScreenDetailedViewState extends State<FullScreenDetailedView> {
  @override
  void initState() {
    super.initState();
    //Forcing landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    //restoring orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  //getter to return the title & other details
  Widget get getIntro {
    return Text.rich(
      TextSpan(
        text: '${widget.hymn.title}\n\n',
        style: Theme.of(context).textTheme.displayMedium,

        children: [
          TextSpan(
            text: ' ${widget.hymn.otherDetails}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  //getter to retain verses & chorus

  @override
  Widget build(BuildContext context) {
    //Variable to hold the verses
    final verses = widget.hymn.verses;
    //variable to hold the chorus
    final chorus = widget.hymn.chorus;
    //Variable to hold the textTheme
    final textStyle = Theme.of(
      context,
    ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold);
    final centerText = TextAlign.center;

    //Building list of pages
    final List<Widget> pages = [
      getIntro,
      if (chorus.isNotEmpty)
        for (String verse in verses) ...[
          Text(verse, style: textStyle, textAlign: centerText),
          Text(chorus, style: textStyle, textAlign: centerText),
        ]
      else
        for (String verse in verses)
          Text(verse, style: textStyle, textAlign: centerText),
    ];

    return Scaffold(
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder:
            (context, index) => Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(child: pages[index]),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.fullscreen_exit_rounded),
      ),
    );
  }
}
