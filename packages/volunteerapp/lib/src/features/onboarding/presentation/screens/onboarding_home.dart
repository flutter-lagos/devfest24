import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:volunteerapp/src/routing/routing.dart';
import 'package:volunteerapp/src/shared/shared.dart';

class OnboardingHomeScreen extends StatelessWidget {
  const OnboardingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: SvgPicture.asset(
          'images/logo.svg',
          package: 'cave',
          width: 16,
          height: 29,
          semanticsLabel: 'GDG Logo',
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.horizontalMargin.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderText(
                    title: Text('Get attendees checked in faster than before'),
                    subtitle: Text(
                      'Hey rockstar volunteer, we have made attendees check in more convenient for you.',
                    ),
                  ),
                  SizedBox(height: (Constants.largeVerticalGutter * 3).h),
                  DevfestFilledButton(
                    onPressed: () {
                      context.goNamed(Devfest2024Routes.onboardingLogin.name);
                    },
                    title: const Text('Login'),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'images/volunteer_onboarding.svg',
                package: 'cave',
                semanticsLabel: 'Onboarding Image',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
