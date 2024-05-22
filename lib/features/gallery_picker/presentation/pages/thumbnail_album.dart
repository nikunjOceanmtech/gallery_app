import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/global.dart';

class ThumbnailAlbum extends StatelessWidget {
  final GalleryAlbum album;
  final Color failIconColor, backgroundColor;

  const ThumbnailAlbum({
    super.key,
    required this.album,
    required this.failIconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (album.thumbnail == null)
          Container(
            color: AppColor.blackColor,
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
              return Image.asset(
                "assets/images/warning.png",
              );
            },
            image: MemoryImage(Uint8List.fromList(album.thumbnail!)),
            fadeInDuration: const Duration(milliseconds: 200),
            fit: BoxFit.cover,
            placeholder: MemoryImage(kTransparentImage),
          )
        else
          const SizedBox(),
        Opacity(opacity: 0.5, child: Container(color: AppColor.blackColor)),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(album.icon, color: AppColor.whiteColor, size: 16),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  album.name ?? "",
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: AppColor.whiteColor, height: 1.2, fontSize: 12),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  album.count.toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(color: AppColor.whiteColor, height: 1.2, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
