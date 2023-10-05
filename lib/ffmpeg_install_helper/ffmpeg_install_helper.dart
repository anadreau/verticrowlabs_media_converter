import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/utils/pwsh_cmd.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Possible way to invoke admin
//Start-Process powershell -verb runAs -ArgumentList '-noexit Get-Command ffmpeg'

final ffmpegInstallStatusProvider =
    StateProvider<InstallStatus>((ref) => InstallStatus.notInstalled);

var ffmpegInstallProvider = FutureProvider((ref) async {
//Create Dir
  ref
      .read(ffmpegInstallStatusProvider.notifier)
      .update((state) => InstallStatus.createDir);
  var createDirResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', createDirCmd]));

  if (createDirResult.exitCode == 0) {
    log(createDirResult.stdout);
    log(createDirResult.stderr);
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.downloadPackage);
  } else {
    log('else ${createDirResult.stderr}');
  }
//Download ffmpeg
  var downloadResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', downloadFfmpegCmd]));
  if (downloadResult.exitCode == 0) {
    log(downloadResult.stdout);
    log(downloadResult.stderr);
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.extractPackage);
  } else {
    log('else ${downloadResult.stderr}');
  }
//Extract ffmpeg
  var extractResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', extractFfmpegCmd]));
  if (extractResult.exitCode == 0) {
    log(extractResult.stdout);
    log(extractResult.stderr);
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.movePackage);
  } else {
    log('else ${extractResult.stderr}');
  }
//Move ffmpeg
  var moveResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', moveFfmpegCmd]));
  if (moveResult.exitCode == 0) {
    log(moveResult.stdout);
    log(moveResult.stderr);
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.cleanUpDir);
  } else {
    log('else ${extractResult.stderr}');
  }
  //Clean up Dir
  var cleanUpResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', cleanUpFfmpegCmd]));
  if (cleanUpResult.exitCode == 0) {
    log(cleanUpResult.stdout);
    log(cleanUpResult.stderr);
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.setPathVariable);
  } else {
    log('else ${cleanUpResult.stderr}');
  }
  //Set Path Variable
  var setPathVariableResult = await Isolate.run(() => Process.runSync(
      'powershell.exe', ['-Command', setFfmpegPathVariableUserCmd]));
  if (cleanUpResult.exitCode == 0) {
    log(setPathVariableResult.stdout);
    log(setPathVariableResult.stderr);
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.updatePathVariable);
  } else {
    log('else ${setPathVariableResult.stderr}');
  }
  //Update Path Variable
  var updatePathVariableResult = await Isolate.run(() => Process.runSync(
      'powershell.exe', ['-Command', updateEvironmentVariableCmd]));
  if (cleanUpResult.exitCode == 0) {
    log(updatePathVariableResult.stdout);
    log(updatePathVariableResult.stderr);
    //Installed
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.installed);
  } else {
    log('else ${updatePathVariableResult.stderr}');
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.error);
  }
});
