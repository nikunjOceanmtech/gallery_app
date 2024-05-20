import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/config.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/thumbnail_album.dart';
import 'package:gallery_app/global.dart';

class AlbumCategoriesView extends StatelessWidget {
  final GalleryPickerCubit controller;
  final Config config;
  final bool isBottomSheet;
  final bool singleMedia;
  final String text;

  AlbumCategoriesView({
    super.key,
    required this.controller,
    required this.isBottomSheet,
    required this.singleMedia,
    required this.text,
  }) : config = controller.config;

  @override
  Widget build(BuildContext context) {
    return controller.galleryAlbums.isEmpty
        ? dataNotFound(text: text)
        : controller.galleryAlbums.first.album.count == 0
            ? dataNotFound(text: text)
            : LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: controller.galleryAlbums.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => controller.changeAlbum(
                          album: controller.galleryAlbums[index],
                          context: context,
                        ),
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            ThumbnailAlbum(
                              album: controller.galleryAlbums[index],
                              failIconColor: config.appbarIconColor,
                              backgroundColor: config.backgroundColor,
                              mode: config.mode,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
  }
}
