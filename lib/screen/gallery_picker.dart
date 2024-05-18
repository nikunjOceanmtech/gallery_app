import 'package:flutter/material.dart';
import 'package:gallery_app/controller/gallery_controller.dart';
import 'package:gallery_app/controller/picker_listener.dart';
import 'package:gallery_app/screen/gallery_picker_view.dart';
import 'package:gallery_app/models/config.dart';
import 'package:gallery_app/models/gallery_media.dart';
import 'package:gallery_app/models/media_file.dart';
import 'package:get/get.dart';

class GalleryPicker {
  static Stream<List<MediaFile>> get listenSelectedFiles {
    var controller = Get.put(PickerListener());
    return controller.stream;
  }

  static void disposeSelectedFilesListener() {
    if (GetInstance().isRegistered<PickerListener>()) {
      Get.find<PickerListener>().dispose();
    }
  }

  static void dispose() {
    if (GetInstance().isRegistered<PhoneGalleryController>()) {
      Get.find<PhoneGalleryController>().disposeController();
    }
  }

  static Future<List<MediaFile>?> pickMedia({
    Config? config,
    bool startWithRecent = false,
    bool singleMedia = false,
    Locale? locale,
    List<MediaFile>? initSelectedMedia,
    List<MediaFile>? extraRecentMedia,
    required BuildContext context,
  }) async {
    List<MediaFile>? media;
    // await Navigator.push(
    //   context,
    //   PageTransition(
    //     type: pageTransitionType,
    //     child: GalleryPickerView(
    //       onSelect: (mediaTmp) {
    //         media = mediaTmp;
    //       },
    //       config: config,
    //       locale: locale,
    //       singleMedia: singleMedia,
    //       initSelectedMedia: initSelectedMedia,
    //       extraRecentMedia: extraRecentMedia,
    //       startWithRecent: startWithRecent,
    //     ),
    //   ),
    // );
    Get.to(
      GalleryPickerView(
        onSelect: (mediaTmp) {
          media = mediaTmp;
        },
        config: config,
        locale: locale,
        singleMedia: singleMedia,
        initSelectedMedia: initSelectedMedia,
        extraRecentMedia: extraRecentMedia,
        startWithRecent: startWithRecent,
      ),
    );
    return media;
  }

  static Future<void> pickMediaWithBuilder({
    Config? config,
    required Widget Function(List<MediaFile> media, BuildContext context)? multipleMediaBuilder,
    Widget Function(String tag, MediaFile media, BuildContext context)? heroBuilder,
    Locale? locale,
    bool singleMedia = false,
    List<MediaFile>? initSelectedMedia,
    List<MediaFile>? extraRecentMedia,
    bool startWithRecent = false,
    required BuildContext context,
  }) async {
    // await Navigator.push(
    //   context,
    //   PageTransition(
    //     type: pageTransitionType,
    // child: ,
    // );
    await Get.to(
      GalleryPickerView(
        onSelect: (media) {},
        locale: locale,
        multipleMediaBuilder: multipleMediaBuilder,
        heroBuilder: heroBuilder,
        singleMedia: singleMedia,
        config: config,
        initSelectedMedia: initSelectedMedia,
        extraRecentMedia: extraRecentMedia,
        startWithRecent: startWithRecent,
      ),
    );
  }

  // static Future<void> openSheet() async {
  //   BottomSheetPanel.open();
  // }

  // static Future<void> closeSheet() async {
  //   BottomSheetPanel.close();
  // }

  // static bool get isSheetOpened {
  //   return BottomSheetPanel.isOpen;
  // }

  // static bool get isSheetExpanded {
  //   return BottomSheetPanel.isExpanded;
  // }

  // static bool get isSheetCollapsed {
  //   return BottomSheetPanel.isCollapsed;
  // }

  static Future<GalleryMedia?> collectGallery({Locale? locale}) async {
    return await PhoneGalleryController.collectGallery(locale: locale);
  }

  static Future<GalleryMedia?> initializeGallery({Locale? locale}) async {
    final controller = Get.put(PhoneGalleryController());
    await controller.initializeAlbums(locale: locale);
    return controller.media;
  }
}
