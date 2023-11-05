import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicverse/auth/secrets.dart';
import 'package:musicverse/components/MusicList.dart';
import 'package:musicverse/components/Settings.dart';
import 'package:musicverse/main.dart';
import 'package:musicverse/models/MusicItem.dart';
import 'package:musicverse/services/AudioController.dart';

class RemoteMusicFiles extends StatefulWidget {
  static final AudioController audioController = AudioController.instance;

  const RemoteMusicFiles({super.key});

  @override
  State<RemoteMusicFiles> createState() => _RemoteMusicFilesState();
}

class _RemoteMusicFilesState extends State<RemoteMusicFiles> with AutomaticKeepAliveClientMixin {
  List<MusicItem> _children = [];

  Future<void> _playTrack(index) async {
    String fileName = _children[index].name;
    if (fileName.isEmpty) {
      return;
    }
    await RemoteMusicFiles.audioController.playTrackWithQueue(index, _children);
  }

  // http://127.0.0.1:8000/api/'
  Future<void> _loadTracks() async {
    String? baseSourceURL = preferences.getString("RemoteURLSource");
    String? baseIndexURL = preferences.getString("RemoteURLIndex");
    if(baseIndexURL == null){
      return;
    }
    try {
      final response = await http.get(Uri.parse(baseIndexURL));
      if (response.statusCode < 300 && response.statusCode >= 200) {
        var childs = ((json.decode(response.body) as Map<String, dynamic>)["sub_entries"] as List)
            .where((e) => e["entry_type"] == "File")
            .where((e) => e["name"]?.endsWith(".mp3"))
            .map((i) => i["name"])
            .map((e) => MusicItem.uri(e, "$baseSourceURL/$e"))
            .toList();
        if (mounted) {
          setState(() {
            _children = childs;
          });
        }
      }
    } catch (ex) {
      //DO NOTHING
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTracks();
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
        dio.download(_children[index].path, "${appDir.path}${Platform.pathSeparator}${_children[index].name}",
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
