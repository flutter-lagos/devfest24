import 'package:cave/constants.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:cave/cave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/home/application/check_in_view_model.dart';
import 'package:volunteerapp/src/features/home/application/user_seach_view_model.dart';
import 'package:volunteerapp/src/features/search/presentation/widgets.dart/widgets.dart';
import 'package:volunteerapp/src/routing/router.dart';
import 'package:volunteerapp/src/shared/debouncer.dart';
import 'package:volunteerapp/src/shared/shared.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

enum Gender { male, female, empty }

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  static const route = '/home/search-screen';

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  bool noResults = false;
  final debouncer = Debouncer();
  final ConfettiController _contoller =
      ConfettiController(duration: Duration(seconds: 20));
  Gender? gender = Gender.empty;

  @override
  void dispose() {
    // TODO: implement dispose
    _contoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = DevfestTheme.of(context).textTheme;

    final selectedAttendee = ref.watch(usersearchVM).selectedAttendee;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: GoBackButton(
          label: 'Search',
          onTap: context.pop,
        ),
        leadingWidth: 120.w,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: 'Search for name, email, ticket id',
              child: Autocomplete<Map>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    setState(() {
                      noResults = false;
                    });

                    ref.read(usersearchVM.notifier).clearSearchList();
                    return const Iterable<Map>.empty();
                  }

                  debouncer.run(() {
                    ref
                        .read(usersearchVM.notifier)
                        .searchAttendee(textEditingValue.text.toLowerCase());
                  });
                  final filteredOptions = ref
                      .watch(usersearchVM)
                      .attendees
                      .map((e) => e.toJson())
                      .toList();
                  print('filteredOptions ${filteredOptions.toString()}');

                  setState(() {
                    noResults = ref.watch(usersearchVM).attendees.isEmpty;
                  });

                  return filteredOptions;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    keyboardAppearance: Brightness.dark,
                    focusNode: focusNode,
                    style: textTheme?.bodyBody4Regular?.copyWith(
                      color: DevfestColors.backgroundDark,
                    ),
                    cursorColor: DevfestColors.backgroundDark,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        IconsaxOutline.search_normal_1,
                        size: 20,
                      ),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            textEditingController.clear();
                          },
                          child: Icon(
                            IconsaxOutline.close_square,
                            semanticLabel: 'Clear search text field',
                            size: 20,
                          )),
                      hintText: 'Search for name, email, ticket id',
                      hintStyle: textTheme?.bodyBody4Medium?.copyWith(
                        color: DevfestColors.grey60,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(color: DevfestColors.grey70, width: 1),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(color: DevfestColors.grey70, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(color: DevfestColors.grey70, width: 1),
                      ),
                    ),
                  );
                },
                onSelected: (Map selection) {},
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<Map> onSelected,
                    Iterable<Map> options) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 24.w,
                      bottom: 8.h,
                    ),
                    child: Material(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        itemCount: options.length,
                        separatorBuilder: (context, index) =>
                            Constants.verticalGutter.verticalSpace,
                        itemBuilder: (BuildContext context, int index) {
                          // final Map option = options.elementAt(index);
                          final option =
                              ref.watch(usersearchVM).attendees[index];
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                        option.fullname
                                            .split(' ')
                                            .map((e) => e[0])
                                            .take(2)
                                            .join(),
                                        style: textTheme?.bodyBody4Medium
                                            ?.copyWith(
                                                color: const Color(0xFF1E1E1E)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option.fullname,
                                        style: textTheme?.bodyBody4Regular
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF1E1E1E),
                                        ),
                                      ),
                                      (Constants.smallVerticalGutter / 2)
                                          .verticalSpace,
                                      Text(
                                        option.emailAddress,
                                        style: textTheme?.bodyBody4Regular
                                            ?.copyWith(
                                          color: const Color(0xFF1E1E1E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              ///if the current conference day is among the days returned from the server then the user has been checked in
                              if (option.checkins.contains(
                                  ref.watch(checkInVMNotifier).day)) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.h, horizontal: 4.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(56.r),
                                        color: DevfestColors.success90,
                                      ),
                                      child: Text(
                                        'Checked In',
                                        style: DevfestTheme.of(context)
                                            .textTheme
                                            ?.bodyBody5Medium
                                            ?.medium
                                            .copyWith(
                                                color: DevfestColors.success10),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Text(
                                        option.createdAt
                                            .toString()
                                            .formattedDate,
                                        style: DevfestTheme.of(context)
                                            .textTheme
                                            ?.bodyBody4Regular
                                            ?.regular)
                                  ],
                                )
                              ] else ...[
                                Checkbox(
                                  semanticLabel: 'Checkin user',
                                  value: false,
                                  onChanged: (bool? value) {
                                    ref
                                        .read(usersearchVM.notifier)
                                        .onCheckboxClicked(
                                          value ?? false,
                                          option.id,
                                        );

                                    ///show the modal if checkbox is selected

                                    if (value == true) {
                                      //show modal
                                      showDevfestBottomModal(
                                          scaffoldKey.currentContext!,
                                          children: [
                                            ConfirmCheckInModalHeader(
                                                fullName:
                                                    ' ${option.fullname}, '),
                                            Constants.smallVerticalGutter
                                                .verticalSpace,
                                            StatefulBuilder(builder: (context,
                                                StateSetter setModalState) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      DevfestCheckbox(
                                                        semanticLabel:
                                                            'Select Female Gender',
                                                        value: ref.watch(
                                                            checkInVMNotifier
                                                                .select((vm) =>
                                                                    vm.gender ==
                                                                    'female')),
                                                        onChanged: (value) {
                                                          ref
                                                              .read(
                                                                  checkInVMNotifier
                                                                      .notifier)
                                                              .onGenderChanged(
                                                                  'female');

                                                          setModalState(() {});
                                                        },
                                                      ),
                                                      8.horizontalSpace,
                                                      Text(
                                                        'Female',
                                                        style: DevfestTheme.of(
                                                                context)
                                                            .textTheme!
                                                            .bodyBody2Medium!
                                                            .copyWith(
                                                                color:
                                                                    DevfestColors
                                                                        .grey60),
                                                      ),
                                                    ],
                                                  ),
                                                  35.horizontalSpace,
                                                  Row(
                                                    children: [
                                                      DevfestCheckbox(
                                                        semanticLabel:
                                                            'Select Male Gender',
                                                        value: ref
                                                                .watch(
                                                                    checkInVMNotifier)
                                                                .gender ==
                                                            'male',
                                                        onChanged: (value) {
                                                          ref
                                                              .read(
                                                                  checkInVMNotifier
                                                                      .notifier)
                                                              .onGenderChanged(
                                                                  'male');
                                                          setModalState(() {});
                                                        },
                                                      ),
                                                      8.horizontalSpace,
                                                      Text(
                                                        'Male',
                                                        style: DevfestTheme.of(
                                                                context)
                                                            .textTheme!
                                                            .bodyBody2Medium!
                                                            .copyWith(
                                                                color:
                                                                    DevfestColors
                                                                        .grey60),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }),
                                            Constants
                                                .verticalGutter.verticalSpace,
                                            DevfestOutlinedButton(
                                              onPressed: () {
                                                ref
                                                    .read(checkInVMNotifier
                                                        .notifier)
                                                    .onGenderChanged('');

                                                Navigator.of(context).pop();
                                              },
                                              title: Text(
                                                'Cancel',
                                                style: DevfestTheme.of(context)
                                                    .textTheme
                                                    ?.buttonMediumBold
                                                    ?.copyWith(
                                                        color: DevfestColors
                                                            .grey10),
                                              ),
                                            ),
                                            Constants
                                                .verticalGutter.verticalSpace,
                                            Consumer(
                                                builder: (context, ref, _) {
                                              return DevfestFilledButton(
                                                onPressed: () {
                                                  ref
                                                      .read(checkInVMNotifier
                                                          .notifier)
                                                      .checkInUser(
                                                          scaffoldKey
                                                              .currentContext!,
                                                          option.id);
                                                },
                                                title: ref.watch(
                                                        checkInVMNotifier
                                                            .select((vm) => vm
                                                                .uiState
                                                                .isLoading))
                                                    ? CircularProgressIndicator
                                                        .adaptive(
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Colors.white),
                                                        backgroundColor:
                                                            Colors.white,
                                                        strokeWidth: 2.0,
                                                      )
                                                    : Text(
                                                        'Yes check in',
                                                        style: DevfestTheme.of(
                                                                context)
                                                            .textTheme
                                                            ?.buttonMediumBold
                                                            ?.copyWith(
                                                                color:
                                                                    DevfestColors
                                                                        .grey100),
                                                      ),
                                              );
                                            }),
                                          ]);
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(
                                    color: DevfestColors.grey60,
                                    width: 2,
                                  ),
                                  checkColor: DevfestColors.backgroundLight,
                                  activeColor: const Color(0xFF141B34),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  visualDensity: VisualDensity.standard,
                                )
                              ]
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            if (ref.watch(usersearchVM).uiState.isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(DevfestColors.grey10),
                    backgroundColor: DevfestColors.grey10,
                    strokeWidth: 4.0,
                  ),
                ),
              ),
            if (noResults &&
                !ref.watch(usersearchVM).uiState.isLoading &&
                ref
                    .watch(usersearchVM)
                    .attendees
                    .isEmpty) // Show custom message when no results are found
              NoResult(textTheme: textTheme),
          ],
        ),
      ),
    );
  }
}
