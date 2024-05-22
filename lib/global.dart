import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:photo_gallery/photo_gallery.dart';

final Uint8List kTransparentImage = Uint8List.fromList(
  <int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ],
);

late GalleryPickerCubit galleryPickerCubit;

class AppColor {
  static Color primaryColor = const Color(0xff084277);
  static Color whiteColor = const Color(0xffffffff);
  static Color blackColor = const Color(0xff000000);
}

Widget commonLoadingBar() {
  return Center(
    child: CircularProgressIndicator(
      color: AppColor.whiteColor,
      strokeWidth: 3,
      backgroundColor: AppColor.primaryColor,
    ),
  );
}

Widget dataNotFound({required String text}) {
  return SizedBox(
    height: double.infinity,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/no_data_found.png',
          height: 200,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/warning.png",
              color: AppColor.primaryColor,
              height: 40,
            );
          },
        ),
        const SizedBox(height: 30),
        Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    ),
  );
}

class RouteList {
  static const String home_screen = "/home_sceen";
  static const String image_or_video_show_screen = "/image_or_video_show_screen";
}

enum PickType { onlyImage, onlyVideo, imageOrVideo }

extension StringExtension on String {
  String toCamelcase() {
    return toLowerCase().replaceAllMapped(RegExp(r'\b\w'), (match) => match.group(0)!.toUpperCase());
  }
}

extension MediumExtension on Medium {
  DateTime? get lastDate => modifiedDate ?? modifiedDate;
}

class GalleryMedia {
  List<GalleryAlbum> albums;
  GalleryAlbum? get recent {
    return albums.singleWhere((element) => element.name == "All");
  }

  GalleryAlbum? getAlbum(String name) {
    try {
      return albums.singleWhere((element) => element.name == name);
    } catch (e) {
      if (kDebugMode) {
        print("===========$e");
      }
      return null;
    }
  }

  GalleryMedia(this.albums);
}
