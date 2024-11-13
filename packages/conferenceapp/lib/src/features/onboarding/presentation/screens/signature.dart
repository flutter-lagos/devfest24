import 'dart:io';

import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/features/onboarding/presentation/widgets/widgets.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../routing/routing.dart';
import '../../../dashboard/presentation/screens/dashboard.dart';
import '../widgets/path_to_svg_parser.dart';

class OnboardingSignatureScreen extends StatefulWidget {
  static const route = '/onboarding/login/signature';

  const OnboardingSignatureScreen({super.key});

  @override
  State<OnboardingSignatureScreen> createState() =>
      _OnboardingSignatureScreenState();
}

class _OnboardingSignatureScreenState extends State<OnboardingSignatureScreen> {
  Color stencilColor = DevfestColors.grey10;
  double strokeWidth = 5;

  List<DrawSession>? drawSessions;

  BoxConstraints? canvasConstraints;

  File? svgFile;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              Constants.horizontalMargin.horizontalSpace,
              SizedBox(
                width: 96.w,
                child: DevfestFilledButton.medium(
                  backgroundColor: DevfestColors.grey80.possibleDarkVariant,
                  title: const Text('Exit'),
                  titleStyle: TextStyle(
                    color: DevfestColors.grey50.possibleDarkVariant,
                  ).semi,
                  onPressed: () {
                    context.goNamedAndPopAll(DashboardScreen.route);
                  },
                ),
              ),
            ],
          ),
          leadingWidth: 120.w,
          actions: [
            SizedBox(
              width: 96.w,
              child: DevfestFilledButton.medium(
                title: const Text('Upload'),
                onPressed: () {
                  if (canvasConstraints != null) {
                    final pathSvgParser = PathSvgParser(
                      drawSessions: drawSessions ?? [],
                      canvasConstraints: canvasConstraints!,
                    );

                    pathSvgParser.parseAsFile().then((file) {
                      setState(() {
                        svgFile = file;
                      });
                    });
                  }
                },
              ),
            ),
            Constants.horizontalMargin.horizontalSpace,
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                        vertical: Constants.verticalGutter)
                    .r
                    .add(
                      EdgeInsets.only(
                          bottom: MediaQuery.viewPaddingOf(context).bottom),
                    ),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (drawSessions?.isEmpty == true)
                            const Center(
                              child: _CanvasHintText(
                                text: 'Leave your mark here\n😘',
                              ),
                            ),
                          Positioned.fill(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                canvasConstraints ??= constraints;
                                return SignatureCanvas(
                                  stencilColor: stencilColor,
                                  strokeWidth: strokeWidth,
                                  onDrawSessionsChanged: (boardResult) {
                                    setState(() {
                                      drawSessions = boardResult;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                              horizontal: Constants.horizontalGutter,
                              vertical: Constants.smallVerticalGutter)
                          .r,
                      child: _SignatureCanvasPalette(
                        onUndoPressed: () {
                          setState(() {
                            if (drawSessions?.isNotEmpty == true) {
                              drawSessions?.removeLast();
                            }
                            svgFile = null;
                          });
                        },
                        onDeletePressed: () {
                          setState(() {
                            drawSessions?.clear();
                            svgFile = null;
                          });
                        },
                        selectedColor: stencilColor,
                        onColorChanged: (color) {
                          setState(() {
                            stencilColor = color;
                            svgFile = null;
                          });
                        },
                      ),
                    ),
                    Slider.adaptive(
                      value: strokeWidth,
                      min: 1,
                      max: 22,
                      divisions: 7,
                      onChanged: (value) {
                        setState(() {
                          strokeWidth = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (svgFile != null)
              Positioned(
                right: Constants.horizontalGutter.r,
                top: 0,
                height: 150,
                width: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: DevfestTheme.of(context).backgroundColor,
                    border: Border.all(color: DevfestColors.grey50),
                  ),
                  child: SvgPicture.file(
                    svgFile!,
                    semanticsLabel: 'Signature preview',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SignatureCanvasPalette extends StatelessWidget {
  const _SignatureCanvasPalette({
    this.onUndoPressed,
    this.onDeletePressed,
    this.onColorChanged,
    required this.selectedColor,
  });

  final VoidCallback? onUndoPressed;
  final VoidCallback? onDeletePressed;
  final void Function(Color color)? onColorChanged;
  final Color? selectedColor;

  static final paletteColors = [
    DevfestColors.primariesBlue50,
    DevfestColors.primariesGreen50,
    DevfestColors.grey10.possibleDarkVariant,
    DevfestColors.primariesYellow50,
    DevfestColors.primariesRed50,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onUndoPressed,
          icon: const Icon(
            IconsaxOutline.undo,
            semanticLabel: 'Undo button',
          ),
        ),
        Expanded(
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Constants.largeHorizontalGutter)),
              side: BorderSide(
                color: DevfestColors.grey100,
              ),
            ),
            child: SizedBox(
              height: 80.h,
              child: Padding(
                padding: const EdgeInsets.all(Constants.verticalGutter).r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                          paletteColors.length, (index) => index)
                      .map(
                        (index) => Padding(
                          padding: index == paletteColors.length - 1
                              ? EdgeInsets.zero
                              : const EdgeInsets.only(
                                      right: Constants.largeHorizontalGutter)
                                  .w,
                          child: _PaletteColorItem(
                            color: paletteColors[index],
                            isSelected: paletteColors[index] == selectedColor,
                            onTap: () {
                              onColorChanged?.call(paletteColors[index]);
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onDeletePressed,
          icon: const Icon(
            IconsaxOutline.trash,
            semanticLabel: 'Clear signature canvas',
          ),
        ),
      ],
    );
  }
}

class _PaletteColorItem extends StatelessWidget {
  const _PaletteColorItem({
    required this.color,
    this.isSelected = false,
    this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dimension = isSelected ? 48.w : 34.w;
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: Semantics.fromProperties(
        properties: const SemanticsProperties(label: 'Color picker'),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: AnimatedSize(
            duration: Constants.kAnimationDur,
            curve: Curves.ease,
            child: SizedBox.square(
              dimension: dimension,
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: DevfestColors.grey100,
                      semanticLabel: 'Selected color',
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CanvasHintText extends StatelessWidget {
  const _CanvasHintText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: DevfestTheme.of(context).textTheme?.headerH5?.regular.applyColor(
          DevfestColors.grey70.possibleDarkVariant.withOpacity(0.5)),
    );
  }
}
