import 'dart:developer';
import 'dart:io';

void mediaConverter() {
  const inputString =
      '"C:/Users/anadr/Videos/Convert/Puss.in.Boots.The.Last.Wish.2022.1080p.WEBRip.x264-RARBG.mp4"';
  const outputString =
      'C:/Users/anadr/Videos/Convert/Puss.in.Boots.The.Last.Wish.720.mp4';
  //const command = 'ping google.com | ConvertTo-Json';
  const outputScale = '720';
  const ffmpegCmd =
      'ffmpeg -i $inputString -vf scale=$outputScale:-2 -c:v libx264 $outputString | ConvertTo-Json';
  final result = Process.runSync('powershell.exe', ['-Command', ffmpegCmd]);

  if (result.exitCode == 0) {
    log(result.stdout);
    log('Finished');
  } else {
    log(result.stderr);
  }
}
