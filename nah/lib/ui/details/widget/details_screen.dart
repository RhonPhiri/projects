import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/bookmarked_hymn/view_model/bookmarked_hymns_provider.dart';
import 'package:nah/ui/core/ui/my_sliver_app_bar.dart';
import 'package:nah/ui/details/widget/flow_menu/flow_menu.dart';
import 'package:nah/ui/details/widget/hymn_column.dart';
import 'package:provider/provider.dart';

/// Screen that displays the details of a single hymn.
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.hymn,
    required this.isBookmarked,
  });
  final Hymn hymn;
  final bool isBookmarked;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isPlaying = false;

  //Variable to hold the current scrolling status
  bool _isScrollingDown = false;

  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.position.pixels >= 120 &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      if (!_isScrollingDown) setState(() => _isScrollingDown = true);
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isScrollingDown) setState(() => _isScrollingDown = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ///Variable to access the bookmarked hymn provider
    final bookamrkProvider = context.watch<BookmarkedHymnsProvider>();
    final bookmarkCondition =
        (widget.isBookmarked && bookamrkProvider.isLoading);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          /// App bar for the details screen.
          // SliverAppBar(key: ValueKey("DetailsScreenSliverAppBar")),
          MySliverAppBar(
            title:
                bookmarkCondition
                    ? ""
                    : "${widget.hymn.id}. ${widget.hymn.title}",
            actions: [
              IconButton(
                onPressed: () {
                  final player = AudioPlayer(playerId: "${widget.hymn.id}");
                  isPlaying
                      ? player.play(AssetSource("audios/hymn522.mp3"))
                      : player.release();
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
                icon: Icon(
                  isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                ),
              ),
            ],
          ),

          /// Main content: hymn details.
          bookmarkCondition
              ? SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
              : SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HymnColumn(hymn: widget.hymn),
                ),
              ),
        ],
      ),

      /// Floating action button menu for actions related to the hymn.
      floatingActionButton: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder:
            (child, animation) =>
                ScaleTransition(scale: animation, child: child),
        child:
            _isScrollingDown
                ? SizedBox.shrink(key: ValueKey("FlowMenuHide"))
                : FlowMenu(key: ValueKey("FlowMenuShow"), hymn: widget.hymn),
      ),
    );
  }
}
