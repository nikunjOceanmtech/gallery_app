import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/config.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_media.dart';
import 'package:gallery_app/features/gallery_picker/data/models/media_file.dart';
import 'package:gallery_app/features/gallery_picker/data/models/medium.dart';
import 'package:gallery_app/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

class GalleryPickerCubit extends Cubit<double> {
  GalleryPickerCubit() : super(0);

  late bool startWithRecent;
  late bool isRecent;
  bool? permissionGranted;
  bool configurationCompleted = false;
  late Function(List<MediaFile> selectedMedias) onSelect;
  Widget Function(String tag, MediaFile media, BuildContext context)? heroBuilder;
  Widget Function(List<MediaFile> medias, BuildContext context)? multipleMediasBuilder;
  GalleryMedia? _media;
  GalleryMedia? get media => _media;
  List<GalleryAlbum> get galleryAlbums => _media == null ? [] : _media!.albums;
  List<MediaFile> _selectedFiles = [];
  List<MediaFile>? _extraRecentMedia;
  List<MediaFile> get selectedFiles => _selectedFiles;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  List<MediaFile>? get extraRecentMedia => _extraRecentMedia;
  bool _pickerMode = false;
  bool get pickerMode => _pickerMode;
  late PageController pageController;
  late PageController pickerPageController;
  GalleryAlbum? selectedAlbum;
  late Config config;

  void configuration(
    Config? config, {
    required dynamic Function(List<MediaFile>) onSelect,
    required Widget Function(String, MediaFile, BuildContext)? heroBuilder,
    required bool isRecent,
    required bool startWithRecent,
    required List<MediaFile>? initSelectedMedias,
    required List<MediaFile>? extraRecentMedia,
    required Widget Function(List<MediaFile>, BuildContext)? multipleMediasBuilder,
  }) {
    this.onSelect = onSelect;
    this.heroBuilder = heroBuilder;
    this.isRecent = isRecent;
    this.startWithRecent = startWithRecent;
    this.multipleMediasBuilder = multipleMediasBuilder;
    pageController = PageController();
    pickerPageController = PageController(initialPage: startWithRecent ? 0 : 1);
    this.config = config ?? Config();
    if (initSelectedMedias != null) {
      _selectedFiles = initSelectedMedias.map((e) => e).toList();
      emit(Random().nextDouble());
    }
    if (extraRecentMedia != null) {
      _extraRecentMedia = extraRecentMedia.map((e) => e).toList();
      emit(Random().nextDouble());
    }
    if (selectedFiles.isNotEmpty) {
      _pickerMode = true;
      emit(Random().nextDouble());
    }
    configurationCompleted = true;
    emit(Random().nextDouble());
  }

  void resetBottomSheetView() {
    if (permissionGranted == true) {
      isRecent = true;
      if (selectedAlbum == null) {
        pickerPageController.jumpToPage(0);
        emit(Random().nextDouble());
      } else {
        pageController.jumpToPage(0);
        pickerPageController = PageController();
        emit(Random().nextDouble());
      }
      selectedAlbum = null;
      emit(Random().nextDouble());
    }
  }

  void updateConfig(Config? config) {
    this.config = config ?? Config();
    emit(Random().nextDouble());
  }

  void updateSelectedFiles(List<MediaFile> media) {
    _selectedFiles = media.map((e) => e).toList();
    if (selectedFiles.isEmpty) {
      _pickerMode = false;
      emit(Random().nextDouble());
    } else {
      _pickerMode = true;
      emit(Random().nextDouble());
    }
  }

  void updateExtraRecentMedia(List<MediaFile> media) {
    _extraRecentMedia = media.map((e) => e).toList();
    GalleryAlbum? recentTmp = recent;
    if (recentTmp != null) {
      _extraRecentMedia!.removeWhere((element) => recentTmp.files.any((file) => element.id == file.id));
      emit(Random().nextDouble());
    }
  }

  Future<void> changeAlbum({required GalleryAlbum album, required BuildContext context}) async {
    _selectedFiles.clear();
    selectedAlbum = album;

    reloadState();
    await pageController.animateToPage(1, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
    emit(Random().nextDouble());
  }

  Future<void> backToPicker() async {
    _selectedFiles.clear();
    _pickerMode = false;
    pickerPageController = PageController(initialPage: 1);

    await pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    selectedAlbum = null;
    emit(Random().nextDouble());
  }

  void unselectMedia(MediaFile file) {
    _selectedFiles.removeWhere((element) => element.id == file.id);
    if (_selectedFiles.isEmpty) {
      _pickerMode = false;
    }

    reloadState();
  }

  void selectMedia({required MediaFile file}) {
    if (!_selectedFiles.any((element) => element.id == file.id)) {
      _selectedFiles.add(file);
    } else {
      _selectedFiles.removeWhere((element) => element.id == file.id);
    }
    if (!_pickerMode) {
      _pickerMode = true;
    }

    reloadState();
  }

  void reloadState() {
    emit(Random().nextDouble());
  }

  static Future<bool> promptPermissionSetting() async {
    if (Platform.isAndroid) {
      if (await requestPermission(Permission.photos)) {
        return await requestPermission(Permission.videos);
      } else {
        return false;
      }
    }
    bool statusStorage = await requestPermission(Permission.storage);
    if (statusStorage) {
      return await requestPermission(Permission.photos);
    }
    return false;
  }

  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> initializeAlbums({Locale? locale, bool isVideo = false, required PickType pickType}) async {
    _media = await collectGallery(locale: locale, pickType: pickType);

    if (_media != null) {
      if (_extraRecentMedia != null) {
        GalleryAlbum? recentTmp = recent;
        if (recentTmp != null) {
          _extraRecentMedia!.removeWhere((element) => recentTmp.files.any((file) => element.id == file.id));
        }
      }
      permissionGranted = true;
      _isInitialized = true;
      emit(Random().nextDouble());
    } else {
      permissionGranted = false;
      permissionListener(locale: locale, pickType: pickType);
      emit(Random().nextDouble());
    }
  }

  void permissionListener({Locale? locale, required PickType pickType}) {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        if (await isGranted()) {
          await initializeAlbums(locale: locale, isVideo: true, pickType: pickType);
          timer.cancel();
        }
      },
    );
    emit(Random().nextDouble());
  }

  Future<bool> isGranted() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) {
        return await Permission.videos.isGranted;
      } else {
        return false;
      }
    }
    return (await Permission.storage.isGranted) && (await Permission.photos.isGranted);
  }

  static Future<GalleryMedia?> collectGallery({Locale? locale, required PickType pickType}) async {
    if (await promptPermissionSetting()) {
      List<GalleryAlbum> tempGalleryAlbums = [];

      List<Album> photoAlbums = await PhotoGallery.listAlbums(mediumType: MediumType.image);
      List<Album> videoAlbums = await PhotoGallery.listAlbums(mediumType: MediumType.video);

      if (pickType == PickType.onlyImage || pickType == PickType.imageOrVideo) {
        for (var photoAlbum in photoAlbums) {
          GalleryAlbum entireGalleryAlbum = GalleryAlbum.album(photoAlbum);
          await entireGalleryAlbum.initialize(locale: locale);
          entireGalleryAlbum.setType = AlbumType.image;
          if (pickType == PickType.onlyVideo || pickType == PickType.imageOrVideo) {
            if (videoAlbums.any((element) => element.id == photoAlbum.id)) {
              Album videoAlbum = videoAlbums.singleWhere((element) => element.id == photoAlbum.id);
              GalleryAlbum videoGalleryAlbum = GalleryAlbum.album(videoAlbum);
              await videoGalleryAlbum.initialize(locale: locale);
              DateTime? lastPhotoDate = entireGalleryAlbum.lastDate;
              DateTime? lastVideoDate = videoGalleryAlbum.lastDate;
              if (lastPhotoDate == null) {
                try {
                  entireGalleryAlbum.thumbnail = await videoAlbum.getThumbnail(highQuality: true);
                } catch (e) {
                  if (kDebugMode) {
                    print("=========$e");
                  }
                }
              } else if (lastVideoDate == null) {
              } else {
                if (lastVideoDate.isAfter(lastPhotoDate)) {
                  try {
                    entireGalleryAlbum.thumbnail = await videoAlbum.getThumbnail(highQuality: true);
                  } catch (e) {
                    entireGalleryAlbum.thumbnail = null;
                    if (kDebugMode) {
                      print("=========$e");
                    }
                  }
                }
              }
              for (var file in videoGalleryAlbum.files) {
                entireGalleryAlbum.addFile(file, locale: locale);
              }
              entireGalleryAlbum.sort();
              entireGalleryAlbum.setType = AlbumType.mixed;
              videoAlbums.remove(videoAlbum);
            }
          }
          tempGalleryAlbums.add(entireGalleryAlbum);
        }
      }
      if (pickType == PickType.onlyVideo || pickType == PickType.imageOrVideo) {
        for (var videoAlbum in videoAlbums) {
          GalleryAlbum galleryVideoAlbum = GalleryAlbum.album(videoAlbum);
          await galleryVideoAlbum.initialize(locale: locale);
          galleryVideoAlbum.setType = AlbumType.video;
          tempGalleryAlbums.add(galleryVideoAlbum);
        }
      }

      return GalleryMedia(tempGalleryAlbums);
    } else {
      return null;
    }
  }

  GalleryAlbum? get recent {
    return galleryAlbums.isNotEmpty
        ? galleryAlbums.singleWhere(
            (element) => element.album.name == "All",
          )
        : null;
  }

  List<Medium> sortAlbumMediaDates(List<Medium> mediumList) {
    mediumList.sort((a, b) {
      if (a.lastDate == null) {
        return 1;
      } else if (b.lastDate == null) {
        return -1;
      } else {
        return a.lastDate!.compareTo(b.lastDate!);
      }
    });
    return mediumList;
  }

  void disposeController() {
    _media = null;
    _selectedFiles = [];
    _isInitialized = false;
  }

  bool isSelectedMedia({required MediaFile file}) {
    return _selectedFiles.any((element) => element.id == file.id);
  }

  void switchPickerMode({required bool value}) {
    if (!value) {
      _selectedFiles.clear();
      reloadState();
    }
    _pickerMode = value;
    emit(Random().nextDouble());
  }
}
