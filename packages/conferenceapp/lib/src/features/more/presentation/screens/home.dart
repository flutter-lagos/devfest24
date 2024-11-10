import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/application/application.dart';
import '../../../onboarding/presentation/presentation.dart';
import '../../application/theme_vm.dart';
import '../presentation.dart';

class MoreHomeScreen extends ConsumerWidget {
  const MoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeVM = ref.read(themeVMNotifier.notifier);
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
                      if (ref.watch(userViewModelNotifier
                          .select((vm) => vm.user.id.isNotEmpty)))
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
                      if (ref.watch(userViewModelNotifier
                          .select((vm) => vm.user.id.isNotEmpty)))
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
                        onTap: () {
                          showDevfestBottomModal(
                            context,
                            child: Consumer(
                              builder: (context, ref, child) {
                                final currentTheme = ref.watch(themeVMNotifier);

                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Select App Theme',
                                        style: DevfestTheme.of(context)
                                            .textTheme
                                            ?.bodyBody1Semibold
                                            ?.semi,
                                      ),
                                      Constants
                                          .largeHorizontalGutter.verticalSpace,
                                      ...ThemeMode.values.map(
                                        (theme) => _CustomRadioTile<ThemeMode>(
                                          value: theme,
                                          activeColor:
                                              DevfestColors.primariesYellow50,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8.0),
                                          groupValue: currentTheme.theme,
                                          onChanged: (ThemeMode? newTheme) {
                                            if (newTheme != null) {
                                              themeVM.onThemeChange(newTheme);
                                              context.pop();
                                            }
                                          },
                                          title: Text(
                                            '${theme.name.capitalize} Theme',
                                            style: DevfestTheme.of(context)
                                                .textTheme
                                                ?.bodyBody1Medium
                                                ?.medium,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
                        onTap: () => launchWebUrl('https://x.com/gdglagos'),
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

// ignore: unused_element
class _CustomRadioTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final Widget title;
  final Color activeColor;
  final EdgeInsetsGeometry contentPadding;
  final BorderRadius? borderRadius;

  const _CustomRadioTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.activeColor = Colors.yellow,
    this.contentPadding = const EdgeInsets.all(0),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: borderRadius,
      child: Container(
        padding: contentPadding,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
        ),
        child: Row(
          children: [
            Semantics(
              label: 'theme radio button',
              child: Transform.scale(
                scale: 1.5,
                child: Radio<T>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: activeColor,
                ),
              ),
            ),
            Constants.largeHorizontalGutter.horizontalSpace,
            Expanded(child: title),
          ],
        ),
      ),
    );
  }
}
