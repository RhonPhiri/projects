import 'package:flutter/material.dart';
import 'package:nah/ui/core/ui/core_ui_export.dart';
import 'package:provider/provider.dart';
import '../view_model/hymnal_provider.dart';

class HymnalScreen extends StatelessWidget {
  const HymnalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hymnalProvider = context.watch<HymnalProvider>();
    final title = 'Hymnals';
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(title: title),
          hymnalProvider.isLoading
              ? const SliverPadding(
                padding: EdgeInsets.only(top: 24),
                sliver: SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
              : hymnalProvider.errorMessage != null &&
                  hymnalProvider.errorMessage!.isNotEmpty
              ? SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    hymnalProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
              : SliverList.separated(
                itemCount: hymnalProvider.hymnals.length,
                itemBuilder: (context, index) {
                  final hymnal = hymnalProvider.hymnals[index];
                  return ListTile(
                    leading: Icon(
                      hymnalProvider.selectedHymnal == index
                          ? Icons.book_rounded
                          : Icons.book_outlined,
                      size: 40,
                      //TODO: create a list of color themes to assign to each hymnal
                      color: const Color(0xFF0168B5),
                    ),
                    title: Text(hymnal.title),
                    subtitle: Text(hymnal.language),
                    onTap: () {
                      context.read<HymnalProvider>().selectHymnal(index);
                      Navigator.of(context).pop(hymnal);
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
        ],
      ),
    );
  }
}
