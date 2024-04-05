import 'package:flutter_test/flutter_test.dart';
import 'package:verticrowlabs_media_converter/features/media_conversion/media.dart';

void main() {
  group('Testing Media functions', () {
    test('conversionCmd', () {
      expect(
        Media().conversionCmd(
          originalFilePath: r'C:\User\test.mp4',
          newFilePath: r'C:\User\test.converted.mp4',
          scale: '480',
          startTime: 0,
          endTime: 100,
        ),
        r'''
ffmpeg -hide_banner -stats -i "C:\User\test.mp4" -ss 0.0 -to 100.0 -vf scale=640:480 -c:v libx264 "C:\User\test.converted.mp4"''',
      );
    });
  });
}
