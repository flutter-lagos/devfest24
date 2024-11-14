import 'package:flutter/material.dart';
import 'package:cave/cave.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool noResults = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = DevfestTheme.of(context).textTheme;

    // Sample data for search
    final List<String> searchItems = [
      ...List.generate(
        10,
        (index) => 'John Doe$index',
      ),
      'Jane Smith',
      'Bob Johnson',
      'Alice Brown',
      'Charlie Wilson',
    ];

    List<Map<String, dynamic>> attendees = List.generate(
      searchItems.length,
      (index) => {
        'checkedIn': index % 2 == 0,
        'fullName': searchItems.elementAt(index),
        'email':
            '${searchItems.elementAt(index)}@example.com'.replaceAll(" ", ""),
        'ticketId': 'T00${index + 1}'
      },
    );

    return Scaffold(
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
                    return const Iterable<Map>.empty();
                  }

                  final filteredOptions = attendees.where((item) {
                    return item['fullName']
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()) ||
                        item['ticketId']
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                  }).toList();

                  setState(() {
                    noResults = filteredOptions.isEmpty;
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
                    padding: EdgeInsets.only(right: 24.w, bottom: 8.h),
                    child: Material(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Map option = options.elementAt(index);
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
                                        option['fullName']
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
                                        option['fullName'],
                                        style: textTheme?.bodyBody4Regular
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF1E1E1E),
                                        ),
                                      ),
                                      (Constants.smallVerticalGutter / 2)
                                          .verticalSpace,
                                      Text(
                                        option['email'],
                                        style: textTheme?.bodyBody4Regular
                                            ?.copyWith(
                                          color: const Color(0xFF1E1E1E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Checkbox(
                                semanticLabel: 'Checkin user',
                                value: option['checkedIn'],
                                onChanged: (bool? value) {
                                  setState(() {
                                    option['checkedIn'] = value ?? false;
                                  });
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
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            if (noResults) // Show custom message when no results are found
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42.r,
                      backgroundColor: DevfestColors.warning80,
                      child: Text(
                        "🤨",
                        textAlign: TextAlign.center,
                        style: textTheme?.bodyBody4Medium?.copyWith(
                          color: DevfestColors.grey60,
                          fontSize: 42.sp,
                        ),
                      ),
                    ),
                    Constants.verticalGutter.verticalSpace,
                    Text(
                      "Oops, No result",
                      textAlign: TextAlign.center,
                      style: textTheme?.headerH5?.copyWith(
                        color: DevfestColors.grey10,
                      ),
                    ),
                    Constants.smallVerticalGutter.verticalSpace,
                    Text(
                      "It seems you have encountered a Sodiq.\nThis ticket ID is invalid or cannot be found in our system.",
                      textAlign: TextAlign.center,
                      style: textTheme?.bodyBody2Medium?.copyWith(
                        color: DevfestColors.grey60,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
