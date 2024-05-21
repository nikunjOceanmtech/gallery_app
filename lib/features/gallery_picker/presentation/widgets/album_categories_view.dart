// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/config.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/widgets/album_data_view.dart';
import 'package:gallery_app/features/gallery_picker/presentation/widgets/thumbnail_album.dart';
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: controller.galleryAlbums.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          var data = await await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumDataView(
                                album: controller.galleryAlbums[index],
                              ),
                            ),
                          );

                          if (data != null) {
                            Navigator.pop(context, data);
                          }
                        },
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
