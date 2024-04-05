import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/install_ffmpeg/ffmpeg_installer.dart';
import 'package:verticrowlabs_media_converter/infrastructure/pages/converter_page.dart';
import 'package:verticrowlabs_media_converter/infrastructure/pages/installer_page.dart';

///ConsumerWidget that returns either ConverterScreen or InstallScreen
///based on [ffmpegInstallStatusProvider] status
class MediaConverterScreen extends ConsumerWidget {
  ///Implementation of [MediaConverterScreen]
  const MediaConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FfmpegInstaller().verifyInstallation(ref);
    final ffmpegInstalled = ref.watch(ffmpegInstallStatusProvider);
    return switch (ffmpegInstalled) {
      InstallStatus.notInstalled => const InstallerPage(),
      InstallStatus.installed => const ConverterPage(),
      _ => const InstallerPage()
    };
  }
}
