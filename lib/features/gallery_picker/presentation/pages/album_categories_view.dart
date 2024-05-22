import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/album_data_view.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/thumbnail_album.dart';
import 'package:gallery_app/global.dart';

class AlbumCategoriesView extends StatelessWidget {
  final bool isBottomSheet;
  final bool singleMedia;
  final String text;

  const AlbumCategoriesView({super.key, required this.isBottomSheet, required this.singleMedia, required this.text});

  @override
  Widget build(BuildContext context) {
    return galleryPickerCubit.galleryAlbums.isEmpty
        ? dataNotFound(text: text)
        : galleryPickerCubit.galleryAlbums.first.album.count == 0
            ? dataNotFound(text: text)
            : LayoutBuilder(
                builder: (_, constraints) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: galleryPickerCubit.galleryAlbums.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () async {
                          var data = await await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumDataView(
                                album: galleryPickerCubit.galleryAlbums[index],
                              ),
                            ),
                          );

                          if (data != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, data);
                          }
                        },
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            ThumbnailAlbum(
                              album: galleryPickerCubit.galleryAlbums[index],
                              failIconColor: AppColor.whiteColor,
                              backgroundColor: AppColor.whiteColor,
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
