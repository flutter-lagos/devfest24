import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/features/more/presentation/map/map.dart';
import 'package:devfest24/src/features/more/presentation/widgets/map.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/shared.dart';
import '../widgets/map_layout.dart';

final showGridStateProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final showPathStateProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final showBlocksProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class VenueMapScreen extends ConsumerStatefulWidget {
  static const route = 'home/venue-map';

  const VenueMapScreen({super.key});

  @override
  ConsumerState<VenueMapScreen> createState() => _VenueMapScreenState();
}

class _VenueMapScreenState extends ConsumerState<VenueMapScreen> {
  late List<BlockLayoutArea> roomsLayouts;
  GridCellRange? navigationBlock;
  ({RoomType? from, RoomType? to}) instructions = (from: null, to: null);
  Grid<int>? grid;
  List<RoomType> roomByRoomInstructions = [];

  void _fromOnChanged(RoomType? room) {
    setState(() {
      instructions = (from: room, to: instructions.to);
      navigationBlock = null;
    });
  }

  void _toOnChanged(RoomType? room) {
    setState(() {
      instructions = (from: instructions.from, to: room);
      navigationBlock = null;
    });
  }

  void _getDirections() {
    if (instructions.to == null || instructions.from == null) return;

    setState(() {
      navigationBlock = null;
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      final newNavigationBlock = (
        start: getFirstAvailableCellFromBottomInRoom(instructions.from!),
        end: getCenterAvailableCellInRoom(instructions.to!),
      );
      roomByRoomInstructions =
          getOverviewDirections(instructions.from!, instructions.to!);

      debugPrint('walk path: ${roomByRoomInstructions.chainString()}');
      setState(() {
        navigationBlock = newNavigationBlock;
      });
    });
  }

  GridCell getCenterAvailableCellInRoom(RoomType room) {
    final roomBlock = roomsLayouts.firstWhere(
      (block) => block.room == room,
    );

    final startTouchColumn = (roomBlock.start.dx / cellSize).floor();
    final endTouchColumn = (roomBlock.end.dx / cellSize).floor();
    final startTouchRow = (roomBlock.start.dy / cellSize).floor();
    final endTouchRow = (roomBlock.end.dy / cellSize).floor();

    final randomRow = startTouchRow + (endTouchRow - startTouchRow) ~/ 2;
    final randomColumn =
        startTouchColumn + (endTouchColumn - startTouchColumn) ~/ 2;

    return GridCell(row: randomRow, column: randomColumn);
  }

  GridCell getFirstAvailableCellFromBottomInRoom(RoomType room) {
    final roomBlock = roomsLayouts.firstWhere(
      (block) => block.room == room,
    );

    final startTouchColumn = (roomBlock.start.dx / cellSize).floor();
    final endTouchColumn = (roomBlock.end.dx / cellSize).floor();
    final startTouchRow = (roomBlock.start.dy / cellSize).floor();
    final endTouchRow = (roomBlock.end.dy / cellSize).floor();

    final startAndEndColDiff = (endTouchColumn - startTouchColumn - 1);
    final column =
        startTouchColumn + startAndEndColDiff - (startAndEndColDiff ~/ 8);
    final row = startTouchRow + (endTouchRow - startTouchRow) ~/ 2;

    GridCell cell = GridCell(row: row, column: column);

    while (grid!.filter(cell, (state) => state <= 0)) {
      cell = GridCell(row: cell.row - 1, column: cell.column - 1);
    }

    return cell;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(
          onTap: context.pop,
        ),
        leadingWidth: 120.w,
        actions: [
          MenuBar(
            style: MenuStyle(
              alignment: Alignment.center,
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
            ),
            children: [
              SubmenuButton(
                menuStyle: MenuStyle(
                  elevation: WidgetStateProperty.all(5),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(
                      DevfestTheme.of(context).backgroundColor),
                ),
                menuChildren: [
                  MenuItemButton(
                    onPressed: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Show Grid',
                          style: DevfestTheme.of(context)
                              .textTheme
                              ?.bodyBody2Regular
                              ?.medium,
                        ),
                        Constants.horizontalGutter.horizontalSpace,
                        DevfestSwitch(
                          value: ref.watch(showGridStateProvider),
                          onChanged: (value) {
                            ref
                                .read(showGridStateProvider.notifier)
                                .update((_) => value);
                          },
                        ),
                      ],
                    ),
                  ),
                  MenuItemButton(
                    onPressed: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Show Path',
                          style: DevfestTheme.of(context)
                              .textTheme
                              ?.bodyBody2Regular
                              ?.medium,
                        ),
                        Constants.horizontalGutter.horizontalSpace,
                        DevfestSwitch(
                          value: ref.watch(showPathStateProvider),
                          onChanged: (value) {
                            ref
                                .read(showPathStateProvider.notifier)
                                .update((_) => value);
                          },
                        ),
                      ],
                    ),
                  ),
                  MenuItemButton(
                    onPressed: null,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Show Blocks',
                          style: DevfestTheme.of(context)
                              .textTheme
                              ?.bodyBody2Regular
                              ?.medium,
                        ),
                        Constants.horizontalGutter.horizontalSpace,
                        DevfestSwitch(
                          value: ref.watch(showBlocksProvider),
                          onChanged: (value) {
                            ref
                                .read(showBlocksProvider.notifier)
                                .update((_) => value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                child: const Icon(
                  Icons.lightbulb,
                  semanticLabel: 'Stats for nerds',
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                          horizontal: Constants.horizontalMargin)
                      .r,
                  child: Column(
                    children: [
                      DevfestDropDown(
                        title: 'Where are you in Landmark?',
                        hint: 'Current Location',
                        items: RoomType.values
                            .where((room) => room != instructions.to)
                            .toList(),
                        prefixIcon: const Icon(IconsaxOutline.location),
                        suffixIcon: const Icon(IconsaxOutline.arrow_down_1),
                        onChanged: _fromOnChanged,
                      ),
                      Constants.verticalGutter.verticalSpace,
                      DevfestDropDown(
                        title: 'Where are you headed?',
                        hint: 'Desired destination',
                        items: RoomType.values
                            .where((room) => room != instructions.from)
                            .toList(),
                        prefixIcon: const Icon(IconsaxOutline.location_tick),
                        suffixIcon: const Icon(IconsaxOutline.arrow_down_1),
                        onChanged: _toOnChanged,
                      ),
                    ],
                  ),
                ),
                Constants.verticalGutter.verticalSpace,
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: DevfestTheme.of(context).backgroundColor,
                      border: Border(
                        top: BorderSide(
                          color: DevfestColors.grey80.possibleDarkVariant,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Constants.largeHorizontalGutter,
                        right: Constants.smallVerticalGutter,
                        top: Constants.verticalGutter,
                        bottom: Constants.verticalGutter,
                      ).r,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return RepaintBoundary(
                            child: SizedBox(
                              height: constraints.maxHeight,
                              child: LandmarkMap(
                                mapConstraints: constraints,
                                getDirections: navigationBlock,
                                onBlocksLayout: (layout) {
                                  roomsLayouts = layout;
                                },
                                onGridUpdate: (newGrid) {
                                  grid = newGrid;
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Material(
                  elevation: 5,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: DevfestTheme.of(context).backgroundColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      border: Border(
                        top: BorderSide(
                          color: DevfestColors.grey80.possibleDarkVariant,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                              vertical: Constants.verticalGutter,
                              horizontal: Constants.horizontalMargin)
                          .r
                          .add(EdgeInsets.only(
                              bottom:
                                  MediaQuery.viewPaddingOf(context).bottom)),
                      child: DevfestFilledButton(
                        title: const Text('Get Directions'),
                        onPressed: _getDirections,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DevfestSwitch extends StatelessWidget {
  const DevfestSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DevfestTheme.of(context).bottomNavTheme?.backgroundColor;
        }

        return DevfestTheme.of(context).bottomNavTheme?.selectedColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DevfestTheme.of(context).bottomNavTheme?.selectedColor;
        }

        return DevfestTheme.of(context).bottomNavTheme?.backgroundColor;
      }),
      onChanged: onChanged,
    );
  }
}
