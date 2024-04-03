import 'package:test/test.dart';
import 'package:verticrowlabs_media_converter/features/file_parsing/file_parser.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/common_enums.dart';

void main() {
  group('Testing FileParser', () {
    test('fileNameParser: splits path string by backslash', () {
      expect(
        FileParser().fileNameParser(r'C:\user\test.mp4'),
        ['C:', 'user', 'test.mp4'],
      );
    });
    test('oldFileName: retrieves name of file in given path', () {
      final pathInput = FileParser().fileNameParser(r'C:\user\test.mp4');
      expect(
        FileParser().oldFileName(pathInput),
        'test.mp4',
      );
    });
    test('rawPath: remove file name from path', () {
      final pathInput = FileParser().rawPath(r'C:\user\test.mp4');
      expect(pathInput, r'C:\user');
    });
    test('filePathParser: If fileName is null output path with old filename',
        () {
      const media = MediaContainerType.mp4;
      final parser =
          FileParser().filePathParser(r'C:\User\test.mp4', null, media);
      expect(parser, r'C:\User\test.converted.mp4');
    });
    test('''
filePathParser: If fileName is not-null, 
        output path with new filename''', () {
      const media = MediaContainerType.mp4;
      final parser =
          FileParser().filePathParser(r'C:\User\test.mp4', 'newTest', media);
      expect(parser, r'C:\User\newTest.mp4');
    });
  });
}


// void main() {
//   /// A testing utility which creates a [ProviderContainer] and automatically
//   /// disposes it at the end of the test.
//   ProviderContainer createContainer({
//     ProviderContainer? parent,
//     List<Override> overrides = const [],
//     List<ProviderObserver>? observers,
//   }) {
//     // Create a ProviderContainer, and optionally allow specifying parameters.
//     final container = ProviderContainer(
//       parent: parent,
//       overrides: overrides,
//       observers: observers,
//     );

//     // When the test ends, dispose the container.
//     addTearDown(container.dispose);

//     return container;
//   }

//   test('Default value, returns null', () {
//     final container = createContainer();
//     expect(container.read(outputStringProvider), equals(null));
//   });
// }
