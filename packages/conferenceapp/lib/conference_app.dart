import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:cave/cave.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/features/more/application/theme_vm.dart';
import 'src/features/onboarding/presentation/presentation.dart';

class ConferenceApp extends ConsumerStatefulWidget {
  const ConferenceApp({super.key});

  @override
  ConsumerState<ConferenceApp> createState() => _ConferenceAppState();
}

class _ConferenceAppState extends ConsumerState<ConferenceApp> {
  final designSize = const Size(430, 956);

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final [dynamic isFirstLaunch, dynamic token] = await Future.wait([
        ConferenceAppStorageService.instance.isFirstLaunch,
        ConferenceAppStorageService.instance.userToken,
      ]);

      if (isFirstLaunch == true && (token.toString()).isEmpty) {
        Devfest2024Router.rootNavigatorKey.currentContext
            ?.goNamedAndPopAll(OnboardingHomeScreen.route);
        return;
      }
    });
  }

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: ScreenUtilInit(
        designSize: designSize,
        minTextAdapt: true,
        builder: (_, child) {
          final themeMode = ref.watch(themeVMNotifier);
          return MaterialApp(
            title: 'Devfest24 Conference App',
            debugShowCheckedModeBanner: false,
            navigatorKey: Devfest2024Router.rootNavigatorKey,
            initialRoute: Devfest2024Router.initialRoute,
            onGenerateRoute: Devfest2024Router.instance.onGenerateRoutes,
            builder: (context, child) => AccessibilityTools(
              minimumTapAreas: const MinimumTapAreas(mobile: 30, desktop: 44),
              checkFontOverflows: true,
              child: child,
            ),
            themeMode: themeMode.theme,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
                surface: DevFestThemeData.light().backgroundColor,
              ),
              scaffoldBackgroundColor: DevFestThemeData.light().backgroundColor,
              useMaterial3: true,
              textTheme: const TextTheme(
                displayMedium: TextStyle(color: DevfestColors.grey10),
              ),
              appBarTheme: AppBarTheme(
                elevation: 0,
                color: DevFestThemeData.light().backgroundColor,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                scrolledUnderElevation: 0,
              ),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: DevfestColors.warning100,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
              ),
              extensions: <ThemeExtension<dynamic>>[
                DevFestThemeData.light(),
              ],
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
                surface: DevFestThemeData.dark().backgroundColor,
              ),
              appBarTheme: AppBarTheme(
                elevation: 0,
                color: DevFestThemeData.dark().backgroundColor,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
              ),
              scaffoldBackgroundColor: DevFestThemeData.dark().backgroundColor,
              useMaterial3: true,
              textTheme: const TextTheme(
                displayMedium: TextStyle(color: DevfestColors.grey100),
              ),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: DevfestColors.backgroundDark,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                    side: BorderSide(
                        color: DevfestColors.backgroundLight, width: 1)),
              ),
              extensions: <ThemeExtension<dynamic>>[
                DevFestThemeData.dark(),
              ],
            ),
          );
        },
      ),
    );
  }
}
