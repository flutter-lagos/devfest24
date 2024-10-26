import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class OnboardingHomeScreen extends StatelessWidget {
  static const route = '/onboarding';

  const OnboardingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                  children: [
                    const HeaderText(
                      title: Text(
                          'DevFest Lagos like you have never seen it before'),
                      subtitle: Text(
                        'We said we will see you again next year, here we are, we have missed you and prepared amazing things for you 🥺',
                      ),
                    ),
                    SizedBox(height: (Constants.largeVerticalGutter * 3).h),
                    DevfestFilledButton(
                      onPressed: () {
                        context.goNamedAndPopAll(OnboardingLoginScreen.route);
                      },
                      title: const Text('Let\'s Get This Bread Quickly'),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'images/conference_onboarding.svg',
                  package: 'cave',
                  semanticsLabel: 'Onboarding Image',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
