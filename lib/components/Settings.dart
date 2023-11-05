import 'package:flutter/material.dart';
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
        )
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
  final myController = TextEditingController();


  Future<void> _loadPref() async {
    var val = preferences.getString(widget.propertyKey);
    if(val == null) {
      return;
    }
    myController.text = val;
  }

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
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
              controller: myController,
              decoration: const InputDecoration(
                  filled: true,
                  hintText: "Value",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
            ),
            const SizedBox(
              height: 20.0,
            ),
            OutlinedButton(
              child: const Text("Save"),
              onPressed: () async {
                await preferences.setString(widget.propertyKey, myController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
