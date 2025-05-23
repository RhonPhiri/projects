import 'package:flutter/material.dart';
import 'package:nah/ui/core/ui/core_ui_export.dart';
import 'package:nah/ui/core/ui/erro_message_with_retry.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
import 'package:provider/provider.dart';
import '../view_model/hymnal_provider.dart';

/// Screen that displays a list of available hymnals for selection.
class HymnalScreen extends StatelessWidget {
  const HymnalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Get the hymnal provider from the context.
    final hymnalProvider = context.watch<HymnalProvider>();
    final title = 'Hymnals';
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(title: title),

          /// Show loading indicator while hymnals are being loaded.
          hymnalProvider.isLoading
              ? const SliverPadding(
                padding: EdgeInsets.only(top: 24),
                sliver: SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
              /// Show error message if loading failed.
              : hymnalProvider.errorMessage != null &&
                  hymnalProvider.errorMessage!.isNotEmpty
              ? SliverFillRemaining(
                hasScrollBody: false,
                child: ErroMessageWithRetry(),
              )
              /// Show the list of hymnals.
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
                      /// When a hymnal is tapped, select it and load its hymns.
                      context.read<HymnalProvider>().selectHymnal(index);
                      context.read<HymnProvider>().loadHymns(
                        hymnal.language.toLowerCase(),
                      );
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
