//Get-Command ffmpeg

import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';

const verifyInstallCmd = 'Get-Command ffmpeg';
final ffmpegInstallStatusCreator =
    Creator.value(FfmpegInstallStatus.nonInstalled);

final verifyFfmpegInstallCreator = Creator((ref) async {
  final result = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', verifyInstallCmd]));

  if (result.exitCode == 0) {
    log('${result.stdout}');
    if (result.stdout != null) {
      ref.set(ffmpegInstallStatusCreator, FfmpegInstallStatus.installed);
    }
  }
});
