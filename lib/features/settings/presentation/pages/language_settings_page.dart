import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/app_language.dart';
import '../bloc/locale_cubit.dart';

/// "Ngôn ngữ hiển thị" screen (Settings → Ngôn ngữ hiển thị). Lists the
/// supported display languages by their native names; picking one updates the
/// app-root [LocaleCubit], so the whole UI re-localizes immediately.
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsLanguage)),
      body: BlocBuilder<LocaleCubit, AppLanguage>(
        builder: (context, selected) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  l10n.languageSettingsDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              for (final language in AppLanguage.values)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  title: Text(
                    language.nativeLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: language == selected
                      ? Icon(AppIcons.check, color: theme.colorScheme.primary)
                      : null,
                  onTap: () => context.read<LocaleCubit>().select(language),
                ),
            ],
          );
        },
      ),
    );
  }
}
