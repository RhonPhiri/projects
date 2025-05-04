import 'package:flutter/material.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
import 'package:provider/provider.dart';

class ErroMessageWithRetry extends StatelessWidget {
  const ErroMessageWithRetry({super.key});

  //method to retry loading hymnals & hymns
  void retryCallBack(BuildContext context) {
    final hymnalProvider = context.read<HymnalProvider>();
    hymnalProvider
      ..loadHymnals()
      ..selectHymnal(0);
    context.read<HymnProvider>().loadHymns(
      hymnalProvider.hymnals.isNotEmpty
          ? hymnalProvider.hymnals[hymnalProvider.selectedHymnal].language
              .toLowerCase()
          : "chichewa",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Check your internet connection and try again',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => retryCallBack(context),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
