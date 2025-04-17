import 'package:flutter/material.dart';
import 'package:nac_hymnal/components/my_sliver_app_bar.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = 'Info';
    return Scaffold(
      body: CustomScrollView(slivers: [MySliverAppBar(title: title)]),
    );
  }
}
