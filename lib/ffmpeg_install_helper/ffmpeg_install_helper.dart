import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';

//Possible way to invoke admin
//Start-Process powershell -verb runAs -ArgumentList '-noexit Get-Command ffmpeg'

String runAsAdmin =
    'start-process pwsh -verb runas -ArgumentList ${'Install-Package ffmpeg'}';

String installFfmpegCmd = 'Install-Package ffmpeg';

String getOldPathVariableUserCmd =
    '\$oldPath = [System.Environment]::GetEnvironmentVariable(${'Path'}, ${'User'})';
String getOldPathVariableMachineCmd =
    '\$oldPath = [System.Environment]::GetEnvironmentVariable(${'Path'}, ${'Machine'})';
String getNewPathVariableCmd = '\$newPath = \$oldPath + ${'C:\\ffmpeg'}';

String setEnvironmentVariableUserCmd =
    '[System.Environment]::SetEnvironmentVariable(${'path'}, \$newPath, ${'User'})';
String setEnvironmentVariableMachineCmd =
    '[System.Environment]::SetEnvironmentVariable(${'path'}, \$newPath, ${'Machine'})';

var ffmpegInstallCreator = Creator((ref) async {
  final result = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', runAsAdmin]));

  if (result.exitCode == 0) {
    log(result.stdout);
  }
});
