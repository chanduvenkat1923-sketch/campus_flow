import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  Future<void> _clearLocalData(BuildContext context) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear Local Data?'),
          content: const Text(
            'This will remove saved assignments, goals and '
            'profile information from this device.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Clear Data'),
            ),
          ],
        );
      },
    );

    if (shouldClear != true) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('assignments');
    await prefs.remove('goals');
    await prefs.remove('profile');

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Local data cleared successfully.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: SwitchListTile(
              secondary: Icon(
                isDark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(
                isDark
                    ? 'Dark theme is enabled'
                    : 'Light theme is enabled',
              ),
              value: isDark,
              onChanged: (value) {
                onThemeChanged(
                  value
                      ? ThemeMode.dark
                      : ThemeMode.light,
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.delete_sweep_outlined,
              ),
              title: const Text('Clear Local Data'),
              subtitle: const Text(
                'Remove saved assignments, goals and profile',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _clearLocalData(context),
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: const ListTile(
              leading: Icon(Icons.school_outlined),
              title: Text('CampusFlow'),
              subtitle: Text(
                'Smart academic companion for college students',
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Version'),
              subtitle: Text('1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}