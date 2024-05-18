import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/thumbnail_media_file.dart';
import 'package:gallery_app/features/image_or_video_show/presentation/view/image_or_video_show_screen.dart';
import 'package:gallery_app/models/media_file.dart';

class MediaView extends StatelessWidget {
  final MediaFile file;
  final GalleryPickerCubit controller;
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
            if (controller.selectedFiles.isEmpty) {
              if (file.thumbnail != null) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageOrVideoShowScreen(mediaFile: file)),
                );
              }
            } else {
              controller.selectMedia(file);
            }
          },
          onLongPress: () {
            controller.selectMedia(file);
          },
          file: file,
          failIconColor: controller.config.appbarIconColor,
          controller: controller,
        ),
      ],
    );
  }
}
