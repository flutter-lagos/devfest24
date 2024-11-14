import 'package:cave/cave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/home/presentation/screens/home_screen.dart';
import 'package:volunteerapp/src/features/onboarding/application/sign_in_view_model.dart';
import 'package:volunteerapp/src/routing/routing.dart';
import 'package:volunteerapp/src/shared/shared.dart';

final _emailRegexp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class OnboardingLoginScreen extends ConsumerStatefulWidget {
  const OnboardingLoginScreen({super.key});
  static const route = '/onboarding/login';

  @override
  ConsumerState<OnboardingLoginScreen> createState() =>
      _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends ConsumerState<OnboardingLoginScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    ref.listenManual(signInVMNotifier, (previos, next) {
      if (next.uiState.isSuccess) {
        context.goNamedAndPopAll(HomeScreen.route);

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
        ignoring:
            ref.watch(signInVMNotifier.select((vm) => vm.uiState.isLoading)),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(Constants.horizontalMargin.w, 0.0,
                Constants.horizontalMargin.w, 78.h),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const HeaderText(
                            title: Text('Login 🤙🏾'),
                            subtitle: Text('Enter your details to continue!'),
                          ),
                          (Constants.largeVerticalGutter +
                                  Constants.verticalGutter)
                              .verticalSpace,
                          DevfestTextFormField(
                            title: 'Email Address',
                            hint: 'e.g senatorofthebu@gmail.com',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email Address cannot be empty';
                              }
                              if (!_emailRegexp.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onChanged: ref
                                .read(signInVMNotifier.notifier)
                                .onEmailChanged,
                            onEditingComplete: FocusScope.of(context).nextFocus,
                          ),
                          Constants.verticalGutter.verticalSpace,
                          DevfestTextFormField(
                              title: 'Password ( Id )',
                              hint: 'Enter password',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                if (value.length <= 3) {
                                  return 'Please enter a valid ticket ID';
                                }

                                return null;
                              },
                              onChanged: ref
                                  .read(signInVMNotifier.notifier)
                                  .OnIdChanged),
                        ],
                      ),
                    ),
                  ),
                ),
                DevfestFilledButton(
                  title: ref.watch(
                          signInVMNotifier.select((vm) => vm.uiState.isLoading))
                      ? CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Colors.white,
                          strokeWidth: 2.0,
                        )
                      : const Text('Continue'),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      FocusScope.of(context).unfocus();
                      ref.read(signInVMNotifier.notifier).signIn();
                    }
                    // context.goNamed(Devfest2024Routes.home.name);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
