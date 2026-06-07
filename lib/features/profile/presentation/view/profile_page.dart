import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../progress/domain/repositories/progress_repository.dart';
import '../../../settings/presentation/view/settings_page.dart';
import '../cubit/profile_stats_cubit.dart';

/// "Hồ sơ" screen. Shows the signed-in [user]'s identity plus lifetime study
/// stats (from the shared ProgressRepository), and lets them sign out.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileStatsCubit(context.read<ProgressRepository>()),
      child: _ProfileView(user: user),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.settings),
            tooltip: l10n.settingsTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Header(user: user),
          const SizedBox(height: 24),
          const _StatsRow(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final AuthUser user;

  static const _providerLabels = {
    AuthProvider.email: 'Email',
    AuthProvider.google: 'Google',
    AuthProvider.facebook: 'Facebook',
  };

  String get _displayName => user.displayName ?? user.email ?? 'Learner';

  String get _initials {
    final source = _displayName.trim();
    if (source.isEmpty) return '?';
    final parts = source.split(RegExp(r'\s+'));
    final letters = parts.take(2).map((p) => p[0]).join();
    return letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoUrl = user.photoUrl;
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: Text(
            _initials,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(_displayName, style: theme.textTheme.headlineSmall),
        if (user.email != null)
          Text(
            user.email!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: 8),
        Chip(
          avatar: const Icon(AppIcons.verified, size: 18),
          label: Text(
            AppLocalizations.of(
              context,
            ).profileSignedInWith(_providerLabels[user.provider]!),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileStatsCubit, ProfileStats>(
      builder: (context, stats) {
        if (!stats.loaded) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final l10n = AppLocalizations.of(context);
        return Row(
          children: [
            _StatCard(
              icon: AppIcons.fire,
              value: '${stats.streak}',
              label: l10n.profileStreakLabel,
            ),
            const SizedBox(width: 12),
            _StatCard(
              icon: AppIcons.star,
              value: '${stats.totalXp}',
              label: l10n.profileTotalXpLabel,
            ),
            const SizedBox(width: 12),
            _StatCard(
              icon: AppIcons.bookOpen,
              value: '${stats.lessonsCompleted}',
              label: l10n.profileLessonsLabel,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 8),
              Text(value, style: theme.textTheme.titleLarge),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
