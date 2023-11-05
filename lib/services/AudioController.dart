import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../models/MusicItem.dart';

class AudioController extends BaseAudioHandler with SeekHandler, QueueHandler {
  static final AudioController instance = AudioController._();
  static late final AudioHandler audioHandler;

  final AudioPlayer _player = AudioPlayer();
  int _currentIndex = -1;
  List<MusicItem> _currentItems = [];

  AudioController._() {
    playbackState.add(playbackState.value.copyWith(repeatMode: AudioServiceRepeatMode.all));
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    _player.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index <= 0 || index >= queue.value.length) {
      index = 0;
    }
    _currentIndex = index;
    await setCurrentMusicItem();
  }

  Future<void> toggle() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> playTrackWithQueue(int currentIndex, List<MusicItem> queue) async {
    _currentIndex = currentIndex;
    if (queue != _currentItems) {
      _currentItems = queue;
      super.queue.add(queue.map((e) => e.toMediaItem()).toList());
    }
    await setCurrentMusicItem();
  }

  Future<void> setCurrentMusicItem() async {
    var music = _currentItems[_currentIndex];
    var dur = await _player.setAudioSource(music.toAudioSource());
    var mI = music.toMediaItem().copyWith(duration: dur);
    mediaItem.add(mI);
    await play();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: _currentIndex,
    );
  }
}
