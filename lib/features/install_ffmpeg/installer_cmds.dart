//Organized by order of occurance.

///[String] holding cmd that
///Creates Directory C:\ffmpeg
String createDirCmd =
    r'New-Item -Type Directory -Path C:\ffmpeg ; Set-Location C:\ffmpeg';

///[String] holding cmd that
///Downloads ffmpeg from gyan.dev
String downloadFfmpegCmd =
    'curl.exe -L "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -o "ffmpeg.zip"';

///[String] holding cmd that
///extracts ffmpeg from downloaded zip
String extractFfmpegCmd = r'Expand-Archive .\ffmpeg.zip -Force -Verbose';

///[String] holding cmd that
///moves extracted ffmpeg.exe to top level C:\ffmpeg
String moveFfmpegCmd =
    r'Get-ChildItem -Recurse ` -Path .\ffmpeg\ -Filter *.exe | Move-Item -Destination C:\ffmpeg\ -verbose';

///[String] holding cmd that
///Cleans up folders after ffmeg.exe is extracted
String cleanUpFfmpegCmd =
    r'Remove-Item .\ffmpeg\ -Recurse ; Remove-Item .\ffmpeg.zip';

///[String] holding cmd that
///Adds C:\ffmpeg to Machine path variable list
String setFfmpegPathVariableMachineCmd = r'''
[System.Environment]::SetEnvironmentVariable(
    "PATH",
    "$([System.Environment]::GetEnvironmentVariable('PATH','Machine'));C:\ffmpeg",
    "Machine"
)''';

///[String] holding cmd that
///Adds C:\ffmpeg to User Path variable list
String setFfmpegPathVariableUserCmd = r'''
[System.Environment]::SetEnvironmentVariable(
    "PATH",
    "$([System.Environment]::GetEnvironmentVariable('PATH','User'));C:\ffmpeg",
    "User"
)''';

///[String] holding cmd that
///updates current powershell environment to current state
const updateEvironmentVariableCmd =
    r'$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")';

///[String] holding cmd that
///checks if ffmpeg is running
const verifyInstallCmd = 'get-command ffmpeg | Format-List -Property Source';
