import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/features/gallery_picker/data/models/config.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/features/gallery_picker/data/models/media_file.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/album_categories_view.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/album_medias_view.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/album_page.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/appbars.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/permission_denied_view.dart';
import 'package:gallery_app/global.dart';

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
  bool noPhotoSeleceted = false;
  late Config config;

  @override
  void initState() {
    galleryPickerCubit.loadingData(isLoading: true);
    galleryPickerCubit.updateConfig(widget.config);
    galleryPickerCubit.configuration(
      galleryPickerCubit.config,
      onSelect: widget.onSelect,
      startWithRecent: widget.startWithRecent,
      heroBuilder: widget.heroBuilder,
      multipleMediasBuilder: widget.multipleMediaBuilder,
      initSelectedMedias: widget.initSelectedMedia,
      extraRecentMedia: widget.extraRecentMedia,
      isRecent: widget.startWithRecent,
      isVideo: true,
    );
    config = galleryPickerCubit.config;
    if (!galleryPickerCubit.isInitialized) {
      galleryPickerCubit.initializeAlbums(locale: widget.locale, isVideo: false);
    }
    galleryPickerCubit.loadingData(isLoading: false);
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
    return BlocBuilder<GalleryPickerCubit, double>(
      bloc: galleryPickerCubit,
      builder: (context, state) {
        return galleryPickerCubit.permissionGranted != false
            ? PageView(
                controller: galleryPickerCubit.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PopScope(
                    canPop: true,
                    onPopInvoked: (value) {
                      if (!widget.isBottomSheet) {
                        galleryPickerCubit.disposeController();
                      }
                    },
                    child: Scaffold(
                      backgroundColor: config.backgroundColor,
                      appBar: customAppBar(
                        context: context,
                        controller: galleryPickerCubit,
                        isBack: true,
                        isLeadingIcon: true,
                        actions: galleryPickerCubit.selectedFiles.isNotEmpty
                            ? [
                                IconButton(
                                  onPressed: () {
                                    widget.onSelect(galleryPickerCubit.selectedFiles);
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.check, size: 30),
                                )
                              ]
                            : [
                                Text(
                                  "Videos Show :-",
                                  style: TextStyle(
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                galleryPickerCubit.selectedFiles.isNotEmpty
                                    ? const SizedBox()
                                    : Checkbox(
                                        value: noPhotoSeleceted,
                                        onChanged: (value) async {
                                          noPhotoSeleceted = value ?? false;
                                          await galleryPickerCubit.initializeAlbums(
                                            locale: widget.locale,
                                            isVideo: noPhotoSeleceted,
                                          );
                                        },
                                      ),
                              ],
                      ),
                      body: Column(
                        children: [
                          tabBarView(width: width),
                          galleryPickerCubit.isLoadingData ? Expanded(child: commonLoadingBar()) : screenView(),
                        ],
                      ),
                    ),
                  ),
                  AlbumPage(
                    album: galleryPickerCubit.selectedAlbum,
                    controller: galleryPickerCubit,
                    singleMedia: widget.singleMedia,
                    isBottomSheet: widget.isBottomSheet,
                  )
                ],
              )
            : galleryPickerCubit.config.permissionDeniedPage ?? PermissionDeniedView(config: galleryPickerCubit.config);
      },
    );
  }

  Widget screenView() {
    return Expanded(
      child: PageView(
        controller: galleryPickerCubit.pickerPageController,
        onPageChanged: (index) {
          if (index == 0) {
            galleryPickerCubit.isRecent = true;
            galleryPickerCubit.switchPickerMode(value: false);
          } else {
            galleryPickerCubit.isRecent = false;
            galleryPickerCubit.switchPickerMode(value: false);
          }
        },
        scrollDirection: Axis.horizontal,
        children: [
          imagesView(),
          AlbumCategoriesView(
            controller: galleryPickerCubit,
            isBottomSheet: widget.isBottomSheet,
            singleMedia: widget.singleMedia,
            text: noPhotoSeleceted ? "Video Data Not Foound" : "Image Data Not Foound",
          ),
        ],
      ),
    );
  }

  Widget imagesView() {
    return galleryPickerCubit.isInitialized && galleryPickerCubit.recent != null
        ? galleryPickerCubit.recent!.dateCategories.isEmpty
            ? dataNotFound(
                text: noPhotoSeleceted ? "Video Data Not Foound" : "Image Data Not Foound",
              )
            : AlbumMediasView(
                galleryAlbum: galleryPickerCubit.recent!,
                controller: galleryPickerCubit,
                isBottomSheet: widget.isBottomSheet,
                singleMedia: widget.singleMedia,
              )
        : commonLoadingBar();
  }

  Widget tabBarView({required double width}) {
    return Container(
      width: width,
      height: 48,
      color: config.appbarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: galleryPickerCubit.isRecent
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
                galleryPickerCubit.pickerPageController.animateToPage(
                  0,
                  duration: const Duration(
                    milliseconds: 50,
                  ),
                  curve: Curves.easeIn,
                );
                setState(() {
                  galleryPickerCubit.isRecent = true;
                  galleryPickerCubit.switchPickerMode(value: false);
                });
              },
              child: Text(
                config.recents,
                style: galleryPickerCubit.isRecent ? config.selectedMenuStyle : config.unselectedMenuStyle,
              ),
            ),
          ),
          Container(
            decoration: !galleryPickerCubit.isRecent
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
                galleryPickerCubit.pickerPageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.easeIn,
                );
                galleryPickerCubit.isRecent = false;
                galleryPickerCubit.switchPickerMode(value: false);
              },
              child: Text(
                config.gallery,
                style: galleryPickerCubit.isRecent ? config.unselectedMenuStyle : config.selectedMenuStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
