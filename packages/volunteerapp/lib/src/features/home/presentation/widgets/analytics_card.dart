import 'package:cave/cave.dart';
import 'package:flutter/material.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    required this.title,
    required this.amount,
    required this.analysis,
  });

  final String title;
  final num amount;
  final String analysis;

  @override
  Widget build(BuildContext context) {
    final textTheme = DevfestTheme.of(context).textTheme;
    return Container(
      //  width: 170.w,
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 66.w, 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 0.5,
          color: const Color(0xFFCCCCCC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 15,
            backgroundColor: DevfestColors.primariesYellow90,
            child: Icon(
              IconsaxOutline.ticket_2,
              size: 16,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme?.bodyBody4Regular
                    ?.copyWith(color: const Color(0Xff828A8C)),
              ),
              Text(
                amount.toInt().toString(),
                style: textTheme?.titleTitle2Medium
                    ?.copyWith(color: const Color(0xFF2A2E2F)),
              ),
              Row(
                children: [
                  const Icon(
                    IconsaxOutline.arrow_up_3,
                    size: 8,
                    color: Color(0XFF34A853),
                  ),
                  Text(
                    analysis,
                    style: textTheme?.bodyBody5Medium
                        ?.copyWith(color: const Color(0XFF34A853)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
