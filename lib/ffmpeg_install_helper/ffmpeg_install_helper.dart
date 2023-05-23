import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/ffmpeg_install_helper/ffmpeg_verify_install.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';
import 'package:ffmpeg_converter/utils/pwsh_cmd.dart';

//Possible way to invoke admin
//Start-Process powershell -verb runAs -ArgumentList '-noexit Get-Command ffmpeg'

var ffmpegInstallCreator = Creator((ref) async {
  final result = await Isolate.run(() => Process.runSync('powershell.exe', [
        '-Command',
        createDirCmd,
        ';',
        downloadFfmpegCmd,
        ';',
        extractFfmpegCmd,
        ';',
        moveFfmpegCmd,
        ';',
        cleanUpFfmpegCmd,
        ';',
        setFfmpegPathVariableUserCmd,
        ';',
        updateEvironmentVariableCmd,
      ]));

  if (result.exitCode == 0) {
    log(result.stdout);
    log(result.stderr);
  } else {
    log('else ${result.stderr}');
  }

  ref.set(ffmpegInstallStatusCreator, FfmpegInstallStatus.installed);
});
