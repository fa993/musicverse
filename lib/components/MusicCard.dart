import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

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

class _MusicCardState extends State<MusicCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        child: GFListTile(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          title: Text(clean(widget.songName)),
          onTap: widget.onClick,
          icon: ElevatedButton(
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
}
