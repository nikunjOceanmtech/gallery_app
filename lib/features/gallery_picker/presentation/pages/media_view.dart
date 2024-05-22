// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/media_file.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/thumbnail_media_file.dart';
import 'package:gallery_app/features/image_or_video_show/presentation/view/image_or_video_show_screen.dart';
import 'package:gallery_app/global.dart';

class MediaView extends StatelessWidget {
  final MediaFile file;
  final bool singleMedia;
  final bool isBottomSheet;

  const MediaView(
    this.file, {
    super.key,
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
              galleryPickerCubit.selectedFiles.add(file);
              if (galleryPickerCubit.heroBuilder != null) {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return galleryPickerCubit.heroBuilder!(file.id, file, context);
                    },
                  ),
                );
                galleryPickerCubit.switchPickerMode(value: true);
              } else {
                galleryPickerCubit.onSelect(galleryPickerCubit.selectedFiles);
                if (isBottomSheet) {
                  galleryPickerCubit.switchPickerMode(value: true);
                  galleryPickerCubit.reloadState();
                } else {
                  Navigator.pop(context);
                  galleryPickerCubit.reloadState();
                }
              }
            } else {
              galleryPickerCubit.selectMedia(file: file);
            }
          },
          onTap: () async {
            if (singleMedia) {
              var data = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageOrVideoShowScreen(
                    mediaFile: file,
                    isSingleMedia: singleMedia,
                  ),
                ),
              );
              if (data != null) {
                Navigator.pop(context, data);
              }
            } else {
              if (galleryPickerCubit.selectedFiles.isEmpty) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageOrVideoShowScreen(
                      mediaFile: file,
                      isSingleMedia: singleMedia,
                    ),
                  ),
                );
              } else {
                if (galleryPickerCubit.pickerMode) {
                  if (galleryPickerCubit.isSelectedMedia(file: file)) {
                    galleryPickerCubit.unselectMedia(file);
                  } else {
                    galleryPickerCubit.selectMedia(file: file);
                  }
                } else {
                  galleryPickerCubit.selectedFiles.add(file);
                  if (galleryPickerCubit.heroBuilder != null) {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return galleryPickerCubit.heroBuilder!(file.id, file, context);
                        },
                      ),
                    );
                    galleryPickerCubit.switchPickerMode(value: true);
                  } else if (galleryPickerCubit.multipleMediasBuilder != null) {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return galleryPickerCubit.multipleMediasBuilder!([file], context);
                        },
                      ),
                    );
                    galleryPickerCubit.switchPickerMode(value: true);
                  } else {
                    galleryPickerCubit.onSelect(galleryPickerCubit.selectedFiles);
                    if (isBottomSheet) {
                      galleryPickerCubit.switchPickerMode(value: true);
                      galleryPickerCubit.reloadState();
                    } else {
                      Navigator.pop(context);
                      galleryPickerCubit.reloadState();
                    }
                  }
                }
              }
            }
          },
          file: file,
          failIconColor: AppColor.whiteColor,
        ),
      ],
    );
  }
}
