import 'package:flutter/material.dart';
import 'package:gallery_app/controller/gallery_controller.dart';
import 'package:gallery_app/models/config.dart';
import 'package:gallery_app/models/gallery_album.dart';
import 'package:gallery_app/models/media_file.dart';
import 'package:gallery_app/screen/appbars.dart';
import 'package:gallery_app/screen/album_categories_view.dart';
import 'package:gallery_app/screen/permission_denied_view.dart';
import 'package:gallery_app/screen/view_screen.dart';
import 'package:get/get.dart';

class GalleryPickerView extends StatefulWidget {
  final Config? config;
  final Function(List<MediaFile> selectedMedia) onSelect;
  final bool startWithRecent;
  final bool isBottomSheet;
  final Locale? locale;
  final List<MediaFile>? initSelectedMedia;
  final List<MediaFile>? extraRecentMedia;
  final bool singleMedia;
  final Widget Function(
    String tag,
    MediaFile media,
    BuildContext context,
  )? heroBuilder;
  final Widget Function(
    List<MediaFile> media,
    BuildContext context,
  )? multipleMediaBuilder;

  const GalleryPickerView({
    super.key,
    this.config,
    required this.onSelect,
    this.initSelectedMedia,
    this.extraRecentMedia,
    this.singleMedia = false,
    this.isBottomSheet = false,
    this.heroBuilder,
    this.locale,
    this.multipleMediaBuilder,
    this.startWithRecent = false,
  });

  @override
  State<GalleryPickerView> createState() => _GalleryPickerState();
}

class _GalleryPickerState extends State<GalleryPickerView> {
  late PhoneGalleryController galleryController;
  bool noPhotoSeleceted = false;
  late Config config;

  @override
  void initState() {
    if (GetInstance().isRegistered<PhoneGalleryController>()) {
      galleryController = Get.find<PhoneGalleryController>();
      if (galleryController.configurationCompleted) {
        galleryController.updateConfig(widget.config);
      } else {
        galleryController.configuration(
          widget.config,
          onSelect: widget.onSelect,
          startWithRecent: widget.startWithRecent,
          heroBuilder: widget.heroBuilder,
          multipleMediasBuilder: widget.multipleMediaBuilder,
          initSelectedMedias: widget.initSelectedMedia,
          extraRecentMedia: widget.extraRecentMedia,
          isRecent: widget.startWithRecent,
          isVideo: true,
        );
      }
    } else {
      galleryController = Get.put(PhoneGalleryController());
      galleryController.configuration(
        widget.config,
        onSelect: widget.onSelect,
        startWithRecent: widget.startWithRecent,
        heroBuilder: widget.heroBuilder,
        multipleMediasBuilder: widget.multipleMediaBuilder,
        initSelectedMedias: widget.initSelectedMedia,
        extraRecentMedia: widget.extraRecentMedia,
        isRecent: widget.startWithRecent,
        isVideo: true,
      );
    }
    config = galleryController.config;
    if (!galleryController.isInitialized) {
      galleryController.initializeAlbums(locale: widget.locale, isVideo: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  GalleryAlbum? selectedAlbum;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<PhoneGalleryController>(
      builder: (controller) {
        return GetInstance().isRegistered<PhoneGalleryController>()
            ? controller.permissionGranted != false
                ? PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      PopScope(
                        canPop: true,
                        onPopInvoked: (value) {
                          if (!widget.isBottomSheet) {
                            controller.disposeController();
                          }
                        },
                        child: Scaffold(
                          backgroundColor: config.backgroundColor,
                          appBar: PickerAppBar(
                            controller: controller,
                            isBottomSheet: widget.isBottomSheet,
                            actions: [
                              Switch(
                                value: noPhotoSeleceted,
                                activeColor: AppColor.primaryColor,
                                inactiveTrackColor: AppColor.whiteColor,
                                onChanged: (value) async {
                                  noPhotoSeleceted = value;
                                  await galleryController.initializeAlbums(
                                    locale: widget.locale,
                                    isVideo: noPhotoSeleceted,
                                  );
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                          body: Column(
                            children: [
                              tabBarView(width: width, controller: controller),
                              screenView(controller: controller),
                            ],
                          ),
                        ),
                      ),
                      AlbumPage(
                        album: controller.selectedAlbum,
                        controller: controller,
                        singleMedia: widget.singleMedia,
                        isBottomSheet: widget.isBottomSheet,
                      )
                    ],
                  )
                : controller.config.permissionDeniedPage ?? PermissionDeniedView(config: controller.config)
            // : ReloadGallery(
            //     config,
            //     onPressed: () async {
            //       galleryController = Get.put(PhoneGalleryController());
            //       galleryController.configuration(widget.config,
            //           onSelect: widget.onSelect,
            //           startWithRecent: widget.startWithRecent,
            //           heroBuilder: widget.heroBuilder,
            //           multipleMediasBuilder: widget.multipleMediaBuilder,
            //           initSelectedMedias: widget.initSelectedMedia,
            //           extraRecentMedia: widget.extraRecentMedia,
            //           isRecent: widget.startWithRecent);
            //       if (!controller.isInitialized) {
            //         await controller.initializeAlbums(locale: widget.locale);
            //       }
            //       setState(() {});
            //     },
            //   );
            : const SizedBox.shrink();
      },
    );
  }

  Widget screenView({required PhoneGalleryController controller}) {
    return Expanded(
      child: PageView(
        controller: controller.pickerPageController,
        onPageChanged: (value) {
          if (value == 0) {
            controller.isRecent = true;
            controller.switchPickerMode(false);
          } else {
            controller.isRecent = false;
            controller.switchPickerMode(false);
          }
        },
        scrollDirection: Axis.horizontal,
        children: [
          imagesView(controller: controller),
          AlbumCategoriesView(
            controller: controller,
            isBottomSheet: widget.isBottomSheet,
            singleMedia: widget.singleMedia,
          ),
        ],
      ),
    );
  }

  Widget imagesView({required PhoneGalleryController controller}) {
    return controller.isInitialized && controller.recent != null
        ? 1 != 1
            ? const SizedBox.shrink()
            : AlbumMediasView(
                galleryAlbum: controller.recent!,
                controller: controller,
                isBottomSheet: widget.isBottomSheet,
                singleMedia: widget.singleMedia,
              )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
  }

  Widget tabBarView({required PhoneGalleryController controller, required double width}) {
    return Container(
      width: width,
      height: 48,
      color: config.appbarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: controller.isRecent
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: config.underlineColor,
                        width: 3.0,
                      ),
                    ),
                  )
                : null,
            height: 48,
            width: width / 2,
            child: TextButton(
              onPressed: () {
                controller.pickerPageController.animateToPage(
                  0,
                  duration: const Duration(
                    milliseconds: 50,
                  ),
                  curve: Curves.easeIn,
                );
                setState(() {
                  controller.isRecent = true;
                  controller.switchPickerMode(false);
                });
              },
              child: Text(
                config.recents,
                style: controller.isRecent ? config.selectedMenuStyle : config.unselectedMenuStyle,
              ),
            ),
          ),
          Container(
            decoration: !controller.isRecent
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: config.underlineColor,
                        width: 3.0,
                      ),
                    ),
                  )
                : null,
            height: 48,
            width: width / 2,
            child: TextButton(
              onPressed: () {
                controller.pickerPageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.easeIn,
                );
                controller.isRecent = false;
                controller.switchPickerMode(false);
              },
              child: Text(
                config.gallery,
                style: controller.isRecent ? config.unselectedMenuStyle : config.selectedMenuStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
