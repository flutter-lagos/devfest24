import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/application/application.dart';
import '../../../onboarding/presentation/presentation.dart';
import '../presentation.dart';

class MoreHomeScreen extends ConsumerWidget {
  const MoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.horizontalMargin.w),
              child: Column(
                children: [
                  if (ref.watch(userViewModelNotifier
                      .select((vm) => vm.user.id.isNotEmpty)))
                    const SignedInUserHeaderTile()
                  else
                    SignedOutUserHeaderTile(
                      signInOnTap: () {
                        context.goNamed(OnboardingLoginScreen.route);
                        ConferenceAppStorageService.instance
                            .setIsFirstLaunch(true);
                      },
                    ),
                  MoreSection(
                    title: const Text('GENERAL'),
                    options: [
                      MoreButton(
                        title: const Text('Profile'),
                        icon: Icon(
                          IconsaxOutline.user,
                          size: 22.r,
                        ),
                        onTap: () {
                          context.goNamed(ProfileScreen.route);
                        },
                      ),
                      MoreButton(
                        title: const Text('My QR Code'),
                        icon: Icon(
                          IconsaxOutline.shield,
                          size: 22.r,
                        ),
                        onTap: () {
                          context.goNamed(MyQrCodeScreen.route);
                        },
                      ),
                      MoreButton(
                        title: const Text('Theme Settings'),
                        icon: Icon(
                          IconsaxOutline.component,
                          size: 22.r,
                        ),
                        onTap: () {},
                      ),
                      MoreButton(
                        title: const Text('Venue Map'),
                        icon: Icon(
                          IconsaxOutline.location,
                          size: 22.r,
                        ),
                        onTap: () {
                          context.goNamed(VenueMapScreen.route);
                        },
                      ),
                    ],
                  ),
                  MoreSection(
                    title: const Text('OTHERS'),
                    options: [
                      MoreButton(
                        title: const Text('About GDG Lagos'),
                        icon: Icon(
                          IconsaxOutline.heart,
                          size: 22.r,
                        ),
                        onTap: () => launchWebUrl('https://devfestlagos.com'),
                      ),
                      MoreButton(
                        title: const Text('Contact Us'),
                        icon: Icon(
                          IconsaxOutline.info_circle,
                          size: 22.r,
                        ),
                        onTap: () => launchWebUrl('https://devfestlagos.com'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: Constants.largeVerticalGutter),
            child: DevfestAppVersion(),
          ),
        ],
      ),
    );
  }
}

class MoreSection extends StatelessWidget {
  const MoreSection({super.key, required this.title, this.options = const []});

  final Widget title;
  final List<Widget> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          style: DevfestTheme.of(context)
              .textTheme!
              .bodyBody4Medium!
              .medium
              .applyColor(DevfestColors.grey60.possibleDarkVariant),
          duration: Constants.kAnimationDur,
          child: title,
        ),
        Constants.smallVerticalGutter.verticalSpace,
        ...options,
      ],
    );
  }
}

class MoreButton extends StatelessWidget {
  const MoreButton({super.key, this.icon, this.title, this.onTap});

  final Widget? icon;
  final Widget? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Constants.verticalGutter.h),
        child: Row(
          children: [
            if (icon != null) ...[
              icon!,
              Constants.smallVerticalGutter.horizontalSpace,
            ],
            if (title != null) ...[
              Expanded(child: title!),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 22,
                color: DevfestColors.grey60.possibleDarkVariant,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
