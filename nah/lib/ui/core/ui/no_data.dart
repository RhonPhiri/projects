import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({super.key, required this.gender});
  final String gender;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("assets/images/empty/no_data_$gender.png"),
    );
  }
}
