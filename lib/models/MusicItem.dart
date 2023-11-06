import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicverse/components/MusicCard.dart';

class MusicItem {
  final bool _isFile;
  final String _path;
  final String _name;

  const MusicItem.file(this._name, this._path) : _isFile = true;

  const MusicItem.uri(this._name, this._path) : _isFile = false;

  String get path => _path;

  bool get isFile => _isFile;

  String get name => _name;

  MediaItem toMediaItem() => MediaItem(
        id: clean(_name),
        album: "MusicVerse",
        artist: "Me",
        title: clean(_name),
        extras: <String, dynamic>{
          'isFile': _isFile,
          'path': _path,
        },
      );

  AudioSource toAudioSource() {
    if (_isFile) {
      return AudioSource.file(_path, tag: toMediaItem());
    } else {
      return AudioSource.uri(Uri.parse(_path), tag: toMediaItem());
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicItem &&
          runtimeType == other.runtimeType &&
          _isFile == other._isFile &&
          _path == other._path &&
          _name == other._name;

  @override
  int get hashCode => _isFile.hashCode ^ _path.hashCode ^ _name.hashCode;
}

extension FromMediaItem on MediaItem {
  MusicItem toMusicItem() {
    return extras?['isFile'] ? MusicItem.file(title, extras?['path']) : MusicItem.uri(title, extras?['path']);
  }
}
