import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/view/auth_page.dart';
import '../../../reminders/presentation/view/reminders_page.dart';
import 'language_settings_page.dart';
import 'settings_placeholder_page.dart';

/// Settings hub opened from the profile screen's gear button. Lists the setting
/// categories; "Thông báo" routes to the study-reminders screen (moved here from
/// the bottom nav), "Ngôn ngữ hiển thị" to the display-language picker, and
/// "Đăng xuất" resets back to the auth screen.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          _SettingsTile(
            icon: AppIcons.person,
            color: const Color(0xFF1CB0F6),
            label: l10n.settingsPersonal,
            onTap: () => _push(
              context,
              SettingsPlaceholderPage(
                title: l10n.settingsPersonal,
                icon: AppIcons.person,
              ),
            ),
          ),
          _SettingsTile(
            icon: AppIcons.notifications,
            color: const Color(0xFFFF9600),
            label: l10n.settingsNotifications,
            onTap: () => _push(context, const RemindersPage()),
          ),
          _SettingsTile(
            icon: AppIcons.bookOpen,
            color: const Color(0xFF58CC02),
            label: l10n.settingsCourses,
            onTap: () => _push(
              context,
              SettingsPlaceholderPage(
                title: l10n.settingsCourses,
                icon: AppIcons.bookOpen,
              ),
            ),
          ),
          _SettingsTile(
            icon: AppIcons.language,
            color: const Color(0xFF2EC4B6),
            label: l10n.settingsLanguage,
            onTap: () => _push(context, const LanguageSettingsPage()),
          ),
          _SettingsTile(
            icon: AppIcons.lock,
            color: const Color(0xFFA560F0),
            label: l10n.settingsPrivacy,
            onTap: () => _push(
              context,
              SettingsPlaceholderPage(
                title: l10n.settingsPrivacy,
                icon: AppIcons.lock,
              ),
            ),
          ),
          const Divider(),
          _SettingsTile(
            icon: AppIcons.logout,
            color: theme.colorScheme.error,
            label: l10n.settingsLogout,
            destructive: true,
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const AuthPage()),
              (route) => false,
            ),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: destructive ? theme.colorScheme.error : null,
        ),
      ),
      trailing: destructive ? null : const Icon(AppIcons.chevronRight),
      onTap: onTap,
    );
  }
}
