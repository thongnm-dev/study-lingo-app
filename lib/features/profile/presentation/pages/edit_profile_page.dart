import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/service_locator.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/session/current_user.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/unsaved_changes_guard.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../bloc/edit_profile_cubit.dart';

/// "Chỉnh sửa hồ sơ" — lets the user update display name, avatar URL, and
/// gender. Seeded from the signed-in [AuthUser] in `CurrentUser`; on save,
/// writes the new user back into `CurrentUser` (the only persistence today)
/// and pops back to the profile screen.
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<CurrentUser>().value!;
    return BlocProvider(
      create: (_) => getIt<EditProfileCubit>(param1: user),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == EditProfileStatus.saved) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(l10n.editProfileSaved),
              ),
            );
          context.pop();
        }
      },
      builder: (context, state) {
        return UnsavedChangesGuard(
          isDirty: state.isDirty,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(AppIcons.arrowBack),
                onPressed: () => UnsavedChangesGuard.maybePop(
                  context,
                  isDirty: state.isDirty,
                ),
              ),
              title: Text(l10n.editProfileTitle),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                _AvatarPreview(
                  photoUrl: state.photoUrl.trim(),
                  displayName: state.displayName.trim().isEmpty
                      ? (state.initial.email ?? '?')
                      : state.displayName,
                ),
                const SizedBox(height: 28),
                _FieldLabel(l10n.editProfileNameLabel),
                const SizedBox(height: 8),
                _NameField(initial: state.initial.displayName ?? ''),
                const SizedBox(height: 20),
                _FieldLabel(l10n.editProfilePhotoLabel),
                const SizedBox(height: 8),
                _PhotoField(initial: state.initial.photoUrl ?? ''),
                const SizedBox(height: 20),
                _FieldLabel(l10n.editProfileGenderLabel),
                const SizedBox(height: 8),
                _GenderPicker(selected: state.gender),
                const SizedBox(height: 32),
                _SaveButton(enabled: state.canSave),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({required this.photoUrl, required this.displayName});

  final String photoUrl;
  final String displayName;

  String get _initials {
    final source = displayName.trim();
    if (source.isEmpty) return '?';
    final parts = source.split(RegExp(r'\s+'));
    return parts.take(2).map((p) => p[0]).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(color: scheme.primary, width: 2),
        ),
        alignment: Alignment.center,
        child: ClipOval(
          child: photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _initialsLabel(scheme),
                )
              : _initialsLabel(scheme),
        ),
      ),
    );
  }

  Widget _initialsLabel(ColorScheme scheme) => Center(
    child: Text(
      _initials,
      style: TextStyle(
        color: scheme.primary,
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _NameField extends StatefulWidget {
  const _NameField({required this.initial});
  final String initial;

  @override
  State<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<_NameField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.next,
      decoration: _fieldDecoration(
        context,
        hint: l10n.editProfileNameHint,
        icon: AppIcons.person,
      ),
      onChanged: (v) => context.read<EditProfileCubit>().displayNameChanged(v),
    );
  }
}

class _PhotoField extends StatefulWidget {
  const _PhotoField({required this.initial});
  final String initial;

  @override
  State<_PhotoField> createState() => _PhotoFieldState();
}

class _PhotoFieldState extends State<_PhotoField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      decoration: _fieldDecoration(
        context,
        hint: l10n.editProfilePhotoHint,
        icon: AppIcons.personFilled,
      ),
      onChanged: (v) => context.read<EditProfileCubit>().photoUrlChanged(v),
    );
  }
}

class _GenderPicker extends StatelessWidget {
  const _GenderPicker({required this.selected});
  final Gender? selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = <_GenderOption>[
      _GenderOption(Gender.male, l10n.editProfileGenderMale),
      _GenderOption(Gender.female, l10n.editProfileGenderFemale),
      _GenderOption(Gender.other, l10n.editProfileGenderOther),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          ChoiceChip(
            label: Text(option.label),
            selected: selected == option.value,
            onSelected: (picked) {
              context
                  .read<EditProfileCubit>()
                  .genderChanged(picked ? option.value : null);
            },
          ),
      ],
    );
  }
}

class _GenderOption {
  const _GenderOption(this.value, this.label);
  final Gender value;
  final String label;
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.enabled});
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [scheme.primary, scheme.tertiary]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: enabled ? () => _onSave(context) : null,
            child: SizedBox(
              height: 56,
              child: Center(
                child: Text(
                  l10n.editProfileSave,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSave(BuildContext context) {
    final updated = context.read<EditProfileCubit>().save();
    if (updated != null) {
      getIt<CurrentUser>().value = updated;
    }
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration(
  BuildContext context, {
  required String hint,
  required IconData icon,
}) {
  final scheme = Theme.of(context).colorScheme;
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
    border: border(Colors.transparent),
    enabledBorder: border(Colors.transparent),
    focusedBorder: border(scheme.primary, 1.6),
  );
}
