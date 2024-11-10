import 'package:cave/cave.dart';
import 'package:devfest24/src/features/reserve/presentation/widgets/widgets.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/shared.dart';
import '../../../dashboard/application/application.dart';
import '../../../more/presentation/screens/my_qr_code.dart';

class ReserveHomeScreen extends ConsumerStatefulWidget {
  const ReserveHomeScreen({super.key});

  @override
  ConsumerState<ReserveHomeScreen> createState() => _ReserveHomeScreenState();
}

class _ReserveHomeScreenState extends ConsumerState<ReserveHomeScreen> {
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
        actions: [
          CheckInButton(
            isLoggedIn: ref.watch(
                userViewModelNotifier.select((vm) => vm.user.id.isNotEmpty)),
            onCheckInTap: () {
              context.goNamed(MyQrCodeScreen.route);
            },
          ),
          Constants.horizontalMargin.horizontalSpace,
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constants.horizontalMargin.w),
        child: CustomScrollView(
          slivers: [
            SliverAgendaHeader(
              title: const Text('💺 Reserve'),
              subtitle: const Text(
                'We have a seat saved just for you in these  sessions!',
              ),
              onEventDayChanged: (_) {},
            ),
            SliverList.separated(
              itemCount: 20,
              itemBuilder: (context, index) => ConferenceSessionTile(
                onTap: () {},
              ),
              separatorBuilder: (context, index) =>
                  Constants.verticalGutter.verticalSpace,
            ),
            SliverToBoxAdapter(child: Constants.verticalGutter.verticalSpace),
          ],
        ),
      ),
    );
  }
}
