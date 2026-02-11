## Purpose
This file gives concise, actionable guidance to AI coding agents working on the Bluestone Preschool Flutter app.

## Big picture
- Flutter mobile app using `provider` for DI/state, `sizer` for responsive sizing, and plain Flutter routing via a central `AppRoutes` map.
- Entry point: [lib/main.dart](lib/main.dart#L1-L80) — note `Sizer` wraps `MaterialApp` and `NavigatorService.navigatorKey` is used for app-wide navigation.
- Routes: [lib/routes/app_routes.dart](lib/routes/app_routes.dart#L1-L60) — screens live under `lib/presentation/` and expose static `.builder` members used in the routes map.
- Shared exports and utilities: [lib/core/app_export.dart](lib/core/app_export.dart#L1-L80) centralizes commonly-used exports (Provider, navigator service, theme helpers, image/size utils).

## Critical code regions (DO NOT MODIFY lightly)
- Orientation lock: `main()` sets `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])`. This is an intentional constraint; do not remove. See [lib/main.dart](lib/main.dart#L1-L40).
- MediaQuery text scaler: `MaterialApp.builder` wraps `child` and forces `textScaler` with `TextScaler.linear(1.0)`. This is a deliberate accessibility/layout behavior; preserve it. See [lib/main.dart](lib/main.dart#L20-L60).

## Navigation patterns
- Use the `NavigatorService` helpers exported via `lib/core/app_export.dart`.
  - Examples:
    - `NavigatorService.pushNamed(AppRoutes.welcomeScreen);`
    - `NavigatorService.popAndPushNamed(AppRoutes.servicesHomeScreen);`
  - Implementation: [lib/core/utils/navigator_service.dart](lib/core/utils/navigator_service.dart#L1-L120).
- Routes map uses static builders (e.g., `WelcomeScreen.builder`). When adding screens, export their builder and add the route string to `AppRoutes`.

## State & DI
- The project uses `provider` (see `pubspec.yaml`). Global/common providers are typically wired near top-level widgets; look for `MultiProvider` if used, otherwise local `ChangeNotifierProvider` in screens.

## Assets, images & sizing
- All images are in `assets/images/` and referenced via `ImageConstant` helpers in `lib/core/utils/image_constant.dart`.
- Responsive sizing is done with `sizer` and `size_utils.dart`. When changing layout, prefer `Sizer`-aware sizes.

## Theming & text
- Theme helpers live in `lib/theme/theme_helper.dart` and `lib/theme/text_style_helper.dart`. Use these to stay consistent with app-wide colors and typography.

## Localization
- `flutter_localizations` is enabled in `main.dart` with `supportedLocales: [Locale('en', '')]`. If you add locales, update `main.dart` and any localization assets accordingly.

## Build, run, test commands (project-specific)
- Fetch deps: `flutter pub get`
- Run on connected mobile device: `flutter run`
- Run on Windows desktop (if needed): `flutter run -d windows`
- Analyze: `flutter analyze`
- Unit/widget tests: `flutter test`

## Conventions & patterns to follow
- Route strings are centralized in `AppRoutes` — add new route constants there and map them to the screen `.builder`.
- Screens in `lib/presentation/` expose a `static WidgetBuilder get builder` pattern used throughout the routes map. Follow existing screen files for examples (e.g., `welcome_screen.dart`).
- Keep exports for frequently-used utilities in `lib/core/app_export.dart` to avoid long relative imports.

## Integration points & dependencies
- Main dependencies (see `pubspec.yaml`): `provider`, `sizer`, `google_fonts`, `cached_network_image`, `flutter_svg`.
- Navigation relies on `NavigatorService.navigatorKey` (global navigator), not direct `BuildContext` navigation in some places — prefer the service helpers for cross-widget navigation.

## Examples (copy-paste-safe)
- Push a route:

  ```dart
  import 'package:bluestone_preschool/core/app_export.dart';

  // ...
  NavigatorService.pushNamed(AppRoutes.servicesHomeScreen);
  ```

- Adding a new screen:
  - Create `lib/presentation/your_screen/your_screen.dart` exposing `static WidgetBuilder get builder => (c) => YourScreen();`
  - Add route constant in `AppRoutes` and map it to `YourScreen.builder`.

## What NOT to change
- Do not remove the orientation lock or the `MediaQuery` scaler in `main.dart` without discussing with maintainers — both are flagged with `// 🚨 CRITICAL` comments in-code.

## Questions / gaps for maintainers
- Where are global `Provider` setups (if any)? If there is an app-level `MultiProvider`, indicate the file path so agents can wire new providers appropriately.
- If there are CI or release steps (code signing, flavor builds, or custom gradle tasks), add them here.

---
If you want I can merge this into any existing agent docs or expand examples (e.g., show a full example screen file). Any missing files or conventions I should include? 
