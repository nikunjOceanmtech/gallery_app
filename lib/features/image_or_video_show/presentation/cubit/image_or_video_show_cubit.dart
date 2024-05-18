import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:gallery_app/models/media_file.dart';
import 'package:video_player/video_player.dart';

class ImageOrVideoShowCubit extends Cubit<double> {
  ImageOrVideoShowCubit() : super(0);

  bool isIconShow = false;
  VideoPlayerController? videoController;

  Future<void> loadVideo({required MediaFile mediaFile}) async {
    File videoFile = await mediaFile.getFile();
    videoController = VideoPlayerController.file(videoFile);
    await videoController?.initialize();
    videoController?.play();
    videoController?.addListener(() => emit(Random().nextDouble()));
  }

  void playOrPause() {
    isIconShow = true;
    emit(Random().nextDouble());
    Future.delayed(const Duration(seconds: 1), () => isIconShow = false);

    if (videoController?.value.isPlaying ?? false) {
      videoController?.pause();
    } else {
      videoController?.play();
    }
    emit(Random().nextDouble());
  }

  void seekDuration({required int value}) {
    print("======$value");
    videoController?.seekTo(Duration(seconds: value)).then(
      (value) {
        emit(Random().nextDouble());
      },
    );
  }
}
