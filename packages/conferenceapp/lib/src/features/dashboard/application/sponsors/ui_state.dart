part of 'view_model.dart';

final class SponsorsUiState extends Devfest2024UiState {
  final List<SponsorDto> sponsors;

  const SponsorsUiState({
    super.error,
    super.uiState,
    required this.sponsors,
  });

  const SponsorsUiState.initial() : this(sponsors: const []);

  SponsorsUiState copyWith({
    List<SponsorDto>? sponsors,
    UiState? uiState,
    Devfest2024Exception? error,
  }) {
    return SponsorsUiState(
      sponsors: sponsors ?? this.sponsors,
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get otherProps => [sponsors];
}
