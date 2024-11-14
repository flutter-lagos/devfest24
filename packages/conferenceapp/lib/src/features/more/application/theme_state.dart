part of 'theme_vm.dart';

final class ThemeState extends Devfest2024UiState {
  final ThemeMode theme;

  const ThemeState({
    super.uiState,
    super.error,
    this.theme = ThemeMode.system,
  });

  ThemeState copyWith({
    UiState? uiState,
    Devfest2024Exception? error,
    ThemeMode? theme,
  }) {
    return ThemeState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get otherProps => [theme];
}
