import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/models/gallery_album.dart';
import 'package:gallery_app/features/image_or_video_show/presentation/view/date_category_view.dart';

class AlbumMediasView extends StatelessWidget {
  final GalleryPickerCubit controller;
  final bool singleMedia;
  final bool isBottomSheet;
  final GalleryAlbum galleryAlbum;

  const AlbumMediasView({
    super.key,
    required this.galleryAlbum,
    required this.controller,
    required this.isBottomSheet,
    required this.singleMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            for (var category in checkCategories(galleryAlbum.dateCategories))
              DateCategoryView(
                category: category,
                controller: controller,
                singleMedia: singleMedia,
                isBottomSheet: isBottomSheet,
              ),
          ],
        ),
      ],
    );
  }

  List<DateCategory> checkCategories(List<DateCategory> categories) {
    if (controller.isRecent && controller.extraRecentMedia != null && controller.extraRecentMedia!.isNotEmpty) {
      List<DateCategory> categoriesTmp = categories.map((e) => e).toList();
      int index = categoriesTmp.indexWhere((element) => element.name == controller.config.recent);
      if (index != -1) {
        DateCategory category = DateCategory(files: [
          ...controller.extraRecentMedia!,
          ...categoriesTmp[index].files,
        ], name: categoriesTmp[index].name, dateTime: categoriesTmp[index].dateTime);
        categoriesTmp[index] = category;
        return categoriesTmp;
      } else {
        return [
          DateCategory(
              files: controller.extraRecentMedia!,
              dateTime: controller.extraRecentMedia!.first.lastModified ?? DateTime.now(),
              name: controller.config.recent),
          ...categoriesTmp
        ];
      }
    } else {
      return categories;
    }
  }
}
