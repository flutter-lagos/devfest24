# devfest24

A new Flutter project.

## Getting Started

```sh
flutter pub get
```

```sh
dart run build_runner build -d
```

```sh
flutter run --dart-define-from-file=.env
```

```sh
flutter build apk --release --obfuscate --split-debug-info=./symbols --dart-define-from-file=.env
```

```sh
shorebird release android -- --obfuscate --split-debug-info=./symbols --dart-define-from-file=.env
```

```sh
shorebird patch --platforms=android
```