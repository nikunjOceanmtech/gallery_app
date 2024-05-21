import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/widgets/album_medias_view.dart';
import 'package:gallery_app/features/gallery_picker/presentation/widgets/appbars.dart';
import 'package:gallery_app/global.dart';

class AlbumDataView extends StatefulWidget {
  final GalleryAlbum album;
  const AlbumDataView({super.key, required this.album});

  @override
  State<AlbumDataView> createState() => _AlbumDataViewState();
}

class _AlbumDataViewState extends State<AlbumDataView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        album: widget.album,
        isTitleShow: true,
        isBack: true,
        isLeadingIcon: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, galleryPickerCubit.selectedFiles);
            },
            icon: const Icon(Icons.check, size: 30),
          )
        ],
      ),
      body: BlocBuilder<GalleryPickerCubit, double>(
        builder: (context, state) {
          return imagesView();
        },
      ),
    );
  }

  Widget imagesView() {
    return galleryPickerCubit.isInitialized && galleryPickerCubit.recent != null
        ? galleryPickerCubit.recent!.dateCategories.isEmpty
            ? dataNotFound(
                text: "Data Not Foound",
              )
            : AlbumMediasView(
                galleryAlbum: galleryPickerCubit.recent!,
                controller: galleryPickerCubit,
                isBottomSheet: false,
                singleMedia: false,
              )
        : commonLoadingBar();
  }
}
