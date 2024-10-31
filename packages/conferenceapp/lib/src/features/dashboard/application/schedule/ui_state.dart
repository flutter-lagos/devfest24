part of 'view_model.dart';

final class ScheduleUiState extends Devfest2024UiState {
  final ScheduleDto schedule;

  const ScheduleUiState({
    super.uiState,
    super.error,
    required this.schedule,
  });

  const ScheduleUiState.initial() : this(schedule: const ScheduleDto.empty());

  ScheduleUiState copyWith({
    UiState? uiState,
    Devfest2024Exception? error,
    ScheduleDto? schedule,
  }) {
    return ScheduleUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  List<Object?> get otherProps => [schedule];
}
