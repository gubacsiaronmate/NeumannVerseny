import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_time/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beállítások'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionHeader('Megjelenés'),
            SwitchListTile(
              title: const Text('Sötét mód'),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(value),
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
            _buildSectionHeader('Értesítések'),
            SwitchListTile(
              title: const Text('Értesítések engedélyezése'),
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
              secondary: const Icon(Icons.notifications_active_outlined),
            ),
            _buildSectionHeader('Nyelv'),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Alapértelmezett nyelv'),
              subtitle: Text(_selectedLanguage),
              onTap: () => _showLanguageDialog(context),
            ),
            _buildSectionHeader('Információ'),
            ListTile(
              title: const Text('Verzió'),
              subtitle: const Text('1.0.0'),
              trailing: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showAboutDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Válassz nyelvet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption('English'),
            _languageOption('Magyar'),
            _languageOption('Deutsch'),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String language) {
    return ListTile(
      title: Text(language),
      onTap: () {
        setState(() => _selectedLanguage = language);
        Navigator.pop(context);
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'My App',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 My Company',
    );
  }
}