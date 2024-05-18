import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/album_medias_view.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/appbars.dart';
import 'package:gallery_app/models/gallery_album.dart';

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
                context: context,
                isLeadingIcon: true,
                album: album!,
                controller: controller,
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