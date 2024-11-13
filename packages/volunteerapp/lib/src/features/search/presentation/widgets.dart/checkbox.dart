import 'package:cave/cave.dart';
import 'package:flutter/material.dart';

class DevfestCheckbox extends StatelessWidget {
  const DevfestCheckbox(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.semanticLabel});

  final bool? value;
  final String semanticLabel;
  final ValueChanged? onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      semanticLabel: semanticLabel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: const BorderSide(
        color: DevfestColors.grey60,
        width: 2,
      ),
      checkColor: DevfestColors.backgroundLight,
      activeColor: const Color(0xFF141B34),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }
}
