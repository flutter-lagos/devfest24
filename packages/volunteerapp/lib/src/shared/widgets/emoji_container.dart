import 'package:cave/cave.dart';
import 'package:flutter/material.dart';

class EmojiContainer extends StatelessWidget {
  const EmojiContainer({
    super.key, required this.emoji
  });
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(21.w),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: DevfestColors.warning80),
      child: Text(
        emoji,
        style: TextStyle(fontSize: 40.sp),
      ),
    );
  }
}
