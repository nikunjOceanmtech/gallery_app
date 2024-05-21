import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/features/gallery_picker/data/models/gallery_album.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/album_medias_view.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/appbars.dart';
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
    return BlocBuilder<GalleryPickerCubit, double>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.whiteColor,
          appBar: customAppBar(
            onPressed: () {
              galleryPickerCubit.selectedFiles.clear();
              galleryPickerCubit.reloadState();
              Navigator.pop(context);
            },
            context: context,
            album: widget.album,
            isTitleShow: true,
            isBack: true,
            isLeadingIcon: true,
            actions: galleryPickerCubit.selectedFiles.isEmpty
                ? []
                : [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context, galleryPickerCubit.selectedFiles);
                      },
                      icon: const Icon(Icons.check, size: 30),
                    )
                  ],
          ),
          body: AlbumMediasView(
            galleryAlbum: widget.album,
            controller: galleryPickerCubit,
            singleMedia: false,
          ),
        );
      },
    );
  }
}
