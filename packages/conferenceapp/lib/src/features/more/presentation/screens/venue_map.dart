import 'package:cave/cave.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schematics/schematics.dart';

import '../../../../shared/shared.dart';
import '../map/path_finder.dart';
import '../map/map.dart';

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

class _VenueMapScreenState extends ConsumerState<VenueMapScreen>
    with SingleTickerProviderStateMixin {
  final cellSize = 8.0;
  late final AnimationController controller;

  late Animation<double> speedProgressAnim;

  late List<BlockLayoutArea> roomsLayouts;
  GridCellRange? navigationBlock;
  ({RoomType? from, RoomType? to}) instructions = (from: null, to: null);
  Grid<int>? grid;
  List<Action> actions = [];

  void _fromOnChanged(RoomType? room) {
    setState(() {
      instructions = (from: room, to: instructions.to);
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
    controller.stop();

    Future.delayed(const Duration(milliseconds: 50), () {
      final newNavigationBlock = (
        start: getFirstAvailableCellFromBottomInRoom(instructions.from!),
        end: getCenterAvailableCellInRoom(instructions.to!),
      );

      setState(() {
        navigationBlock = newNavigationBlock;
      });
      _navigateToDestination(newNavigationBlock);
    });
  }

  void _navigateToDestination(GridCellRange movementRange) async {
    if (grid == null) return;
    int movementPathState = 30;

    controller.reset();

    Grid<int> newGrid = grid!.copyWith();

    final navigationActions = await getActions(
      grid: newGrid,
      moveRange: movementRange,
    );
    if (!mounted) return;

    GridCell start = movementRange.start;
    for (final action in navigationActions) {
      switch (action) {
        case Action.moveUp:
          start = start.above;
          newGrid.grid[start.row][start.column] = movementPathState;
          break;
        case Action.moveRight:
          start = start.right;
          newGrid.grid[start.row][start.column] = movementPathState;
          break;
        case Action.moveLeft:
          start = start.left;
          newGrid.grid[start.row][start.column] = movementPathState;
          break;
        case Action.moveDown:
          start = start.below;
          newGrid.grid[start.row][start.column] = movementPathState;
          break;
        case Action.doNothing:
          newGrid.grid[start.row][start.column] = movementPathState;
          break;
      }
    }

    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      grid = newGrid;
      actions = navigationActions;
    });

    _runAnimation(navigationActions.length);
  }

  void _animationListener() {
    // stop animation controller when simulation is done
    // at controller value greater than 1, friction simulation is done
    if (controller.value > 1) {
      controller.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController.unbounded(vsync: this);
    speedProgressAnim = ConstantTween<double>(0).animate(controller);

    controller.addListener(_animationListener);
  }

  void _runAnimation(int distance) {
    speedProgressAnim = controller.drive(Tween<double>(begin: 0, end: 1));

    final speed = switch (distance) { <= 50 => 0.38, <= 100 => 0.2, _ => 0.05 };
    final simulation =
        FrictionSimulation.through(0, distance.toDouble(), speed, 0);
    controller.animateWith(simulation);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                    horizontal: Constants.horizontalMargin)
                .r,
            child: Row(
              children: [
                Flexible(
                  child: DevfestDropDown(
                    title: 'Where are you in Landmark?',
                    hint: 'Current Location',
                    items: RoomType.values
                        .where((room) => room != instructions.to)
                        .toList(),
                    prefixIcon: const Icon(IconsaxOutline.location),
                    suffixIcon: const Icon(IconsaxOutline.arrow_down_1),
                    onChanged: _fromOnChanged,
                  ),
                ),
                Constants.verticalGutter.horizontalSpace,
                Flexible(
                  child: DevfestDropDown(
                    title: 'Where are you headed?',
                    hint: 'Desired destination',
                    items: RoomType.values
                        .where((room) => room != instructions.from)
                        .toList(),
                    prefixIcon: const Icon(IconsaxOutline.location_tick),
                    suffixIcon: const Icon(IconsaxOutline.arrow_down_1),
                    onChanged: _toOnChanged,
                  ),
                ),
              ],
            ),
          ),
          Constants.verticalGutter.verticalSpace,
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xfffffaeb).possibleDarkVariant,
                border: Border(
                  top: BorderSide(
                    color: DevfestColors.grey80.possibleDarkVariant,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w)
                    .copyWith(top: 20.h, bottom: 16.h)
                    .subtract(EdgeInsets.only(right: 4.w)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SchemaWidget(
                        onInitiateAxesScale: (blockAreaConstraints) =>
                            (xScale: 1.w, yScale: 0.85.h, openingScale: 1.w),
                        schemaSize: (cellSize: 8, openingRadius: 22),
                        layoutDirection: LayoutDirection.bottomRight,
                        showGrid: ref.watch(showGridStateProvider),
                        showBlocks: ref.watch(showBlocksProvider),
                        onBlocksLayout: (blocksLayout) {
                          WidgetsFlutterBinding.ensureInitialized()
                              .addPostFrameCallback((_) {
                            setState(() {
                              roomsLayouts = blocksLayout;
                            });
                          });
                        },
                        onGridUpdate: (newGrid) {
                          WidgetsFlutterBinding.ensureInitialized()
                              .addPostFrameCallback((_) {
                            setState(() {
                              grid = newGrid;
                            });
                          });
                        },
                        blocks: [
                          DevfestBlock.withContext(
                            context,
                            blockLabel: 'Room 2',
                            room: RoomType.room2,
                            width: 244,
                            height: 106,
                            position: Offset(30, 0),
                            blockColor: const Color(0xffd8f3df),
                            openings: [const Offset(207, 0).opening],
                          ),
                          DevfestBlock.withContext(
                            context,
                            blockLabel: 'Room 3',
                            room: RoomType.room3,
                            height: 348,
                            width: 96,
                            blockColor: Color(0xffffdebf),
                            alignmentToPreviousBlock:
                                BlockAlignment.bottomLeft.alignTop.alignRight,
                            openings: [const Offset(32, 0).oSize(32)],
                          ),
                          DevfestBlock.withContext(
                            context,
                            blockLabel: 'Network\nZone',
                            room: RoomType.networkZone,
                            alignmentToPreviousBlock:
                                BlockAlignment.topLeft.alignTop,
                            width: 96,
                            height: 86,
                            blockColor: Color(0xffb6b0dd),
                            openings: [
                              Offset(32, 86).oSize(32),
                              Offset(96, 31).opening,
                            ],
                          ),
                          DevfestBlock.withContext(
                            context,
                            blockLabel: 'Exhibition Room',
                            room: RoomType.exhibitionRoom,
                            width: 244,
                            height: 86,
                            alignmentToPreviousBlock:
                                BlockAlignment.topRight.alignLeft,
                            blockColor: Color(0xffffb6c8),
                            openings: [
                              Offset(0, 31).opening,
                              Offset(71, 0).oSize(46),
                              Offset(90, 86).oSize(36),
                              Offset(194, 86).oSize(50),
                            ],
                          ),
                          DevfestBlock.withContext(
                            context,
                            height: 242,
                            width: 76,
                            blockLabel: 'HALLWAY',
                            room: RoomType.entranceHallway,
                            blockLabelStyle: TextStyle(fontSize: 10).medium,
                            alignmentToPreviousBlock:
                                BlockAlignment.bottomRight.alignRight -
                                    BlockAlignment(0.4, 0),
                            entranceLabel: 'ENTRANCE/EXIT',
                            hideFenceBorder: HideFenceBorder.right,
                            entranceOpeningRadius: 16.5,
                            blockColor: Color(0xffd9d0c3),
                            openings: [
                              Offset(39, 242).opening,
                              Offset(0, 124).oSize(33),
                              Offset(0.001, 0).oSize(76),
                            ],
                          ),
                          DevfestBlock.withContext(
                            context,
                            blockLabel: 'Room 1',
                            room: RoomType.room1,
                            alignmentToPreviousBlock:
                                BlockAlignment.bottomLeft.alignTop.alignRight,
                            height: 242,
                            width: 195,
                            blockColor: Color(0xffffffff),
                            openings: [
                              Offset(195, 124).oSize(33),
                              Offset(90, 0).oSize(36),
                            ],
                          ),
                          DevfestBlock.withContext(
                            context,
                            room: RoomType.hallway,
                            blockLabel: 'HALLWAY',
                            blockLabelStyle: TextStyle(fontSize: 12.sp).medium,
                            width: 45,
                            height: 189,
                            position: Offset(158, 434),
                            hideFenceBorder: HideFenceBorder.all,
                            blockColor: Color(0xffd9d0c3),
                          ),
                          DevfestBlock.withContext(
                            context,
                            room: RoomType.restroom,
                            blockLabel: 'Restroom',
                            blockLabelStyle: TextStyle(fontSize: 16.sp).medium,
                            alignmentToPreviousBlock:
                                BlockAlignment.centerRight.alignVCenter,
                            height: 52,
                            width: 112,
                            hideFenceBorder: HideFenceBorder.all,
                          ),
                          DevfestBlock.withContext(
                            context,
                            room: RoomType.greenRoom,
                            blockLabel: 'Green Room',
                            position: Offset(255, 506),
                            height: 45,
                            width: 118,
                            hideFenceBorder: HideFenceBorder.all,
                            blockColor: Color(0xffc7ebcc),
                          ),
                          DevfestBlock.withContext(
                            context,
                            room: RoomType.stairs,
                            blockLabel: 'STAIRWAY',
                            blockLabelStyle: TextStyle(fontSize: 12.sp).medium,
                            alignmentToPreviousBlock:
                                BlockAlignment.topLeft.alignTop,
                            height: 45,
                            width: 170,
                            hideFenceBorder: HideFenceBorder.all,
                            blockColor: Color(0xffd9d9d9),
                          ),
                          DevfestBlock.withContext(
                            context,
                            room: RoomType.room4,
                            blockLabel: 'Room 4',
                            height: 45,
                            alignmentToPreviousBlock:
                                BlockAlignment.topLeft.alignTop,
                            hideFenceBorder: HideFenceBorder.all,
                            blockColor: Color(0xff4285f4),
                          ),
                        ],
                      ),
                    ),
                    if (grid != null)
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: WalkerGridPainter(
                                grid: grid!,
                                cellSize: cellSize,
                                cellTrackRange: navigationBlock,
                                progress: speedProgressAnim.value,
                                actions: actions,
                                showPath: ref.watch(showPathStateProvider),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Material(
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                        horizontal: Constants.horizontalMargin)
                    .r
                    .add(EdgeInsets.only(
                        top: Constants.verticalGutter,
                        bottom: MediaQuery.viewPaddingOf(context).bottom)),
                child: DevfestFilledButton(
                  title: const Text('Get Directions'),
                  onPressed: _getDirections,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GridCell getCenterAvailableCellInRoom(RoomType room) {
    final roomBlock = roomsLayouts.getLayoutForIdentifier(room);

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
    final roomBlock = roomsLayouts.getLayoutForIdentifier(room);

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

extension type DevfestBlock._(Block i) implements Block {
  DevfestBlock.withContext(
    BuildContext context, {
    required RoomType room,
    double width = 100,
    double height = 100,
    HideFenceBorder hideFenceBorder = HideFenceBorder.none,
    String? entranceLabel,
    TextStyle? entranceLabelStyle,
    double? entranceOpeningRadius,
    required String blockLabel,
    TextStyle? blockLabelStyle,
    Color? blockColor,
    Offset? position,
    List<BlockOpening> openings = const [],
    BlockAlignment? alignmentToPreviousBlock,
  }) : this._(
          Block<RoomType>(
            identifier: room,
            blockLabel: blockLabel,
            entranceLabel: entranceLabel,
            blockColor: blockColor ?? DevfestColors.primariesYellow60,
            height: height,
            width: width,
            hideFenceBorder: hideFenceBorder,
            entranceLabelStyle: DevfestTheme.of(context)
                .textTheme
                ?.bodyBody4Regular
                ?.medium
                .applyColor(DevfestColors.grey10)
                .merge(entranceLabelStyle),
            entranceOpeningRadius: entranceOpeningRadius,
            blockLabelStyle: DevfestTheme.of(context)
                .textTheme
                ?.bodyBody3Regular
                ?.semi
                .applyColor(DevfestColors.grey10)
                .merge(blockLabelStyle),
            position: position,
            openings: openings,
            alignmentToPreviousBlock: alignmentToPreviousBlock,
          ),
        );
}
