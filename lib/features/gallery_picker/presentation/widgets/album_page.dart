import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/widgets/album_medias_view.dart';
import 'package:gallery_app/features/gallery_picker/presentation/widgets/appbars.dart';

class AlbumPage extends StatelessWidget {
  final bool singleMedia;
  final GalleryPickerCubit controller;
  final GalleryAlbum? album;
  final bool isBottomSheet;

  const AlbumPage({
    super.key,
    required this.album,
    required this.controller,
    required this.singleMedia,
    required this.isBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        controller.backToPicker();
      },
      child: Scaffold(
        backgroundColor: controller.config.backgroundColor,
        appBar: album != null
            ? customAppBar(
                isTitleShow: true,
                context: context,
                isLeadingIcon: true,
                album: album!,
                controller: controller,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, controller.selectedFiles);
                    },
                    icon: const Icon(Icons.check, size: 30),
                  )
                ],
              )
            : null,
        body: album != null
            ? AlbumMediasView(
                galleryAlbum: album!,
                controller: controller,
                isBottomSheet: isBottomSheet,
                singleMedia: singleMedia,
              )
            : Center(
                child: Text(
                  "No Album Found",
                  style: controller.config.textStyle,
                ),
              ),
      ),
    );
  }
}
