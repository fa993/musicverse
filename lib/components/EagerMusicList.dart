import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MusicCard.dart';

class EagerMusicList extends StatefulWidget {
  final Future<void> Function(BuildContext, int) onClick;
  final Future<void> Function(BuildContext, int) onIconClick;
  final Icon icon;

  final List<String> songNames;

  final Future<void> Function() refreshMusicList;

  final TextEditingController? searchController;

  const EagerMusicList(
      {super.key,
      required this.onClick,
      required this.onIconClick,
      required this.icon,
      required this.songNames,
      required this.refreshMusicList,
      this.searchController});

  @override
  State<EagerMusicList> createState() => _EagerMusicListState();
}

class _EagerMusicListState extends State<EagerMusicList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: TextField(
            controller: widget.searchController,
            onTapOutside: (e) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
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
                  SliverList.list(
                    children: Iterable.generate(widget.songNames.length).map((idx) {
                      return MusicCard(
                        icon: widget.icon,
                        songName: widget.songNames[idx],
                        onClick: () => widget.onClick(context, idx),
                        onIconClick: () => widget.onIconClick(context, idx),
                      );
                    }).toList(),
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
