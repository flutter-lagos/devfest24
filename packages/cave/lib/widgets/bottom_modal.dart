import 'package:cave/cave.dart';
import 'package:flutter/material.dart';

Future<void> showDevfestBottomModal(
  BuildContext context, {
  required Widget child,
  Color? backgroundColor,
}) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: backgroundColor,
    showDragHandle: true,
    context: context,
    builder: (context) => DevfestBottomModal(
      child: child,
    ),
  );
}

class DevfestBottomModal extends StatefulWidget {
  const DevfestBottomModal({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<DevfestBottomModal> createState() => _DevfestBottomModalState();
}

class _DevfestBottomModalState extends State<DevfestBottomModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0.w, 0.0, 16.0.w, 16.0.h),
      child: widget.child,
    );
  }
}
