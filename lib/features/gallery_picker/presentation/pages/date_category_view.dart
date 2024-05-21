import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/grid_view_staticd.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/media_view.dart';

class DateCategoryView extends StatelessWidget {
  final GalleryPickerCubit controller;
  final bool singleMedia;
  final DateCategory category;

  const DateCategoryView({
    super.key,
    required this.category,
    required this.controller,
    required this.singleMedia,
  });

  int getRowCount() {
    if (category.files.length % 4 != 0) {
      return category.files.length ~/ 4 + 1;
    } else {
      return category.files.length ~/ 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name,
                  style: controller.config.textStyle,
                ),
              ),
            ),
            GridViewStatic(
              size: MediaQuery.of(context).size.width,
              padding: EdgeInsets.zero,
              crossAxisCount: 4,
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 3.0,
              children: [
                ...category.files.map(
                  (medium) => MediaView(
                    medium,
                    controller: controller,
                    singleMedia: singleMedia,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
