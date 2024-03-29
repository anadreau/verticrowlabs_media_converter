import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/common_enums.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/pwsh_cmd.dart';

//Possible way to invoke admin
//Start-Process powershell -verb runAs -ArgumentList
//'-noexit Get-Command ffmpeg'

///[Provider] to hold [InstallStatus]
final ffmpegInstallStatusProvider =
    StateProvider<InstallStatus>((ref) => InstallStatus.notInstalled);

///[FutureProvider] that runs through and creates a directory, installs
///ffmpeg to that directory, then sets a env path variable for ffmpeg
FutureProvider<void> ffmpegInstallProvider = FutureProvider((ref) async {
//Create Dir
  ref
      .read(ffmpegInstallStatusProvider.notifier)
      .update((state) => InstallStatus.createDir);
  final createDirResult = await Isolate.run(
    () => Process.runSync('powershell.exe', ['-Command', createDirCmd]),
  );

  if (createDirResult.exitCode == 0) {
    log(createDirResult.stdout.toString());
    log(createDirResult.stderr.toString());
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.downloadPackage);
  } else {
    log('else ${createDirResult.stderr}');
  }
//Download ffmpeg
  final downloadResult = await Isolate.run(
    () => Process.runSync('powershell.exe', ['-Command', downloadFfmpegCmd]),
  );
  if (downloadResult.exitCode == 0) {
    log(downloadResult.stdout.toString());
    log(downloadResult.stderr.toString());
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.extractPackage);
  } else {
    log('else ${downloadResult.stderr}');
  }
//Extract ffmpeg
  final extractResult = await Isolate.run(
    () => Process.runSync('powershell.exe', ['-Command', extractFfmpegCmd]),
  );
  if (extractResult.exitCode == 0) {
    log(extractResult.stdout.toString());
    log(extractResult.stderr.toString());
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.movePackage);
  } else {
    log('else ${extractResult.stderr}');
  }
//Move ffmpeg
  final moveResult = await Isolate.run(
    () => Process.runSync('powershell.exe', ['-Command', moveFfmpegCmd]),
  );
  if (moveResult.exitCode == 0) {
    log(moveResult.stdout.toString());
    log(moveResult.stderr.toString());
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.cleanUpDir);
  } else {
    log('else ${extractResult.stderr}');
  }
  //Clean up Dir
  final cleanUpResult = await Isolate.run(
    () => Process.runSync('powershell.exe', ['-Command', cleanUpFfmpegCmd]),
  );
  if (cleanUpResult.exitCode == 0) {
    log(cleanUpResult.stdout.toString());
    log(cleanUpResult.stderr.toString());
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.setPathVariable);
  } else {
    log('else ${cleanUpResult.stderr}');
  }
  //Set Path Variable
  final setPathVariableResult = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      ['-Command', setFfmpegPathVariableUserCmd],
    ),
  );
  if (cleanUpResult.exitCode == 0) {
    log(setPathVariableResult.stdout.toString());
    log(setPathVariableResult.stderr.toString());
    ref
        .read(ffmpegInstallStatusProvider.notifier)
        .update((state) => InstallStatus.updatePathVariable);
  } else {
    log('else ${setPathVariableResult.stderr}');
  }
  //Update Path Variable
  final updatePathVariableResult = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      ['-Command', updateEvironmentVariableCmd],
    ),
  );
  if (cleanUpResult.exitCode == 0) {
    log(updatePathVariableResult.stdout.toString());
    log(updatePathVariableResult.stderr.toString());
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
