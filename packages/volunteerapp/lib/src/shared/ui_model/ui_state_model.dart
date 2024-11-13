import 'dart:async';
import 'package:cave/cave.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../routing/router.dart';

part 'ui_state_model_mutex.dart';

final _$vmWriteMutex = UiStateMutex();

typedef Devfest2024UiModelRef<T extends Devfest2024UiState> = List<T>;

enum UiState {
  idle,
  loading,
  success,
  error;

  bool get isLoading => this == UiState.loading;

  bool get isError => this == UiState.error;

  bool get isSuccess => this == UiState.success;

  bool get isIdle => this == UiState.idle;
}

@immutable
abstract base class Devfest2024UiState extends Equatable {
  const Devfest2024UiState({
    this.error = const EmptyException(),
    this.uiState = UiState.idle,
  });

  final UiState uiState;

  final Devfest2024Exception error;

  @override
  bool? get stringify => true;
}

Future<void> launch<E extends Devfest2024UiState>(
  Devfest2024UiStateRef<E> model,
  FutureOr<void> Function(Devfest2024UiStateRef<E> model) function, {
  bool displayError = true,
  bool Function(E state) canDisplayError = _kDisplayError,
}) async {
  final result = await _$vmWriteMutex.protect<E>(() async {
    await function(model);
    return model._state;
  });

  if (!displayError || !canDisplayError(result)) return;
  result.displayError();
}

bool _kDisplayError([_]) => true;

extension ViewModelX<T extends Devfest2024UiState> on T {
  Devfest2024UiStateRef<T> get ref => Devfest2024UiStateRef(this);

  void displayError() async {
    if (uiState != UiState.error) return;
    assert(error is! EmptyException, 'Please pass appropriate exception');

    final context = rootNavigatorKey.currentContext!;

    final snackbar = SnackBar(
      content: Text(error.toString()),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

extension Devfest2024UiModelRefX<T extends Devfest2024UiState>
    on Devfest2024UiStateRef<T> {
  Devfest2024UiStateRef<T> _assign(T value) => this.._state = value;

  T emit(T value) => _assign(value)._state;
}

class Devfest2024UiStateRef<T extends Devfest2024UiState> {
  T _state;

  Devfest2024UiStateRef(this._state);

  T emit(T value) {
    _state = value;
    return _state;
  }

  @override
  int get hashCode => _state.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Devfest2024UiStateRef) return false;

    return _state == other._state;
  }
}
