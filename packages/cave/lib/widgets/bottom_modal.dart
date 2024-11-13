import 'package:cave/cave.dart';
import 'package:flutter/material.dart';

Future<void> showDevfestBottomModal(BuildContext context,
    {required List<Widget> children}) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    // constraints: BoxConstraints.loose(Size(MediaQuery.of(context).size.width,
    //     MediaQuery.of(context).size.height * 0.45)),
    isDismissible: false,
    backgroundColor: DevfestColors.warning100,
    showDragHandle: true,
    context: context,
    builder: (context) => DevfestBottomModal(
      children: children,
    ),
  );
}

class DevfestBottomModal extends StatefulWidget {
  const DevfestBottomModal({
    super.key,
    required this.children,
  });
  final List<Widget> children;

  @override
  State<DevfestBottomModal> createState() => _DevfestBottomModalState();
}

class _DevfestBottomModalState extends State<DevfestBottomModal> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.0.w, 0.0, 16.0.w, 16.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [...widget.children],
          ),
        ),
      ],
    );
  }
}
