import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MusicCard.dart';

class MusicList extends StatefulWidget {
  final Future<void> Function(BuildContext, int) onClick;
  final Future<void> Function(BuildContext, int) onIconClick;
  final Icon icon;

  final String Function(BuildContext, int) builder;
  final int musicListLength;

  final Future<void> Function() refreshMusicList;

  const MusicList({
    super.key,
    required this.onClick,
    required this.onIconClick,
    required this.icon,
    required this.builder,
    required this.musicListLength,
    required this.refreshMusicList,
  });

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: TextField(
            autocorrect: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              filled: true,
              fillColor: Theme.of(context).colorScheme.tertiaryContainer,
              hintText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: SizedBox(height: 10),
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      await Future.wait([
                        Future<void>.delayed(const Duration(milliseconds: 200)),
                        widget.refreshMusicList(),
                      ]);
                    },
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) => MusicCard(
                        onClick: () => widget.onClick(context, index),
                        onIconClick: () => widget.onIconClick(context, index),
                        songName: widget.builder(context, index),
                        icon: widget.icon,
                      ),
                      childCount: widget.musicListLength,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
