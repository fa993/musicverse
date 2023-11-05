import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicverse/components/RemoteMusicFiles.dart';
import 'package:musicverse/components/Settings.dart';
import 'package:musicverse/services/AudioController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/LocalMusicFiles.dart';

Future<void> main() async {
  AudioController.audioHandler = await AudioService.init(
    builder: () => AudioController.instance,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.fa993.musicverse.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  preferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300), useMaterial3: true),
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.dark().copyWith(
            primary: Colors.blue.shade900,
            primaryContainer: Colors.blue.shade500,
          ),
          useMaterial3: true),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
      //
      //   useMaterial3: true,
      // ),
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
      //   useMaterial3: true,
      // ),
      home: const MusicVerse(),
    );
  }
}

class MusicVerse extends StatefulWidget {
  const MusicVerse({super.key});

  @override
  State<MusicVerse> createState() => _MusicVerseState();
}

class _MusicVerseState extends State<MusicVerse> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("MusicVerse"),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: LocalMusicFiles(),
            ),
            Center(
              child: RemoteMusicFiles(),
            ),
            Center(
              child: SettingsScreen(),
            )
          ],
        ),
        bottomNavigationBar: const TabBar(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          tabs: [
            Tab(
              text: 'Local',
              icon: Icon(Icons.phone_android),
            ),
            Tab(
              text: 'Remote',
              icon: Icon(Icons.cloud),
            ),
            Tab(
              text: 'Settings',
              icon: Icon(Icons.settings),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await AudioController.instance.toggle();
          },
          child: const Icon(Icons.music_note),
        ),
      ),
      //This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}