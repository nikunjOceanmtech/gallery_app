import 'package:flutter/material.dart';
import 'package:gallery_app/controller/gallery_controller.dart';
import 'package:gallery_app/features/image_or_video_show/presentation/view/image_or_video_show_screen.dart';
import 'package:gallery_app/models/media_file.dart';
import 'package:gallery_app/screen/thumbnail_media_file.dart';
import 'package:get/get.dart';

class MediaView extends StatelessWidget {
  final MediaFile file;
  final PhoneGalleryController controller;
  final bool singleMedia;
  final bool isBottomSheet;

  const MediaView(
    this.file, {
    super.key,
    required this.controller,
    required this.singleMedia,
    required this.isBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ThumbnailMediaFile(
          onTap: () async {
            if (file.thumbnail != null) {
              await Get.to(ImageOrVideoShowScreen(mediaFile: file));
            }
          },
          file: file,
          failIconColor: controller.config.appbarIconColor,
          controller: controller,
        ),
      ],
    );
  }
}
