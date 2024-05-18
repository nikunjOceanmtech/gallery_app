import 'package:flutter/material.dart';
import 'package:gallery_app/controller/gallery_controller.dart';
import 'package:gallery_app/models/gallery_album.dart';
import 'package:gallery_app/screen/grid_view_staticd.dart';
import 'package:gallery_app/screen/media_view.dart';

class DateCategoryView extends StatelessWidget {
  final PhoneGalleryController controller;
  final bool singleMedia;
  final DateCategory category;
  final bool isBottomSheet;

  const DateCategoryView({
    super.key,
    required this.category,
    required this.controller,
    required this.isBottomSheet,
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
                    isBottomSheet: isBottomSheet,
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
