import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/service_locator.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/session/current_user.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../bloc/locale_cubit.dart';
import '../bloc/theme_cubit.dart';

/// Settings hub opened from the profile screen's gear button. Grouped into
/// three sections (Giao diện & ngôn ngữ / Thông báo / Khác) styled after the
/// share_expenses settings page. The dark-mode switch is backed by
/// [ThemeCubit]; the email-summary switch is still a local-only placeholder.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _emailSummary = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final language = context.watch<LocaleCubit>().state;
    final themeMode = context.watch<ThemeCubit>().state;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          _SectionTitle(l10n.settingsSectionAppearanceLanguage),
          const SizedBox(height: 12),
          _Group(
            children: [
              _NavTile(
                icon: AppIcons.language,
                iconColor: AppColors.settingsLanguage,
                label: l10n.settingsLanguageRow,
                trailing: language.nativeLabel,
                onTap: () => context.push(RouteNames.languageSettings),
              ),
              _SwitchTile(
                icon: AppIcons.darkMode,
                iconColor: theme.colorScheme.onSurface,
                label: l10n.settingsDarkMode,
                subtitle: l10n.settingsDarkModeSubtitle,
                value: themeMode.isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggle(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.settingsNotifications),
          const SizedBox(height: 12),
          _Group(
            children: [
              _NavTile(
                icon: AppIcons.notifications,
                iconColor: AppColors.streak,
                label: l10n.settingsNotificationSettings,
                subtitle: l10n.settingsNotificationSettingsSubtitle,
                onTap: () => context.push(RouteNames.reminders),
              ),
              _SwitchTile(
                icon: AppIcons.email,
                iconColor: AppColors.settingsEmail,
                label: l10n.settingsEmailSummary,
                subtitle: l10n.settingsEmailSummarySubtitle,
                value: _emailSummary,
                onChanged: (v) => setState(() => _emailSummary = v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.settingsSectionOther),
          const SizedBox(height: 12),
          _Group(
            children: [
              _NavTile(
                icon: AppIcons.shield,
                iconColor: AppColors.settingsPrivacy,
                label: l10n.settingsPrivacyPolicy,
                onTap: () => context.push(
                  RouteNames.settingsPlaceholder,
                  extra: SettingsPlaceholderArgs(
                    title: l10n.settingsPrivacyPolicy,
                    icon: AppIcons.shield,
                  ),
                ),
              ),
              _NavTile(
                icon: AppIcons.fileText,
                iconColor: theme.colorScheme.onSurfaceVariant,
                label: l10n.settingsTermsOfService,
                onTap: () => context.push(
                  RouteNames.settingsPlaceholder,
                  extra: SettingsPlaceholderArgs(
                    title: l10n.settingsTermsOfService,
                    icon: AppIcons.fileText,
                  ),
                ),
              ),
              _NavTile(
                icon: AppIcons.starOutline,
                iconColor: AppColors.settingsRate,
                label: l10n.settingsRateApp,
                onTap: () => context.push(
                  RouteNames.settingsPlaceholder,
                  extra: SettingsPlaceholderArgs(
                    title: l10n.settingsRateApp,
                    icon: AppIcons.starOutline,
                  ),
                ),
              ),
              _NavTile(
                icon: AppIcons.logout,
                iconColor: theme.colorScheme.error,
                label: l10n.settingsLogout,
                onTap: () => _signOut(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) {
    getIt<CurrentUser>().value = null;
    context.go(RouteNames.auth);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 64),
                child: Divider(height: 1),
              ),
          ],
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _IconBadge(icon: icon, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                Text(
                  trailing!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Icon(
                AppIcons.chevronRight,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _IconBadge(icon: icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}