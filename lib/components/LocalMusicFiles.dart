import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musicverse/models/MusicFile.dart';
import 'package:musicverse/services/AudioController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

import '../models/MusicItem.dart';
import 'MusicList.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

class LocalMusicFiles extends StatefulWidget {

  static final AudioController audioController = AudioController.instance;

  const LocalMusicFiles({super.key});

  @override
  State<LocalMusicFiles> createState() => _LocalMusicFilesState();
}

class _LocalMusicFilesState extends State<LocalMusicFiles> with AutomaticKeepAliveClientMixin {

  late Directory _appDir;
  List<MusicFile> _children = [];
  List<MusicItem> _copyChildren = [];

  Future<void> _loadLocalDir() async {
    var path = await getApplicationDocumentsDirectory();
    String localPath = '${path.path}${Platform.pathSeparator}Download';
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    // print(savedDir.listSync());
    if(mounted) {
      _appDir = savedDir;
      refresh();
    }
  }

  void refresh() {
    setState(() {
      _children = _appDir.listSync().where((e) => e.path.endsWith(".mp3")).map((e) => MusicFile(file: File(e.path), name: Path.basename(e.path))).toList();
      _copyChildren = _children.map((e) => e.toMusicItem()).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLocalDir();
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
      refreshMusicList: _loadLocalDir,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
