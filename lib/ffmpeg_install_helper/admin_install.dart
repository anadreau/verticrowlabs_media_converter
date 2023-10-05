import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String testcmd =
    r'''start-process -verb runas powershell "[System.environment]::SetEnvironmentVariable('PATH','$([System.Environment]::GetEnvironmentVariable("Path","Machine"));C:\ffmpeg','Machine')"''';

var ffmpegadminInstallProvider = Provider((ref) async {
  final result = Process.runSync('powershell.exe', [testcmd]);

  if (result.exitCode == 0) {
    log(result.stdout);
    log(result.stderr);
  } else {
    log('else err: ${result.stderr}');
    log('else out: ${result.stdout}');
  }
});
