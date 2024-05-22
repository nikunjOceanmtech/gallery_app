import 'package:flutter/material.dart';
import 'package:gallery_app/di/get_it.dart';
import 'package:gallery_app/features/gallery_picker/data/models/media_file.dart';
import 'package:gallery_app/features/image_or_video_show/presentation/cubit/image_or_video_show_cubit.dart';
import 'package:gallery_app/global.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageOrVideoShowScreen extends StatefulWidget {
  final MediaFile mediaFile;
  final bool isSingleMedia;
  const ImageOrVideoShowScreen({super.key, required this.mediaFile, required this.isSingleMedia});

  @override
  State<ImageOrVideoShowScreen> createState() => _ImageOrVideoShowScreenState();
}

class _ImageOrVideoShowScreenState extends State<ImageOrVideoShowScreen> {
  late ImageOrVideoShowCubit imageOrVideoCubit;

  @override
  void initState() {
    imageOrVideoCubit = getItInstance<ImageOrVideoShowCubit>();
    imageOrVideoCubit.loadVideo(mediaFile: widget.mediaFile);
    super.initState();
  }

  @override
  void dispose() {
    imageOrVideoCubit.videoController?.dispose();
    imageOrVideoCubit.videoController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.blackColor,
        body: BlocBuilder<ImageOrVideoShowCubit, double>(
          bloc: imageOrVideoCubit,
          builder: (context, state) {
            return Stack(
              children: [
                Center(
                  child: imageOrVideoCubit.file != null
                      ? widget.mediaFile.isImage
                          ? imageView(context: context)
                          : videoView()
                      : commonLoadingBar(),
                ),
                Container(
                  height: 50,
                  color: AppColor.blackColor.withOpacity(0.2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.whiteColor),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat('MMM dd, yyyy').format(widget.mediaFile.lastModified ?? DateTime.now()),
                          style: TextStyle(color: AppColor.whiteColor, fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          galleryPickerCubit.selectedFiles.add(widget.mediaFile);
                          Navigator.pop(context, galleryPickerCubit.selectedFiles);
                        },
                        icon: Icon(Icons.check, color: AppColor.whiteColor),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget videoView() {
    if (imageOrVideoCubit.videoController != null) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          InteractiveViewer(
            maxScale: double.infinity,
            child: Center(
              child: AspectRatio(
                aspectRatio: imageOrVideoCubit.videoController!.value.aspectRatio,
                child: VideoPlayer(imageOrVideoCubit.videoController!),
              ),
            ),
          ),
          // playPauseIconView(),
          sliderView(),
        ],
      );
    } else {
      return commonLoadingBar();
    }
  }

  Widget imageView({required BuildContext context}) {
    return InteractiveViewer(
      maxScale: double.infinity,
      child: Image.file(
        imageOrVideoCubit.file!,
        errorBuilder: errorPlaceHolder,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.contain,
      ),
    );
  }

  // Widget playPauseIconView() {
  //   return InkWell(
  //     splashColor: Colors.transparent,
  //     splashFactory: NoSplash.splashFactory,
  //     highlightColor: Colors.transparent,
  //     onTap: () => imageOrVideoCubit.playOrPause(),
  //     child: Center(
  //       child: imageOrVideoCubit.isIconShow
  //           ? Visibility(
  //               visible: imageOrVideoCubit.isIconShow,
  //               child: Image.asset(
  //                 (imageOrVideoCubit.videoController?.value.isPlaying ?? false)
  //                     ? 'assets/images/Pause.png'
  //                     : 'assets/images/Play.png',
  //                 height: 50,
  //                 errorBuilder: errorPlaceHolder,
  //               ),
  //             )
  //           : const SizedBox.shrink(),
  //     ),
  //   );
  // }

  Widget sliderView() {
    return Container(
      color: AppColor.blackColor.withOpacity(0.2),
      height: 100,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => imageOrVideoCubit.playOrPause(),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  child: Image.asset(
                    (imageOrVideoCubit.videoController?.value.isPlaying ?? false)
                        ? 'assets/images/Pause.png'
                        : 'assets/images/Play.png',
                    height: 40,
                    errorBuilder: errorPlaceHolder,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  findDuration(imageOrVideoCubit.videoController?.value.position ?? Duration.zero),
                  style: TextStyle(color: AppColor.whiteColor),
                ),
                const Spacer(),
                Text(
                  findDuration(imageOrVideoCubit.videoController?.value.duration ?? Duration.zero),
                  style: TextStyle(color: AppColor.whiteColor),
                ),
              ],
            ),
          ),
          Slider(
            min: 0,
            value: imageOrVideoCubit.videoController?.value.position.inSeconds.toDouble() ?? 0,
            max: imageOrVideoCubit.videoController?.value.duration.inSeconds.toDouble() ?? 0,
            onChanged: (value) => imageOrVideoCubit.seekDuration(value: value.toInt()),
            activeColor: AppColor.primaryColor,
            inactiveColor: AppColor.whiteColor,
          ),
        ],
      ),
    );
  }

  String findDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
