import 'package:flutter/material.dart';
import 'package:musicverse/main.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text("Configuration"),
          tiles: [
            SettingsTile.navigation(
              title: const Text("Remote Root Index URL"),
              onPressed: (context) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TextFieldSettingsScreen(propertyKey: "RemoteURLIndex")),
                );
              },
            ),
            SettingsTile.navigation(
              title: const Text("Remote Root Source URL"),
              onPressed: (context) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const TextFieldSettingsScreen(propertyKey: "RemoteURLSource")),
                );
              },
            ),
          ],
        ),
        SettingsSection(
          title: const Text("Advanced"),
          tiles: [
            SettingsTile(
              title: const Text("Clear cache"),
              onPressed: (context) async {
                var t = cacheDir.listSync();
                for (var ch in t) {
                  await ch.delete(recursive: true);
                }
              },
            )
          ],
        ),
      ],
    );
  }
}

class TextFieldSettingsScreen extends StatefulWidget {
  final String propertyKey;

  const TextFieldSettingsScreen({super.key, required this.propertyKey});

  @override
  State<TextFieldSettingsScreen> createState() => _TextFieldSettingsScreenState();
}

class _TextFieldSettingsScreenState extends State<TextFieldSettingsScreen> {
  final _textEditingController = TextEditingController();

  Future<void> _loadPref() async {
    var val = preferences.getString(widget.propertyKey);
    if (val == null) {
      return;
    }
    _textEditingController.text = val;
  }

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("MusicVerse"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                  filled: true,
                  hintText: "Value",
                  fillColor: Theme.of(context).colorScheme.tertiaryContainer,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
            ),
            const SizedBox(
              height: 20.0,
            ),
            OutlinedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.tertiaryContainer)),
              child: const Text("Save"),
              onPressed: () async {
                await preferences.setString(widget.propertyKey, _textEditingController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
