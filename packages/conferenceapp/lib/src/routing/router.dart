import 'package:devfest24/src/features/dashboard/presentation/screens/dashboard.dart';
import 'package:devfest24/src/features/more/presentation/presentation.dart';
import 'package:devfest24/src/features/onboarding/presentation/presentation.dart';
import 'package:devfest24/src/features/schedule/presentation/presentation.dart';
import 'package:devfest24/src/features/speakers/presentation/presentation.dart';

import '../features/dashboard/model/model.dart';
import 'package:flutter/material.dart';

class Devfest2024Router {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  Devfest2024Router._();

  static final Devfest2024Router instance = Devfest2024Router._();

  static String initialRoute = DashboardScreen.route;

  Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    return switch (settings.name) {
      OnboardingHomeScreen.route =>
        MaterialPageRoute(builder: (_) => const OnboardingHomeScreen()),
      OnboardingLoginScreen.route =>
        MaterialPageRoute(builder: (_) => const OnboardingLoginScreen()),
      OnboardingSignatureScreen.route =>
        MaterialPageRoute(builder: (_) => const OnboardingSignatureScreen()),
      DashboardScreen.route =>
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      ScheduleDetailsScreen.route =>
        MaterialPageRoute(builder: (_) =>  ScheduleDetailsScreen(session:settings.arguments as SessionDto,)),
      SpeakerDetailsScreen.route => MaterialPageRoute(
          builder: (_) =>
              SpeakerDetailsScreen(speaker: settings.arguments as SpeakerDto)),
      MyQrCodeScreen.route =>
        MaterialPageRoute(builder: (_) => const MyQrCodeScreen()),
      ProfileScreen.route =>
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      VenueMapScreen.route =>
        MaterialPageRoute(builder: (_) => const VenueMapScreen()),
      _ => MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        ),
    };
  }

// GoRouter _getRouter(WidgetRef ref) {
//   return GoRouter(
//     navigatorKey: rootNavigatorKey,
//     initialLocation: '/',
//     extraCodec: const ConferenceExtraCodec(),
//     redirect: (context, state) async {
//       final token = await ConferenceAppStorageService.instance.userToken;
//       if (token.isEmpty) {
//         return '/${Devfest2024Routes.onboardingHome.path}';
//       }
//
//       return null;
//     },
//     routes: [
//       GoRoute(
//         path: '/${Devfest2024Routes.onboardingHome.path}',
//         name: Devfest2024Routes.onboardingHome.name,
//         builder: (context, state) => const OnboardingHomeScreen(),
//         routes: [
//           GoRoute(
//             path: Devfest2024Routes.onboardingLogin.path,
//             name: Devfest2024Routes.onboardingLogin.name,
//             builder: (context, state) => const OnboardingLoginScreen(),
//           ),
//           GoRoute(
//             path: Devfest2024Routes.onboardingSignature.path,
//             name: Devfest2024Routes.onboardingSignature.name,
//             builder: (context, state) => const OnboardingSignatureScreen(),
//           ),
//         ],
//       ),
//       GoRoute(
//         path: '/',
//         name: Devfest2024Routes.dashboard.name,
//         builder: (context, state) => const DashboardScreen(),
//         routes: [
//           GoRoute(
//             path: Devfest2024Routes.speakerDetails.path,
//             name: Devfest2024Routes.speakerDetails.name,
//             builder: (context, state) => SpeakerDetailsScreen(
//               speaker: state.extra as SpeakerDto,
//             ),
//           ),
//           GoRoute(
//             path: Devfest2024Routes.scheduleDetails.path,
//             name: Devfest2024Routes.scheduleDetails.name,
//             builder: (context, state) => const ScheduleDetailsScreen(),
//           ),
//           GoRoute(
//             path: Devfest2024Routes.profile.path,
//             name: Devfest2024Routes.profile.name,
//             builder: (context, state) => const ProfileScreen(),
//           ),
//           GoRoute(
//             path: Devfest2024Routes.myQrCode.path,
//             name: Devfest2024Routes.myQrCode.name,
//             builder: (context, state) => const MyQrCodeScreen(),
//           ),
//           GoRoute(
//             path: Devfest2024Routes.venueMap.path,
//             name: Devfest2024Routes.venueMap.name,
//             builder: (context, state) => const VenueMapScreen(),
//           ),
//         ],
//       ),
//     ],
//   );
// }
}

extension BuildContextX on BuildContext {
  void pop<T extends Object>([T? result]) => Navigator.of(this).pop<T>(result);

  Future<dynamic> goNamed(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  Future<dynamic> goNamedAndPopAll(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamedAndRemoveUntil(routeName, (route) => false,
          arguments: arguments);
}
