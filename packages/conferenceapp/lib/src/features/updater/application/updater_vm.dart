import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

enum UpdaterStatus {
  idle,
  updateCheckInProgress,
  downloadInProgress,
}

class UpdaterState extends Equatable {
  final UpdaterStatus status;
  final bool updateAvailable;
  final bool isNewPatchReadyToInstall;

  const UpdaterState({
    this.status = UpdaterStatus.idle,
    this.updateAvailable = false,
    this.isNewPatchReadyToInstall = false,
  });

  UpdaterState copyWith({
    UpdaterStatus? status,
    bool? updateAvailable,
    bool? isNewPatchReadyToInstall,
  }) {
    return UpdaterState(
      status: status ?? this.status,
      updateAvailable: updateAvailable ?? this.updateAvailable,
      isNewPatchReadyToInstall:
          isNewPatchReadyToInstall ?? this.isNewPatchReadyToInstall,
    );
  }

  @override
  List<Object?> get props =>
      [status, updateAvailable, isNewPatchReadyToInstall];
}

class UpdaterNotifier extends StateNotifier<UpdaterState> {
  UpdaterNotifier({ShorebirdCodePush? codePush})
      : _codePush = codePush ?? ShorebirdCodePush(),
        super(const UpdaterState()) {
    Future.microtask(() => init());
  }

  final ShorebirdCodePush _codePush;

  Future<void> init() async {
    await checkForUpdates();
  }

  Future<void> checkForUpdates() async {
    state = state.copyWith(status: UpdaterStatus.updateCheckInProgress);
    try {
      final updateAvailable = await _codePush.isNewPatchAvailableForDownload();
      state = state.copyWith(
        status: UpdaterStatus.idle,
        updateAvailable: updateAvailable,
      );
      if (updateAvailable) await _downloadUpdate();
    } catch (error, _) {
      // Handle error (e.g., log it)
      state = state.copyWith(
        status: UpdaterStatus.idle,
        updateAvailable: true,
      );
    }
  }

  Future<void> _downloadUpdate() async {
    state = state.copyWith(status: UpdaterStatus.downloadInProgress);
    try {
      await _codePush.downloadUpdateIfAvailable();
    } catch (error, _) {
      // Handle error (e.g., log it)
    }
    try {
      final isNewPatchReadyToInstall =
          await _codePush.isNewPatchReadyToInstall();
      state = state.copyWith(
        isNewPatchReadyToInstall: isNewPatchReadyToInstall,
        status: UpdaterStatus.idle,
      );
    } catch (error, _) {
      // Handle error (e.g., log it)
      state = state.copyWith(
        isNewPatchReadyToInstall: false,
        status: UpdaterStatus.idle,
      );
    }
  }
}

final updaterProvider =
    StateNotifierProvider<UpdaterNotifier, UpdaterState>((ref) {
  return UpdaterNotifier();
});
