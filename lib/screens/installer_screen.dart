import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/ffmpeg_install_helper/ffmpeg_install_helper.dart';
import 'package:verticrowlabs_media_converter/ffmpeg_install_helper/ffmpeg_verify_install.dart';
import 'package:verticrowlabs_media_converter/utils/common_variables.dart';

///Screen that is displayed if ffmpeg is not installed
class InstallerScreen extends StatelessWidget {
  ///Implementation of [InstallerScreen]
  const InstallerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: ColumnConsumer());
  }
}

///ConsumerWidget that gives access to [ffmpegInstallStatusProvider]
class ColumnConsumer extends ConsumerWidget {
  ///Implementation of [ColumnConsumer]
  const ColumnConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installStatus = ref.watch(ffmpegInstallStatusProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        switch (installStatus) {
          InstallStatus.notInstalled => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Ffmpeg is not installed on this device.'),
              ),
            ),
          InstallStatus.installed => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(ref.watch(ffmpegInstallStatusProvider).message),
              ),
            ),
          _ => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(ref.watch(ffmpegInstallStatusProvider).message),
              ),
            ),
        },
        const SizedBox(
          height: 15,
        ),
        switch (installStatus) {
          InstallStatus.notInstalled => const SizedBox(),
          InstallStatus.installed => const SizedBox(),
          _ => const Padding(
              padding: EdgeInsets.fromLTRB(100, 0, 100, 15),
              //TO-DO: #16 Smooth out animation of indicator. @anadreau
              child: LinearProgressIndicatorConsumer(),
            ),
        },
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: StatusProviderButton(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

///[ConsumerWidget] that gives [LinearProgressIndicator] access to
///[ffmpegInstallStatusTrackerProvider]
class LinearProgressIndicatorConsumer extends ConsumerWidget {
  ///Implementation of [LinearProgressIndicatorConsumer]
  const LinearProgressIndicatorConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LinearProgressIndicator(
      value: ref.watch(ffmpegInstallStatusTrackerProvider),
    );
  }
}

///[ConsumerWidget] that reads [ffmpegInstallProvider] when button is pressed
class StatusProviderButton extends ConsumerWidget {
  ///Implementation of [StatusProviderButton]
  const StatusProviderButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      onPressed: () {
        ref.read(ffmpegInstallProvider);
      },
      child: const Row(
        children: [
          Text('Install'),
          SizedBox(width: 8),
          Icon(Icons.install_desktop),
        ],
      ),
    );
  }
}
