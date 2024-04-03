import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/install_ffmpeg/ffmpeg_installer.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/common_enums.dart';

///Screen that is displayed if ffmpeg is not installed
class InstallerPage extends ConsumerWidget {
  ///Implementation of [InstallerPage]
  const InstallerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installStatus = ref.watch(ffmpegInstallStatusProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          switch (installStatus) {
            InstallStatus.notInstalled => const _InstallStatusContainer(
                installStatusText: 'Ffmpeg is not installed on this device.',
              ),
            InstallStatus.installed => _InstallStatusContainer(
                installStatusText:
                    ref.watch(ffmpegInstallStatusProvider).message,
              ),
            _ => _InstallStatusContainer(
                installStatusText:
                    ref.watch(ffmpegInstallStatusProvider).message,
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
                child: _LinearInstallProgressIndicator(),
              ),
          },
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _InstallFfmpegButton(),
            ],
          ),
        ],
      ),
    );
  }
}

///Returns a Container with [installStatusText]
class _InstallStatusContainer extends StatelessWidget {
  const _InstallStatusContainer({
    required this.installStatusText,
  });

  final String installStatusText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(installStatusText),
      ),
    );
  }
}

///[ConsumerWidget] that gives [LinearProgressIndicator] access to
///[ffmpegInstallStatusTrackerProvider]
class _LinearInstallProgressIndicator extends ConsumerWidget {
  ///Implementation of [_LinearInstallProgressIndicator]
  const _LinearInstallProgressIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LinearProgressIndicator(
      value: ref.watch(ffmpegInstallStatusTrackerProvider),
    );
  }
}

///[ConsumerWidget] that when button is pressed installs ffmpeg
class _InstallFfmpegButton extends ConsumerWidget {
  ///Implementation of [_InstallFfmpegButton]
  const _InstallFfmpegButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installer = FfmpegInstaller();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: MaterialButton(
          onPressed: () {
            installer
              ..createDir(ref)
              ..downloadFfmpeg(ref)
              ..extractFfmpeg(ref)
              ..moveFfmpeg(ref)
              ..cleanFfmpegDir(ref)
              ..setPathVariable(ref)
              ..updatePathVariable(ref);
          },
          child: const Row(
            children: [
              Text('Install'),
              SizedBox(width: 8),
              Icon(Icons.install_desktop),
            ],
          ),
        ),
      ),
    );
  }
}
