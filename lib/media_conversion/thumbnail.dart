import 'dart:developer';
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
    final image = _retrieveThumbnail(ref);

    return FutureBuilder(
      builder: (context, AsyncSnapshot<File> snapshot) {
        if (snapshot.hasData == true) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.file(snapshot.data!),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset('assets/ImageHolder.jpg'),
          );
        }
      },
      future: image,
    );
  }
}

Future<File> _retrieveThumbnail(WidgetRef ref) async {
  final thumbnailPath = await getTemporaryDirectory();

  final imageFile = File('${thumbnailPath.path}/thumbnail.jpg');
  final imageFileExists = imageFile.existsSync();
  log('imageFileExists: $imageFileExists');
  if (imageFileExists == true) {
    return imageFile;
  } else {
    final imageHolder = File('assets/ImageHolder.jpg');
    return imageHolder;
  }
}
