import 'package:flutter/material.dart';
import 'package:gallery_app/models/gallery_album.dart';
import 'package:gallery_app/screen/date_category_view.dart';
import '../../../controller/gallery_controller.dart';

class PickerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PhoneGalleryController controller;
  final bool isBottomSheet;
  final List<Widget>? actions;

  const PickerAppBar({
    super.key,
    required this.isBottomSheet,
    required this.controller,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: controller.config.appbarColor,
      surfaceTintColor: controller.config.appbarColor,
      title: getTitle(),
      centerTitle: true,
      actions: actions ??
          [
            !controller.pickerMode && controller.isRecent
                ? TextButton(
                    onPressed: () {
                      controller.switchPickerMode(true);
                    },
                    child: Icon(
                      Icons.check_box_outlined,
                      color: controller.config.appbarIconColor,
                    ),
                  )
                : const SizedBox()
          ],
    );
  }

  Widget getTitle() {
    if (controller.pickerMode && controller.selectedFiles.isEmpty) {
      return Text(
        controller.config.tapPhotoSelect,
        style: controller.config.appbarTextStyle,
      );
    } else if (controller.pickerMode && controller.selectedFiles.isNotEmpty) {
      return Text(
        "${controller.selectedFiles.length} ${controller.config.selected}",
        style: controller.config.appbarTextStyle,
      );
    } else {
      return const Text(
        "Gallery",
        style: TextStyle(color: Colors.black),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class AlbumPage extends StatelessWidget {
  final bool singleMedia;
  final PhoneGalleryController controller;
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
            ? AlbumAppBar(
                album: album!,
                controller: controller,
                isBottomSheet: isBottomSheet,
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

class AlbumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PhoneGalleryController controller;
  final GalleryAlbum album;
  final bool isBottomSheet;

  const AlbumAppBar({
    super.key,
    required this.album,
    required this.controller,
    required this.isBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      foregroundColor: controller.config.appbarIconColor,
      backgroundColor: controller.config.appbarColor,
      surfaceTintColor: controller.config.appbarColor,
      leading: TextButton(
        onPressed: () async {
          controller.backToPicker();
        },
        child: Icon(
          Icons.arrow_back,
          color: controller.config.appbarIconColor,
        ),
      ),
      title: getTitle(),
    );
  }

  Widget getTitle() {
    if (!controller.pickerMode && controller.selectedFiles.isEmpty) {
      return Text(
        album.name ?? "Unnamed Album",
        style: controller.config.appbarTextStyle,
      );
    } else if (controller.pickerMode && controller.selectedFiles.isEmpty) {
      return Text(
        controller.config.tapPhotoSelect,
        style: controller.config.appbarTextStyle,
      );
    } else if (controller.pickerMode && controller.selectedFiles.isNotEmpty) {
      return Text(
        "${controller.selectedFiles.length} ${controller.config.selected}",
        style: controller.config.appbarTextStyle,
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class AlbumMediasView extends StatelessWidget {
  final PhoneGalleryController controller;
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
        // ListView.builder(
        //   itemCount: checkCategories(galleryAlbum.dateCategories).length,
        //   itemBuilder: (context, index) {
        //     return DateCategoryView(
        //       category: checkCategories(galleryAlbum.dateCategories)[index],
        //       controller: controller,
        //       singleMedia: singleMedia,
        //       isBottomSheet: isBottomSheet,
        //     );
        //   },
        // ),
        // if (controller.selectedFiles.isNotEmpty)
        //   Align(
        //     alignment: Alignment.bottomCenter,
        //     child: SelectedMediasView(
        //       controller: controller,
        //       isBottomSheet: isBottomSheet,
        //     ),
        //   ),
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
