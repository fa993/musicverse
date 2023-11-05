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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: Column(
        children: [
          TextField(
            autocorrect: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              filled: true,
              // fillColor: const Color.fromARGB(255, 238, 238, 238),
              hintText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CustomScrollView(
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
        ],
      ),
    );
  }
}
