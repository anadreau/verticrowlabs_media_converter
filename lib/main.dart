import 'dart:developer';
import 'dart:io';

void main() {
  const inputString =
      '"C:/Users/anadr/Videos/Convert/Puss.in.Boots.The.Last.Wish.2022.1080p.WEBRip.x264-RARBG.mp4"';
  const outputString =
      'C:/Users/anadr/Videos/Convert/Puss.in.Boots.The.Last.Wish.720.mp4';
  //const command = 'ping google.com | ConvertTo-Json';
  const outputScale = '720';
  const ffmpegCmd =
      'ffmpeg -i $inputString -vf scale=$outputScale:-2 -c:v libx264 $outputString | Write-Verbose | ConvertTo-Json';
  final result = Process.runSync('powershell.exe', ['-Command', ffmpegCmd]);

  if (result.exitCode == 0) {
    log(result.stdout);
    log('Finished');
  } else {
    log(result.stderr);
  }
}


// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }
// }
