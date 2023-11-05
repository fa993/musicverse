import 'dart:io';

import 'package:musicverse/models/MusicItem.dart';

class MusicFile {
  final File file;
  final String name;

  const MusicFile({required this.file, required this.name});

  MusicItem toMusicItem() => MusicItem.file(name, file.path);
}
