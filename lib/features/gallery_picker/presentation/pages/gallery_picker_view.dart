import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final PickType pickType;

  const GalleryPickerView({
    required this.pickType,
    super.key,
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

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    galleryPickerCubit.configuration(
      onSelect: (value) {},
      startWithRecent: widget.startWithRecent,
      heroBuilder: widget.heroBuilder,
      multipleMediasBuilder: widget.multipleMediaBuilder,
      initSelectedMedias: widget.initSelectedMedia,
      extraRecentMedia: widget.extraRecentMedia,
      isRecent: true,
    );
    if (!galleryPickerCubit.isInitialized) {
      await galleryPickerCubit.initializeAlbums(
        locale: widget.locale,
        pickType: widget.pickType,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  GalleryAlbum? selectedAlbum;

  double width = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
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
                      backgroundColor: AppColor.whiteColor,
                      appBar: customAppBar(
                        context: context,
                        controller: galleryPickerCubit,
                        isBack: true,
                        isLeadingIcon: true,
                        actions: galleryPickerCubit.selectedFiles.isNotEmpty
                            ? [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context, galleryPickerCubit.selectedFiles);
                                  },
                                  icon: const Icon(Icons.check, size: 30),
                                )
                              ]
                            : [
                                // Text(
                                //   "Videos Show :-",
                                //   style: TextStyle(
                                //     color: AppColor.blackColor,
                                //     fontWeight: FontWeight.bold,
                                //     fontSize: 18,
                                //   ),
                                // ),
                                // galleryPickerCubit.selectedFiles.isNotEmpty
                                //     ? const SizedBox()
                                //     : Checkbox(
                                //         value: noPhotoSeleceted,
                                //         onChanged: (value) async {
                                //           noPhotoSeleceted = value ?? false;
                                //           await galleryPickerCubit.initializeAlbums(
                                //             pickType: PickType.onlyImage,
                                //             locale: widget.locale,
                                //             isVideo: noPhotoSeleceted,
                                //           );
                                //         },
                                //       ),
                              ],
                      ),
                      body: Column(
                        children: [
                          tabBarView(),
                          !galleryPickerCubit.isInitialized ? Expanded(child: commonLoadingBar()) : screenView(),
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
            : const PermissionDeniedView();
      },
    );
  }

  Widget screenView() {
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
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
            isBottomSheet: widget.isBottomSheet,
            singleMedia: widget.singleMedia,
            text: noPhotoSeleceted ? "Data Not Foound" : "Data Not Foound",
          ),
        ],
      ),
    );
  }

  Widget imagesView() {
    return galleryPickerCubit.isInitialized && galleryPickerCubit.recent != null
        ? galleryPickerCubit.recent!.dateCategories.isEmpty
            ? dataNotFound(
                text: noPhotoSeleceted ? "Data Not Foound" : "Data Not Foound",
              )
            : AlbumMediasView(
                galleryAlbum: galleryPickerCubit.recent!,
                controller: galleryPickerCubit,
                isBottomSheet: widget.isBottomSheet,
                singleMedia: widget.singleMedia,
              )
        : commonLoadingBar();
  }

  Widget tabBarView() {
    return InkWell(
      onTap: () {
        galleryPickerCubit.pickerPageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeIn,
        );
        galleryPickerCubit.isRecent = true;
        galleryPickerCubit.switchPickerMode(value: false);
      },
      child: Container(
        width: width,
        height: 48,
        color: AppColor.whiteColor,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: galleryPickerCubit.isRecent
                  ? BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.primaryColor, width: 3.0)))
                  : null,
              height: 48,
              alignment: Alignment.center,
              width: width / 2,
              child: Text(
                "Recents",
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: galleryPickerCubit.isRecent ? FontWeight.bold : FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              decoration: !galleryPickerCubit.isRecent
                  ? BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.primaryColor, width: 3.0)))
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
                  "Gallery",
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontWeight: !galleryPickerCubit.isRecent ? FontWeight.bold : FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
