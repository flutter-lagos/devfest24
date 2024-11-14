import 'package:cave/cave.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:flutter/material.dart';

import '../../features/onboarding/presentation/presentation.dart';

class CheckInButton extends StatelessWidget {
  const CheckInButton({
    super.key,
    this.isLoggedIn = false,
    this.onCheckInTap,
    this.onLoginTap,
  });

  final bool isLoggedIn;
  final VoidCallback? onCheckInTap;
  final VoidCallback? onLoginTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 113.w,
      child: isLoggedIn
          ? _CheckInButton(onCheckInTap)
          : _LoginCheckInButton(() {
              context.goNamedAndPopAll(OnboardingLoginScreen.route);
              ConferenceAppStorageService.instance.setIsFirstLaunch(true);
            }),
    );
  }
}

class _CheckInButton extends StatelessWidget {
  const _CheckInButton(this.onTap);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DevfestFilledButton.small(
      onPressed: onTap,
      prefixIcon: const Icon(IconsaxOutline.shield, size: 20),
      title: const Text('Check-In'),
      titleStyle: const TextStyle().semi,
    );
  }
}

class _LoginCheckInButton extends StatelessWidget {
  const _LoginCheckInButton(this.onTap);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DevfestFilledButton.small(
      onPressed: onTap,
      title: const Text('Log In'),
      backgroundGradient: DevfestColors.inverseGradientGradient,
      titleStyle: const TextStyle().semi,
    );
  }
}
