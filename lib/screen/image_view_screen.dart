import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_app/models/media_file.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ImageViewScreen extends StatefulWidget {
  final MediaFile mediaFile;
  const ImageViewScreen({super.key, required this.mediaFile});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  void initState() {
    loadVideo();
    super.initState();
  }

  VideoPlayerController? videoPlayerController;
  Future<void> loadVideo() async {
    File file = await widget.mediaFile.getFile();
    videoPlayerController = VideoPlayerController.file(file);
    await videoPlayerController?.initialize();
    videoPlayerController?.play();
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade700,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.grey.shade700,
        body: Center(
          child: widget.mediaFile.thumbnail != null
              ? widget.mediaFile.isImage
                  ? Image(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/warning.png",
                        );
                      },
                      image: MemoryImage(widget.mediaFile.thumbnail!),
                    )
                  : videoPlayerController != null
                      ? VideoPlayer(videoPlayerController!)
                      : const Text("Type Is Video...")
              : const Text("Image Not Load..."),
        ),
      ),
    );
  }
}
