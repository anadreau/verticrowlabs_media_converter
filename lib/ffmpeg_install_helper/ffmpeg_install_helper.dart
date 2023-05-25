import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/ffmpeg_install_helper/ffmpeg_verify_install.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/utils/pwsh_cmd.dart';

//Possible way to invoke admin
//Start-Process powershell -verb runAs -ArgumentList '-noexit Get-Command ffmpeg'
//TODO: #14 break apart command and add progress enum to track each step of install. @anadreau
var ffmpegInstallCreator = Creator((ref) async {
  final result = await Isolate.run(() {
    ref.set(ffmpegInstallStatusCreator, InstallStatus.createDir);
    Process.runSync('powershell.exe', ['-Command', createDirCmd]);
    ref.set(ffmpegInstallStatusCreator, InstallStatus.downloadPackage);
    Process.runSync('powershell.exe', ['-Command', downloadFfmpegCmd]);
    ref.set(ffmpegInstallStatusCreator, InstallStatus.extractPackage);
    Process.runSync('powershell.exe', ['-Command', extractFfmpegCmd]);
    ref.set(ffmpegInstallStatusCreator, InstallStatus.movePackage);
    Process.runSync('powershell.exe', ['-Command', moveFfmpegCmd]);
    ref.set(ffmpegInstallStatusCreator, InstallStatus.cleanUpDir);
    Process.runSync('powershell.exe', ['-Command', cleanUpFfmpegCmd]);
    ref.set(ffmpegInstallStatusCreator, InstallStatus.setPathVariable);
    Process.runSync(
        'powershell.exe', ['-Command', setFfmpegPathVariableUserCmd]);
    ref.set(ffmpegInstallStatusCreator, InstallStatus.updatePathVariable);
    Process.runSync(
        'powershell.exe', ['-Command', updateEvironmentVariableCmd]);
  });

  if (result.exitCode == 0) {
    log(result.stdout);
    log(result.stderr);
  } else {
    log('else ${result.stderr}');
  }

  ref.set(ffmpegInstallStatusCreator, InstallStatus.installed);
});
