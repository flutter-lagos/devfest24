import 'package:cave/cave.dart';
import 'package:flutter/material.dart';

enum IconTextAlignment { left, right }

class IconText extends StatelessWidget {
  const IconText(
    this.icon,
    this.text, {
    super.key,
    this.gap = Constants.horizontalGutter,
    this.iconSize = 20,
    this.iconColor,
    this.textStyle,
    this.textAlign,
    this.alignment = IconTextAlignment.left,
  });

  final IconData icon;
  final String text;
  final double gap;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final double iconSize;
  final Color? iconColor;
  final IconTextAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final gap = Constants.horizontalGutter.horizontalSpace;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...switch (alignment) {
          IconTextAlignment.left => [
              _buildIcon(),
              gap,
              _buildText(context),
            ],
          IconTextAlignment.right => [
              _buildText(context),
              gap,
              _buildIcon(),
            ],
        },
      ],
    );
  }

  Widget _buildIcon() {
    return Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );
  }

  Widget _buildText(BuildContext context) {
    return AnimatedDefaultTextStyle(
      style: DevfestTheme.of(context).textTheme!.bodyBody3Medium!.medium,
      duration: Constants.kAnimationDur,
      child: Text(
        text,
        style: textStyle,
        textAlign: textAlign,
      ),
    );
  }
}
