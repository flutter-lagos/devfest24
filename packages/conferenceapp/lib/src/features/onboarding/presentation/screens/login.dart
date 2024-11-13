import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/features/onboarding/application/session_sign_in_vm.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/screens/dashboard.dart';

final _emailRegexp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class OnboardingLoginScreen extends ConsumerStatefulWidget {
  static const route = '/onboarding/login';

  const OnboardingLoginScreen({super.key});

  @override
  ConsumerState<OnboardingLoginScreen> createState() =>
      _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends ConsumerState<OnboardingLoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ref.listenManual(sessionSignInVMNotifier, (previous, next) {
      if (next.uiState.isSuccess) {
        context.goNamedAndPopAll(DashboardScreen.route);
        return;
      }
    });
  }

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
      body: IgnorePointer(
        ignoring: ref.watch(
            sessionSignInVMNotifier.select((vm) => vm.uiState.isLoading)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constants.horizontalMargin.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: FocusTraversalGroup(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const HeaderText(
                                    title: Text(
                                        'Welcome to DevFest Lagos 2024 🥳'),
                                    subtitle:
                                        Text('Enter your details to continue!'),
                                  ),
                                  Constants.largeVerticalGutter.verticalSpace,
                                  DevfestTextFormField(
                                    title: 'Email Address',
                                    hint: 'e.g senatorofthebu@gmail.com',
                                    onChanged: ref
                                        .read(sessionSignInVMNotifier.notifier)
                                        .emailAddressOnChanged,
                                    onEditingComplete:
                                        FocusScope.of(context).nextFocus,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Email Address cannot be empty';
                                      }

                                      if (!_emailRegexp.hasMatch(value!)) {
                                        return 'Please enter a valid email address';
                                      }

                                      return null;
                                    },
                                  ),
                                  Constants.largeVerticalGutter.verticalSpace,
                                  DevfestTextFormField(
                                    title: 'Ticket ID',
                                    hint: 'e.g 413-012-ABC',
                                    onChanged: ref
                                        .read(sessionSignInVMNotifier.notifier)
                                        .ticketIdOnChanged,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Ticket Id cannot be empty';
                                      }

                                      if (value!.length <= 3) {
                                        return 'Please enter a valid ticket ID';
                                      }

                                      return null;
                                    },
                                  ),
                                  Constants.largeVerticalGutter.verticalSpace,
                                  Text.rich(
                                    TextSpan(
                                      text: 'Looking for your ticket ID? ',
                                      style: DevfestTheme.of(context)
                                          .textTheme
                                          ?.bodyBody2Medium
                                          ?.medium
                                          .apply(
                                              color: DevfestColors
                                                  .grey60.possibleDarkVariant),
                                      children: [
                                        TextSpan(
                                          text: 'Click Here',
                                          style: TextStyle(
                                                  color: DevfestColors.grey10
                                                      .possibleDarkVariant)
                                              .semi,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      DevfestFilledButton(
                        title: const Text('Next'),
                        prefixIcon: ref.watch(sessionSignInVMNotifier
                                .select((vm) => vm.uiState.isLoading))
                            ? const CircularProgressIndicator.adaptive(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                                backgroundColor: Colors.white,
                                strokeWidth: 2.0,
                              )
                            : null,
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            FocusScope.of(context).unfocus();
                            ref
                                .read(sessionSignInVMNotifier.notifier)
                                .initialiseUserSession();
                          }
                          // context.goNamed(
                          //     Devfest2024Routes.onboardingSignature.name);
                        },
                      ),
                      DevfestFilledButton(
                        title: const Text('Continue as Guest'),
                        backgroundColor: Colors.transparent,
                        titleStyle: TextStyle(
                            color: DevfestColors.grey10.possibleDarkVariant),
                        onPressed: () {
                          context.goNamedAndPopAll(DashboardScreen.route);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
