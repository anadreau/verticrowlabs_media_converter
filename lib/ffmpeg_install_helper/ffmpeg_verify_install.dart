import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/utils/pwsh_cmd.dart';

//Creator that returns non
final ffmpegInstallStatusCreator = Creator.value(InstallStatus.notInstalled,
    name: 'ffmpegInstallStatusCreator');

final ffmpegInstallStatusTrackerCreator = Creator<double>((ref) {
  InstallStatus status = ref.watch(ffmpegInstallStatusCreator);

  double installStatus = switch (status) {
    InstallStatus.notInstalled => 0.0,
    InstallStatus.createDir => (2 / 9).toDouble(),
    InstallStatus.downloadPackage => (3 / 9).toDouble(),
    InstallStatus.extractPackage => (4 / 9).toDouble(),
    InstallStatus.movePackage => (5 / 9).toDouble(),
    InstallStatus.cleanUpDir => (6 / 9).toDouble(),
    InstallStatus.setPathVariable => (7 / 9).toDouble(),
    InstallStatus.updatePathVariable => (8 / 9).toDouble(),
    InstallStatus.installed => 1.0,
    InstallStatus.error => 0.0
  };
  return installStatus;
});

final verifyFfmpegInstallCreator = Creator((ref) async {
  final result = await Isolate.run(() => Process.runSync('powershell.exe',
      ['-Command', updateEvironmentVariableCmd, ';', verifyInstallCmd],
      runInShell: true));

  if (result.exitCode == 0) {
    log('${result.stdout}');
    log('${result.stderr}');
    if (result.stdout != null) {
      log('${result.stdout}');
      ref.set(ffmpegInstallStatusCreator, InstallStatus.installed);
    } else {
      ref.set(ffmpegInstallStatusCreator, InstallStatus.notInstalled);
    }
  } else {
    log('stdout: ${result.stdout}');
    log('error: ${result.stderr}');
  }
}, name: 'verifyFfmpegInstallCreator');
