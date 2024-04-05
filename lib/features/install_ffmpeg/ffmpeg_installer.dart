import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/install_ffmpeg/installer_cmds.dart';

///[FfmpegInstaller] handles functions to install and verify installation
///of ffmpeg
class FfmpegInstaller {
  ///Creates a Directory for Ffmpeg installation
  Future<bool> createDir() async {
    final createDirResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', createDirCmd]),
    );

    if (createDirResult.exitCode == 0) {
      log(createDirResult.stdout.toString());
      log(createDirResult.stderr.toString());
      return true;
    } else {
      log('else ${createDirResult.stderr}');
      return false;
    }
  }

  ///Downloads ffmpeg
  Future<bool> downloadFfmpeg() async {
    final downloadResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', downloadFfmpegCmd]),
    );
    if (downloadResult.exitCode == 0) {
      log(downloadResult.stdout.toString());
      log(downloadResult.stderr.toString());
      return true;
    } else {
      log('else ${downloadResult.stderr}');
      return false;
    }
  }

  ///Extracts ffmpeg
  Future<bool> extractFfmpeg() async {
    final extractResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', extractFfmpegCmd]),
    );
    if (extractResult.exitCode == 0) {
      log(extractResult.stdout.toString());
      log(extractResult.stderr.toString());
      return true;
    } else {
      log('else ${extractResult.stderr}');
      return false;
    }
  }

  ///Moves ffmpeg
  Future<bool> moveFfmpeg() async {
    final moveResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', moveFfmpegCmd]),
    );
    if (moveResult.exitCode == 0) {
      log(moveResult.stdout.toString());
      log(moveResult.stderr.toString());
      return true;
    } else {
      log('else ${moveResult.stderr}');
      return false;
    }
  }

  ///Clean up Ffmpeg Directory
  Future<bool> cleanFfmpegDir() async {
    //Clean up Dir
    final cleanUpResult = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', cleanUpFfmpegCmd]),
    );
    if (cleanUpResult.exitCode == 0) {
      log(cleanUpResult.stdout.toString());
      log(cleanUpResult.stderr.toString());
      return true;
    } else {
      log('else ${cleanUpResult.stderr}');
      return false;
    }
  }

  ///Set Path Variable
  Future<bool> setPathVariable() async {
    final setPathVariableResult = await Isolate.run(
      () => Process.runSync(
        'powershell.exe',
        ['-Command', setFfmpegPathVariableUserCmd],
      ),
    );
    if (setPathVariableResult.exitCode == 0) {
      log(setPathVariableResult.stdout.toString());
      log(setPathVariableResult.stderr.toString());
      return true;
    } else {
      log('else ${setPathVariableResult.stderr}');
      return false;
    }
  }

  ///Update Path Variable
  Future<bool> updatePathVariable() async {
    final updatePathVariableResult = await Isolate.run(
      () => Process.runSync(
        'powershell.exe',
        ['-Command', updateEvironmentVariableCmd],
      ),
    );
    if (updatePathVariableResult.exitCode == 0) {
      log(updatePathVariableResult.stdout.toString());
      log(updatePathVariableResult.stderr.toString());
      //Installed
      return true;
    } else {
      log('else ${updatePathVariableResult.stderr}');
      return false;
    }
  }

  ///Verify installation
  Future<void> verifyInstallation(WidgetRef ref) async {
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
  }
}

///[Provider] to hold [InstallStatus]
final ffmpegInstallStatusProvider =
    StateProvider<InstallStatus>((ref) => InstallStatus.notInstalled);

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

///Enum for Installation status
enum InstallStatus {
  ///Installation status is not installed
  notInstalled('Not Installed'),

  ///Installation status is create directory
  createDir('Creating Directory'),

  ///Installation status is download package
  downloadPackage('Downloading Package'),

  ///Installation status is extract package
  extractPackage('Extracting Package'),

  ///Installation status is move package
  movePackage('Moving Package'),

  ///Installation status is clean up directory
  cleanUpDir('Cleaning up Directory'),

  ///Installation status is set path variable
  setPathVariable('Setting Path Variable'),

  ///Installation status is update path variable
  updatePathVariable('Updating Path Variable'),

  ///Installation status is installed
  installed('Installation Complete'),

  ///Installation status is returning an error
  error('Installation error');

  const InstallStatus(this.message);

  ///Returns [InstallStatus] as [String]
  final String message;
}
