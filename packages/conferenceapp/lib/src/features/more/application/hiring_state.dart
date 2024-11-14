part of 'hiring_vm.dart';

final class HiringState extends Devfest2024UiState {
  final String resumeLink;

  const HiringState({
    super.uiState,
    super.error,
    this.resumeLink = '',
  });

  HiringState copyWith({
    UiState? uiState,
    Devfest2024Exception? error,
    String? resumeLink,
  }) {
    return HiringState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      resumeLink: resumeLink ?? this.resumeLink,
    );
  }

  @override
  List<Object?> get otherProps => [resumeLink];
}
