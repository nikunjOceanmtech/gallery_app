import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/media_file.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/widgets/thumbnail_media_file.dart';
import 'package:gallery_app/features/image_or_video_show/presentation/view/image_or_video_show_screen.dart';

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
          onLongPress: () async {
            if (singleMedia) {
              controller.selectedFiles.add(file);
              if (controller.heroBuilder != null) {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return controller.heroBuilder!(file.id, file, context);
                    },
                  ),
                );
                controller.switchPickerMode(value: true);
              } else {
                controller.onSelect(controller.selectedFiles);
                if (isBottomSheet) {
                  controller.switchPickerMode(value: true);
                  controller.reloadState();
                } else {
                  Navigator.pop(context);
                  controller.reloadState();
                }
              }
            } else {
              controller.selectMedia(file: file);
            }
          },
          onTap: () async {
            if (controller.selectedFiles.isEmpty) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageOrVideoShowScreen(mediaFile: file)),
              );
            } else {
              if (controller.pickerMode) {
                if (controller.isSelectedMedia(file: file)) {
                  controller.unselectMedia(file);
                } else {
                  controller.selectMedia(file: file);
                }
              } else {
                controller.selectedFiles.add(file);
                if (controller.heroBuilder != null) {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return controller.heroBuilder!(file.id, file, context);
                      },
                    ),
                  );
                  controller.switchPickerMode(value: true);
                } else if (controller.multipleMediasBuilder != null) {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return controller.multipleMediasBuilder!([file], context);
                      },
                    ),
                  );
                  controller.switchPickerMode(value: true);
                } else {
                  controller.onSelect(controller.selectedFiles);
                  if (isBottomSheet) {
                    controller.switchPickerMode(value: true);
                    controller.reloadState();
                  } else {
                    Navigator.pop(context);
                    controller.reloadState();
                    controller.disposeController();
                  }
                }
              }
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
