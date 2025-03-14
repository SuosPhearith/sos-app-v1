# Flutter Flavor boilerplate(.vscode)

- flutter pub get
- flutter pub run flutter_launcher_icons:main
- flutter pub run flutter_native_splash:create
- flutter pub clean
- flutter pub get
- fluter run

# run android

> flutter run --flavor dev -t lib/main.dart --dart-define=FLAVOR=dev

# run ios

> flutter run --flavor dev -t lib/main.dart --dart-define=FLAVOR=dev

# build android

> flutter build apk --flavor dev -t lib/main.dart --dart-define=FLAVOR=dev

# build ios

> flutter build ios --flavor dev -t lib/main.dart --dart-define=FLAVOR=dev

# Note

You can run in vscode direct just navigate to "run and debug" and select environment to run
