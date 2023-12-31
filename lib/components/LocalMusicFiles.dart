import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musicverse/models/MusicFile.dart';
import 'package:musicverse/services/AudioController.dart';
import 'package:path/path.dart' as Path;

import '../main.dart';
import '../models/MusicItem.dart';
import 'MusicList.dart';

class LocalMusicFiles extends StatefulWidget {
  static final AudioController audioController = AudioController.instance;

  const LocalMusicFiles({super.key});

  @override
  State<LocalMusicFiles> createState() => _LocalMusicFilesState();
}

class _LocalMusicFilesState extends State<LocalMusicFiles> with AutomaticKeepAliveClientMixin {
  List<MusicFile> _globalChildren = [];
  List<MusicFile> _children = [];
  List<MusicItem> _copyChildren = [];
  final TextEditingController _textEditingController = TextEditingController();

  void refresh() {
    setState(() {
      _children = appDir
          .listSync()
          .where((e) => e.path.endsWith(".mp3"))
          .map((e) => MusicFile(file: File(e.path), name: Path.basename(e.path)))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      _globalChildren = _children;
      _copyChildren = _children.map((e) => e.toMusicItem()).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
    _textEditingController.addListener(() {
      setState(() {
        _children = _globalChildren
            .where((e) => e.name.toLowerCase().contains(_textEditingController.text.toLowerCase().trim()))
            .toList();
        _copyChildren = _children.map((e) => e.toMusicItem()).toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  Future<void> _playTrack(index) async {
    MusicFile musicFile = _children[index];
    if (musicFile.name.isEmpty) {
      return;
    }
    await LocalMusicFiles.audioController.playTrackWithQueue(index, _copyChildren);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MusicList(
      onClick: (context, index) async {
        _playTrack(index);
      },
      onIconClick: (context, index) async {
        await _children[index].file.delete();
        refresh();
      },
      icon: const Icon(Icons.delete),
      builder: (context, index) => _children[index].name,
      musicListLength: _children.length,
      refreshMusicList: () async => refresh(),
      searchController: _textEditingController,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
