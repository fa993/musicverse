import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

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
              title: const Text("Remote Root URL"),
              onPressed: (context) {},
            ),
          ],
        )
      ],
    );
  }
}
