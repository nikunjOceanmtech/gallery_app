import 'package:flutter/material.dart';
import 'package:gallery_app/controller/gallery_controller.dart';
import 'package:gallery_app/models/config.dart';
import 'package:gallery_app/screen/thumbnail_album.dart';

class AlbumCategoriesView extends StatelessWidget {
  final PhoneGalleryController controller;
  final Config config;
  final bool isBottomSheet;
  final bool singleMedia;

  AlbumCategoriesView({
    super.key,
    required this.controller,
    required this.isBottomSheet,
    required this.singleMedia,
  }) : config = controller.config;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: controller.galleryAlbums.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => controller.changeAlbum(
                album: controller.galleryAlbums[index],
                isBottomSheet: isBottomSheet,
                controller: controller,
                singleMedia: singleMedia,
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
        // return GridView.count(
        //   crossAxisCount: 2,
        //   mainAxisSpacing: 3.0,
        //   crossAxisSpacing: 3.0,
        //   children: [
        //     ...controller.galleryAlbums.map(
        // (album) =>
        //   ],
        // );
      },
    );
  }
}
