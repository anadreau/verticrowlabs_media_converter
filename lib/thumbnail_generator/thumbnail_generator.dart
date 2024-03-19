import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

///[Provider] to track state of generated thumbnail.
final thumbnailLoadedProvider = StateProvider((ref) => false);

///[FutureProvider] that supplies the path to the thumbnail image in
///the temp folder on the machine.
final thumbnailPathProvider = FutureProvider((ref) async {
  final path = await getTemporaryDirectory();
  return path.path;
});
