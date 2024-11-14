import 'package:cave/cave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../routing/routing.dart';
import '../../../dashboard/application/application.dart';
import '../../../onboarding/presentation/presentation.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends ConsumerWidget {
  static const route = '/more/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
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
      body: Column(
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
              child: Column(
                children: [
                  ProfileInfoTile(
                    title: '📧 Email Address',
                    info: user.emailAddress,
                  ),
                  Constants.verticalGutter.verticalSpace,
                  ProfileInfoTile(
                    title: '🤹‍♀️ Area of Expertise',
                    info: user.role,
                  ),
                  Constants.verticalGutter.verticalSpace,
                  ProfileInfoTile(
                    title: '😊 Level of Experience',
                    info: user.levelOfExpertise,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
