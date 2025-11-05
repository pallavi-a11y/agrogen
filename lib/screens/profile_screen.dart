import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLanguageDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.english),
                leading: Radio<String>(
                  value: 'en',
                  groupValue: appState.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      appState.setLocale(Locale(value));
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.hindi),
                leading: Radio<String>(
                  value: 'hi',
                  groupValue: appState.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      appState.setLocale(Locale(value));
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryBrown,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.userName,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.primaryBrown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Farmer',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Farm Information
            Text(
              AppLocalizations.of(context)!.farmName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.home, color: AppTheme.primaryBrown),
                        const SizedBox(width: 8),
                        Text(
                          appState.farmName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppTheme.primaryBrown,
                        ),
                        const SizedBox(width: 8),
                        Text(appState.location),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Settings
            Text(
              AppLocalizations.of(context)!.settings,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: AppTheme.primaryBrown,
                    ),
                    title: const Text('Notifications'),
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.language,
                      color: AppTheme.primaryBrown,
                    ),
                    title: Text(AppLocalizations.of(context)!.language),
                    trailing: Text(
                      appState.locale.languageCode == 'en'
                          ? AppLocalizations.of(context)!.english
                          : AppLocalizations.of(context)!.hindi,
                    ),
                    onTap: () {
                      _showLanguageDialog(context, appState);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.help,
                      color: AppTheme.primaryBrown,
                    ),
                    title: const Text('Help & Support'),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: AppTheme.primaryBrown,
                    ),
                    title: Text(AppLocalizations.of(context)!.logout),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
