import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/features/gallery_picker/data/models/mode.dart';
import 'package:gallery_app/global.dart';

class ThumbnailAlbum extends StatelessWidget {
  final GalleryAlbum album;
  final Color failIconColor, backgroundColor;
  final Mode mode;

  const ThumbnailAlbum({
    super.key,
    required this.album,
    required this.failIconColor,
    required this.mode,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (album.thumbnail == null)
          Container(
            color: Colors.black12,
            child: Icon(
              album.type == AlbumType.image
                  ? Icons.image_not_supported
                  : album.type == AlbumType.video
                      ? Icons.videocam_off_rounded
                      : Icons.browser_not_supported,
              size: 50,
              color: failIconColor,
            ),
          )
        else if (album.thumbnail != null)
          FadeInImage(
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset("assets/images/warning.png");
            },
            image: MemoryImage(Uint8List.fromList(album.thumbnail!)),
            fadeInDuration: const Duration(milliseconds: 200),
            fit: BoxFit.cover,
            placeholder: MemoryImage(kTransparentImage),
          )
        else
          const SizedBox(),
        Opacity(opacity: 0.5, child: Container(color: Colors.black)),
        Positioned(
          bottom: 5,
          left: 5,
          child: Icon(album.icon, color: Colors.white, size: 16),
        ),
        Positioned(
          left: 25,
          bottom: 5,
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              album.name ?? "Unnamed Album",
              maxLines: 1,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.white, height: 1.2, fontSize: 12),
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              album.count.toString(),
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.white, height: 1.2, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
