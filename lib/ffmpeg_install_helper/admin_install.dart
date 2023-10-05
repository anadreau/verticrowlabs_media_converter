import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Raw powershell input of [String] to set Machine env variable for ffmpeg
String testcmd =
    r'''start-process -verb runas powershell "[System.environment]::SetEnvironmentVariable('PATH','$([System.Environment]::GetEnvironmentVariable("Path","Machine"));C:\ffmpeg','Machine')"''';

///Function to run isolate with testcmd string
///to set Machine env variable for ffmpeg
Provider<Future<void>> ffmpegadminInstallProvider = Provider((ref) async {
  final result = Process.runSync('powershell.exe', [testcmd]);

  if (result.exitCode == 0) {
    log(result.stdout.toString());
    log(result.stderr.toString());
  } else {
    log('else err: ${result.stderr}');
    log('else out: ${result.stdout}');
  }
});
