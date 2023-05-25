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
  final result = await Isolate.run(
          () => ref.set(ffmpegInstallStatusCreator, InstallStatus.createDir))
      .then((value) =>
          Process.runSync('powershell.exe', ['-Command', createDirCmd]))
      .then((value) =>
          ref.set(ffmpegInstallStatusCreator, InstallStatus.downloadPackage))
      .then((value) =>
          Process.runSync('powershell.exe', ['-Command', downloadFfmpegCmd]))
      .then((value) =>
          ref.set(ffmpegInstallStatusCreator, InstallStatus.extractPackage))
      .then((value) =>
          Process.runSync('powershell.exe', ['-Command', extractFfmpegCmd]))
      .then((value) =>
          ref.set(ffmpegInstallStatusCreator, InstallStatus.movePackage))
      .then((value) => Process.runSync('powershell.exe', ['-Command', moveFfmpegCmd]))
      .then((value) => ref.set(ffmpegInstallStatusCreator, InstallStatus.cleanUpDir))
      .then((value) => Process.runSync('powershell.exe', ['-Command', cleanUpFfmpegCmd]))
      .then((value) => ref.set(ffmpegInstallStatusCreator, InstallStatus.setPathVariable))
      .then((value) => Process.runSync('powershell.exe', ['-Command', setFfmpegPathVariableUserCmd]))
      .then((value) => ref.set(ffmpegInstallStatusCreator, InstallStatus.updatePathVariable))
      .then((value) => Process.runSync('powershell.exe', ['-Command', updateEvironmentVariableCmd]));

  if (result.exitCode == 0) {
    log(result.stdout);
    log(result.stderr);
  } else {
    log('else ${result.stderr}');
  }

  ref.set(ffmpegInstallStatusCreator, InstallStatus.installed);
});
