import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restart_app/restart_app.dart';

import '../application/updater_vm.dart';

class UpdateListener extends ConsumerWidget {
  const UpdateListener({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<UpdaterState>(updaterProvider, (previous, current) {
      if (previous?.status == UpdaterStatus.downloadInProgress &&
          current.status == UpdaterStatus.idle &&
          current.isNewPatchReadyToInstall) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showMaterialBanner(
              MaterialBanner(
                content: const Text('An update is available!'),
                actions: [
                  TextButton(
                    onPressed: Restart.restartApp,
                    child: const Text('Restart Now'),
                  ),
                ],
              ),
            );
        });
      }
    });

    return child;
  }
}
