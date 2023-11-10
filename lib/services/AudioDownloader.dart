import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';

import '../auth/secrets.dart';

final dio = Dio();

class AudioDownloader {
  final Set<String> _currentlyDownloading;

  AudioDownloader() : _currentlyDownloading = HashSet();

  Future<bool> save(String url, String path) async {
    if (_currentlyDownloading.contains(url)) {
      return false;
    } else {
      _currentlyDownloading.add(url);
    }
    await Isolate.run(() async {
      print('Downloading $url');
      await dio.download(url, path, options: Options(headers: {HttpHeaders.authorizationHeader: token}));
      print('Download $url finished');
    });
    _currentlyDownloading.remove(url);
    return true;
  }

  bool isCurrentlyDownloading(String url) => _currentlyDownloading.contains(url);
}
