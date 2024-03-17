import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

//Thumbnail function goes here.
///[ConsumerWidget] to return the thumbnail of the media file that will be
///converted.
class MediaThumbnailWidget extends ConsumerWidget {
  ///Default constructor of [MediaThumbnailWidget]
  const MediaThumbnailWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = ref.read(thumbnailPathProvider);
    final loaded = ref.watch(thumbnailLoadedProvider);

    switch (loaded) {
      case true:
        return SizedBox(
          height: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              File('${imagePath.value}/thumbnail.jpg'),
            ),
          ),
        );
      case false:
        return SizedBox(
          height: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              File('assets/ImageHolder.jpg'),
            ),
          ),
        );
    }
  }
}

///[Provider] to track state of generated thumbnail.
final thumbnailLoadedProvider = StateProvider((ref) => false);

///[FutureProvider] that supplies the path to the thumbnail image in
///the temp folder on the machine.
final thumbnailPathProvider = FutureProvider((ref) async {
  final path = await getTemporaryDirectory();
  return path.path;
});
