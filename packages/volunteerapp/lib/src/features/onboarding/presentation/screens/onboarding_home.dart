import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:flutter/material.dart';
import 'package:volunteerapp/src/features/onboarding/presentation/screens/onboarding_login.dart';
import 'package:volunteerapp/src/routing/routing.dart';
import 'package:volunteerapp/src/shared/shared.dart';

class OnboardingHomeScreen extends StatelessWidget {
  const OnboardingHomeScreen({super.key});
  static const route = '/onboarding';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100.w,
        leading: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: Constants.horizontalMargin.w),
              child: GdgLogo.normal(),
            ),
          ],
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
                      context.goNamedAndPopAll(OnboardingLoginScreen.route);
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
