import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/application/application.dart';
import '../../../../routing/routing.dart';
import '../../../onboarding/presentation/presentation.dart';
import '../../application/hiring_vm.dart';
import '../presentation.dart';

class HiringScreen extends ConsumerStatefulWidget {
  static const route = 'home/hiring';

  const HiringScreen({super.key});

  @override
  ConsumerState<HiringScreen> createState() => _HiringScreenState();
}

class _HiringScreenState extends ConsumerState<HiringScreen> {
  final hiringFormKey = GlobalKey<FormState>();
  bool agreeToTerms = false;

  void _agreementOnChanged(bool? action) {
    setState(() {
      agreeToTerms = action ?? false;
    });
  }

  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url.startsWith('http') ? url : 'https://$url');
    return uri != null && uri.host.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelNotifier).user;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GoBackButton(
          onTap: context.pop,
          textColor: DevfestColors.grey100,
        ),
        leadingWidth: 120.w,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (ref.watch(
                userViewModelNotifier.select((vm) => vm.user.id.isNotEmpty)))
              SignedInUserHeaderTile(
                height: 300.h,
                margin: EdgeInsets.zero,
                borderRadius: BorderRadius.zero,
                gap: (Constants.verticalGutter * 2).verticalSpace,
              )
            else
              SignedOutUserHeaderTile(
                signInOnTap: () {
                  context.goNamed(OnboardingLoginScreen.route);
                  ConferenceAppStorageService.instance.setIsFirstLaunch(true);
                },
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                        horizontal: Constants.horizontalMargin)
                    .w
                    .add(
                      EdgeInsets.only(
                        top: Constants.verticalGutter.h,
                        bottom: MediaQuery.viewPaddingOf(context).bottom,
                      ),
                    ),
                child: Form(
                  key: hiringFormKey,
                  child: Column(
                    children: [
                      ProfileInfoTile(
                        title: '🤹‍♀️ Area of Expertise',
                        info: user.role,
                      ),
                      Constants.verticalGutter.verticalSpace,
                      ProfileInfoTile(
                        title: '😊 Level of Experience',
                        info: user.levelOfExpertise,
                      ),
                      Constants.verticalGutter.verticalSpace,
                      DevfestTextFormField(
                        title: 'Link to cv/resume',
                        hint: 'e.g https://bit.ly/resume',
                        onChanged:
                            ref.read(hiringVMNotifier.notifier).resumeChanged,
                        onEditingComplete: FocusScope.of(context).nextFocus,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Resume url cannot be empty';
                          }
                          if (!isValidUrl(value!)) {
                            return 'Enter a valid url';
                          }
                          return null;
                        },
                      ),
                      Constants.verticalGutter.verticalSpace,
                      CheckboxListTile.adaptive(
                        value: agreeToTerms,
                        onChanged: _agreementOnChanged,
                        activeColor: DevfestColors.primariesYellow50,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        title: InkWell(
                          onTap: () => launchWebUrl(
                              'https://bit.ly/devfestlagos-hiringterms'),
                          child: Text(
                            'Agree to participation terms',
                            style: DevfestTheme.of(context)
                                .textTheme
                                ?.bodyBody2Medium
                                ?.medium
                                .apply(
                                  color:
                                      DevfestColors.grey10.possibleDarkVariant,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.horizontalMargin.w),
              child: DevfestFilledButton(
                title: const Text('Submit'),
                prefixIcon: ref.watch(
                        hiringVMNotifier.select((vm) => vm.uiState.isLoading))
                    ? const CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.white,
                        strokeWidth: 2.0,
                      )
                    : null,
                onPressed: () {
                  if (hiringFormKey.currentState?.validate() ?? false) {
                    FocusScope.of(context).unfocus();
                    ref.read(hiringVMNotifier.notifier).uploadUserResume();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
