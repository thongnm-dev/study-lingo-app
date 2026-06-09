import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/auth_user.dart';

enum EditProfileStatus { editing, saved }

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.initial,
    required this.displayName,
    required this.photoUrl,
    required this.gender,
    required this.status,
  });

  factory EditProfileState.from(AuthUser user) => EditProfileState(
    initial: user,
    displayName: user.displayName ?? '',
    photoUrl: user.photoUrl ?? '',
    gender: user.gender,
    status: EditProfileStatus.editing,
  );

  final AuthUser initial;
  final String displayName;
  final String photoUrl;
  final Gender? gender;
  final EditProfileStatus status;

  bool get isNameValid => displayName.trim().isNotEmpty;

  bool get isDirty =>
      displayName.trim() != (initial.displayName ?? '').trim() ||
      photoUrl.trim() != (initial.photoUrl ?? '').trim() ||
      gender != initial.gender;

  bool get canSave => isNameValid && isDirty;

  EditProfileState copyWith({
    String? displayName,
    String? photoUrl,
    Gender? gender,
    bool clearGender = false,
    EditProfileStatus? status,
  }) {
    return EditProfileState(
      initial: initial,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: clearGender ? null : (gender ?? this.gender),
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    initial,
    displayName,
    photoUrl,
    gender,
    status,
  ];
}

/// Holds the edit-profile form state. Seeded from the signed-in [AuthUser]; the
/// page calls [save] to emit a `saved` status carrying the new user, and the
/// page's `BlocListener` writes that back into `CurrentUser` (mirroring how the
/// auth flow writes `CurrentUser` from the page boundary, not the bloc).
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(AuthUser user) : super(EditProfileState.from(user));

  void displayNameChanged(String value) {
    emit(state.copyWith(displayName: value));
  }

  void photoUrlChanged(String value) {
    emit(state.copyWith(photoUrl: value));
  }

  void genderChanged(Gender? value) {
    if (value == null) {
      emit(state.copyWith(clearGender: true));
    } else {
      emit(state.copyWith(gender: value));
    }
  }

  AuthUser? save() {
    if (!state.canSave) return null;
    final photo = state.photoUrl.trim();
    final updated = state.initial.copyWith(
      displayName: state.displayName.trim(),
      photoUrl: photo.isEmpty ? null : photo,
      clearPhotoUrl: photo.isEmpty,
      gender: state.gender,
      clearGender: state.gender == null,
    );
    emit(state.copyWith(status: EditProfileStatus.saved));
    return updated;
  }
}
