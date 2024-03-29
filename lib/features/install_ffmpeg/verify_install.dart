import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/install_ffmpeg/install_ffmpeg.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/common_enums.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/pwsh_cmd.dart';

//TO-DO: #18 add ffmpeg installation ability for linux and macos. @anadreau
//TO-DO: #19 implement ffmpeg command depending on OS. @anadreau

///[Provider] that returns [double] representing install status of ffmpeg
final ffmpegInstallStatusTrackerProvider = Provider<double>((ref) {
  final status = ref.watch(ffmpegInstallStatusProvider);

  final installStatus = switch (status) {
    InstallStatus.notInstalled => 0.0,
    InstallStatus.createDir => 2 / 9,
    InstallStatus.downloadPackage => 3 / 9,
    InstallStatus.extractPackage => 4 / 9,
    InstallStatus.movePackage => 5 / 9,
    InstallStatus.cleanUpDir => 6 / 9,
    InstallStatus.setPathVariable => 7 / 9,
    InstallStatus.updatePathVariable => 8 / 9,
    InstallStatus.installed => 1.0,
    InstallStatus.error => 0.0
  };
  return installStatus;
});

///[FutureProvider] that runs Isolate to verify installation of ffmpeg
final verifyFfmpegInstallProvider = FutureProvider((ref) async {
  //TO-DO: #23 try implementing Process.start instead of
  //Process.runSync. @anadreau
  final result = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      ['-Command', updateEvironmentVariableCmd, ';', verifyInstallCmd],
      runInShell: true,
    ),
  );

  if (result.exitCode == 0) {
    log('stdout: ${result.stdout}');
    log('error: ${result.stderr}');
    if (result.stdout != null) {
      final installed = ref
          .read(ffmpegInstallStatusProvider.notifier)
          .update((state) => InstallStatus.installed);
      log('Ffmpeg is $installed');
    } else {
      ref
          .read(ffmpegInstallStatusProvider.notifier)
          .update((state) => InstallStatus.notInstalled);
    }
  } else {
    //log('else stdout: ${result.stdout}');
    log('else error: ${result.stderr}');
  }
});
