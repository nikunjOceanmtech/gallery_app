import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/media_view.dart';

class DateCategoryView extends StatelessWidget {
  final GalleryPickerCubit controller;
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
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            GridView.builder(
              itemCount: category.files.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 1.5),
                  child: MediaView(
                    category.files[index],
                    controller: controller,
                    singleMedia: singleMedia,
                    isBottomSheet: isBottomSheet,
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
