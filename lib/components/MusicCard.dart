import 'package:flutter/material.dart';

String clean(String name) {
  return name.substring(0, name.lastIndexOf('.'));
}

class MusicCard extends StatefulWidget {
  final String songName;
  final VoidCallback onClick;
  final VoidCallback onIconClick;
  final Icon icon;

  const MusicCard({
    super.key,
    required this.songName,
    required this.onClick,
    required this.onIconClick,
    required this.icon,
  });

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 16.0),
          title: Text(clean(widget.songName)),
          onTap: widget.onClick,
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.zero,
            ),
            onPressed: widget.onIconClick,
            child: widget.icon,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
