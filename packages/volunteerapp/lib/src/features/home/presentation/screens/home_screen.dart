import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/home/application/check_in_view_model.dart';
import 'package:volunteerapp/src/features/home/application/user_seach_view_model.dart';
import 'package:volunteerapp/src/features/search/presentation/screens/search_screen.dart';
import 'package:volunteerapp/src/features/search/presentation/widgets.dart/widgets.dart';
import '../../../../routing/routing.dart';
import '../widgets/widgets.dart';

final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const route = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String userFullName = '';

  @override
  void initState() {
    super.initState();
    ref.read(usersearchVM.notifier).getAttendees();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    userFullName = await ConferenceAppStorageService.instance.userName;
    setState(() {}); // Triggers a rebuild to display the name
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = DevfestTheme.of(context).textTheme;
    final headerStyle = textTheme?.bodyBody3Semibold
        ?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1E1E1E));

    return Scaffold(
      key: homeScaffoldKey,
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
          Padding(
            padding: EdgeInsets.only(right: 24.w),
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(checkInVMNotifier.notifier).logout(context);
              },
              label: Text(
                'Log out',
                style: textTheme?.bodyBody3Semibold
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              icon: ref.watch(
                      checkInVMNotifier.select((vm) => vm.uiState.isLoading))
                  ? CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(DevfestColors.grey10),
                      backgroundColor: DevfestColors.grey10,
                      strokeWidth: 2.0,
                    )
                  : const Icon(
                      IconsaxOutline.login,
                      color: DevfestColors.backgroundDark,
                    ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 24.w, bottom: 16.h, top: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '☺️ Welcome $userFullName',
                style: textTheme?.titleTitle1Semibold?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: DevfestColors.grey10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Check-in overview',
                      style: textTheme?.bodyBody1Medium?.copyWith(
                        color: DevfestColors.grey10,
                      ),
                    ),
                    const DayMenuBar(),
                  ],
                ),
              ),
              25.verticalSpace,
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 138.h),
                child: const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AnalyticsCard(
                        title: "Total Tickets",
                        amount: 5000,
                        analysis: "7% up this week",
                      ),
                      AnalyticsCard(
                        title: "Total Check-ins",
                        amount: 5000,
                        analysis: "7% up this week",
                      ),
                      AnalyticsCard(
                        title: "Total unchecked",
                        amount: 5000,
                        analysis: "7% up this week",
                      ),
                    ],
                  ),
                ),
              ),
              40.verticalSpace,
              Padding(
                padding: EdgeInsets.only(right: 24.w),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          onTap: () => context.goNamed(SearchScreen.route),
                          enabled: true,
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              IconsaxOutline.search_normal_1,
                              size: 20,
                            ),
                            hintText: 'Search for name, email, ticket id',
                            hintStyle: textTheme?.bodyBody4Medium?.copyWith(
                              color: DevfestColors.grey60,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  color: DevfestColors.grey70, width: 1),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  color: DevfestColors.grey70, width: 1),
                            ),
                          ),
                        ),
                      ),
                      8.horizontalSpace,
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size.fromHeight(48),
                          backgroundColor: DevfestColors.grey10,
                        ),
                        child: Text(
                          'Scan QR code',
                          style: textTheme?.bodyBody3Semibold?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: DevfestColors.grey100,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              16.verticalSpace,
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.25,
                      ),
                    ),
                    child: DataTable(
                      headingTextStyle: headerStyle,
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Checked In')),
                        DataColumn(label: Text('Full Name')),
                        DataColumn(label: Text('Email Address')),
                        DataColumn(label: Text('Ticket ID')),
                      ],
                      rows: ref
                          .watch(usersearchVM)
                          .fetchedAttendees
                          .map((attendee) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Center(
                                child:

                                    ///check if current day is contained in the users list of checked in days
                                    attendee.checkins.contains(
                                            ref.watch(checkInVMNotifier).day)
                                        ? Checkbox(
                                            semanticLabel: 'Checkin user',
                                            value: true,
                                            onChanged: (bool? value) {},
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            side: const BorderSide(
                                              color:
                                                  DevfestColors.backgroundDark,
                                              width: 1.5,
                                            ),
                                            checkColor:
                                                DevfestColors.backgroundLight,
                                            activeColor:
                                                const Color(0xFF141B34),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            visualDensity:
                                                VisualDensity.standard,
                                          )
                                        : Checkbox(
                                            semanticLabel: 'Checkin user',
                                            value: attendee.checkins.contains(
                                                ref
                                                    .watch(checkInVMNotifier)
                                                    .day),
                                            onChanged: (bool? value) {
                                              ref
                                                  .read(usersearchVM.notifier)
                                                  .onHomePageCheckboxClicked(
                                                    value ?? false,
                                                    attendee.id,
                                                  );

                                              ///show the modal if checkbox is selected

                                              if (value == true) {
                                                //show modal
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    isDismissible: false,
                                                    backgroundColor:
                                                        DevfestColors
                                                            .warning100,
                                                    showDragHandle: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return CheckInAttendeeModal(
                                                        attendee: attendee,
                                                      );
                                                    });
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            side: const BorderSide(
                                              color:
                                                  DevfestColors.backgroundDark,
                                              width: 1.5,
                                            ),
                                            checkColor:
                                                DevfestColors.backgroundLight,
                                            activeColor:
                                                const Color(0xFF141B34),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            visualDensity:
                                                VisualDensity.standard,
                                          ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  Container(
                                    width: 32.w,
                                    height: 32.w,
                                    decoration: BoxDecoration(
                                      color: DevfestColors.primariesYellow100,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: DevfestColors.grey60,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        attendee.fullname
                                            .split(' ')
                                            .map((e) => e[0])
                                            .take(2)
                                            .join(),
                                        style: textTheme?.bodyBody4Regular
                                            ?.copyWith(
                                                color: const Color(0xFF1E1E1E)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    attendee.fullname,
                                    style:
                                        textTheme?.bodyBody4Regular?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1E1E1E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                attendee.emailAddress,
                                style: textTheme?.bodyBody4Regular?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                attendee.ticketId,
                                style: textTheme?.bodyBody4Regular?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
