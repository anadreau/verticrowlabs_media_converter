import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';
import 'package:ffmpeg_converter/utils/pwsh_cmd.dart';

//Creator that returns non
final ffmpegInstallStatusCreator = Creator.value(
    FfmpegInstallStatus.notInstalled,
    name: 'ffmpegInstallStatusCreator');

final verifyFfmpegInstallCreator = Creator((ref) async {
  final result = await Isolate.run(() => Process.runSync('powershell.exe',
      ['-Command', updateEvironmentVariableCmd, ';', verifyInstallCmd],
      runInShell: true));

  if (result.exitCode == 0) {
    log('${result.stdout}');
    log('${result.stderr}');
    if (result.stdout != null) {
      log('${result.stdout}');
      ref.set(ffmpegInstallStatusCreator, FfmpegInstallStatus.installed);
    } else {
      ref.set(ffmpegInstallStatusCreator, FfmpegInstallStatus.notInstalled);
    }
  } else {
    log('stdout: ${result.stdout}');
    log('error: ${result.stderr}');
  }
}, name: 'verifyFfmpegInstallCreator');
