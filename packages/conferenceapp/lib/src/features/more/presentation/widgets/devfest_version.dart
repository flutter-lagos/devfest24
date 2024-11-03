import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DevfestAppVersion extends StatelessWidget {
  const DevfestAppVersion({
    super.key,
    this.textStyle,
    this.textAlign,
  });

  final TextStyle? textStyle;

  final TextAlign? textAlign;

  static final _appVersion = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: _appVersion,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final versionInfo = snapshot.requireData;

              return Text(
                'Version ${versionInfo.version}',
                textAlign: textAlign ?? TextAlign.center,
                style:
                    DevfestTheme.of(context).textTheme?.bodyBody3Medium?.medium,
              );
            }

            return const SizedBox.shrink();
          },
        ),
        Constants.smallVerticalGutter.verticalSpace,
      ],
    );
  }
}
