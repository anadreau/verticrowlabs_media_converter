import 'dart:developer';
import 'dart:io';

class FfmpegLinuxInstaller {
  Future<String> verifyInstallation() async {
    var stdoutResult = '';
    var stderrResult = '';
    final process = await Process.start(
      'which',
      [verifyLinuxInstallCmd],
    );

    await process.stdout.forEach((element) {
      log('stdout: ${String.fromCharCodes(element)}');
      stdoutResult = String.fromCharCodes(element);
    });

    await process.stderr.forEach((element) {
      log('stderr: ${String.fromCharCodes(element)}');
      stderrResult = String.fromCharCodes(element);
    });
    if (stdoutResult != '') {
      return stdoutResult;
    }
    if (stderrResult != '') {
      return stderrResult;
    } else {
      return '';
    }
  }

  /// outputs path if cmd is installed and added to path already.
  final verifyLinuxInstallCmd = 'ffmpeg';
}
