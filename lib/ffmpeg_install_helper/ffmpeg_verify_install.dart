import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';

//pwrshell cmd to check if ffmpeg is running
const verifyInstallCmd = 'Get-Command ffmpeg';
//Creator that returns non
final ffmpegInstallStatusCreator =
    Creator.value(FfmpegInstallStatus.notInstalled);

final verifyFfmpegInstallCreator = Creator((ref) async {
  final result = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', verifyInstallCmd]));

  if (result.exitCode == 0) {
    log('${result.stdout}');
    if (result.stdout != null) {
      ref.set(ffmpegInstallStatusCreator, FfmpegInstallStatus.installed);
    } else {
      ref.set(ffmpegInstallStatusCreator, FfmpegInstallStatus.notInstalled);
    }
  }
});
