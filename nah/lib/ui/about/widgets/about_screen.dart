import 'package:flutter/material.dart';
import 'package:nah/ui/about/view_model/about_components_variables.dart';
import 'components/about_components.dart';
import 'package:nah/ui/core/ui/my_sliver_app_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  //CustomScrollView controller
  late ScrollController _scrollController;

  //Variable to check if the about screen is scrollable
  bool isScrollable = false;

  //variable to check if user has reached the bottom of the screen
  bool isAtBottom = false;

  @override
  void initState() {
    super.initState();
    //Upon loading the first frame, check if the about screen is scrollable

    //Initialized the controller so that it checks if the user has reached the bottom of the screen & update isAtBottom
    _scrollController =
        ScrollController()..addListener(() {
          if (_scrollController.position.extentAfter == 0.0) {
            setState(() => isAtBottom = true);
          } else {
            setState(() => isAtBottom = false);
          }
        });

    //The _scrollController can only be used if attached to the Scrollable widget
    //this happens after a frame is drawn. check if is scrollable just after that first frame

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        isScrollable =
            _scrollController.position.extentInside !=
            _scrollController.position.extentTotal;
      });
    });
  }

  //a list of the components on this screen
  final aboutComponents = <Widget>[
    AboutHeader(appVersion: appVersion),
    AboutDescription(),
    AboutAcknowledgements(),
    ContactButtons(appVersion: appVersion),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          MySliverAppBar(title: "About"),

          for (var i = 0; i < aboutComponents.length; i++)
            SliverToBoxAdapter(
              child: Column(
                children: [aboutComponents[i], SizedBox(height: 16)],
              ),
            ),
        ],
      ),
      floatingActionButton: ScrollHandlerFAB(
        scrollController: _scrollController,
        isAtBottom: isAtBottom,
        isScrollable: isScrollable,
      ),

      persistentFooterButtons: [..._buildFooter(context)],
      persistentFooterAlignment: AlignmentDirectional.bottomCenter,
    );
  }

  List<TextButton> _buildFooter(BuildContext context) =>
      List.generate(FooterButtons.values.length, (int index) {
        final footerBut = FooterButtons.values[index];
        return TextButton(
          onPressed: () => footerBut.footerLaunchActions(context),
          child: Text(footerBut.label),
        );
      }).toList();
}
