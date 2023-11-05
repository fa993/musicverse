import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicverse/auth/secrets.dart';
import 'package:musicverse/components/MusicList.dart';
import 'package:musicverse/models/MusicItem.dart';
import 'package:musicverse/services/AudioController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

final dio = Dio();

String getUrl(fileName) => "http://127.0.0.1:8000/raw/$fileName";

class RemoteMusicFiles extends StatefulWidget {
  static final AudioController audioController = AudioController.instance;

  const RemoteMusicFiles({super.key});

  @override
  State<RemoteMusicFiles> createState() => _RemoteMusicFilesState();
}

class _RemoteMusicFilesState extends State<RemoteMusicFiles> with AutomaticKeepAliveClientMixin {
  List<MusicItem> _children = [];

  Directory? _appDir;

  Future<void> _playTrack(index) async {
    String fileName = _children[index].name;
    if (fileName.isEmpty) {
      return;
    }

    await RemoteMusicFiles.audioController.playTrackWithQueue(index, _children);
  }

  Future<void> _loadTracks() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/'));
      if (response.statusCode < 300 && response.statusCode >= 200) {
        print(response.body);
        var childs = ((json.decode(response.body) as Map<String, dynamic>)["sub_entries"] as List)
            .where((e) => e["entry_type"] == "File")
            .where((e) => e["name"]?.endsWith(".mp3"))
            .map((i) => i["name"])
            .map((e) => MusicItem.uri(e, getUrl(e)))
            .toList();
        if(mounted) {
          setState(() {
            _children = childs;
          });
        }
      }
    } catch (ex) {
      //DO NOTHING
    }
  }

  void _loadLocalDir() async {
    var path = await getApplicationDocumentsDirectory();
    String localPath = '${path.path}${Platform.pathSeparator}Download';
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    _appDir = savedDir;
  }

  @override
  void initState() {
    super.initState();
    _loadTracks();
    _loadLocalDir();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _stopPlaying();
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MusicList(
      onClick: (context, index) async {
        _playTrack(index);
      },
      onIconClick: (context, index) async {
        dio.download(_children[index].path, "${_appDir!.path}${Platform.pathSeparator}${_children[index].name}",
            options: Options(headers: {HttpHeaders.authorizationHeader: token}));
      },
      icon: const Icon(Icons.download),
      builder: (context, index) => _children[index].name,
      musicListLength: _children.length,
      refreshMusicList: _loadTracks,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
