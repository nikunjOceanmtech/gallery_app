import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/media_file.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/gallery_picker_view.dart';
import 'package:gallery_app/features/image_or_video_show/presentation/view/image_or_video_show_screen.dart';
import 'package:gallery_app/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MediaFile> selectedMediaList = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: GridView.builder(
          itemCount: selectedMediaList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, index) {
            if (selectedMediaList[index].thumbnail != null) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageOrVideoShowScreen(
                        mediaFile: selectedMediaList[index],
                        isSingleMedia: false,
                      ),
                    ),
                  );
                },
                child: Image.memory(selectedMediaList[index].thumbnail!),
              );
            }
            return const SizedBox();
          },
        ),
        bottomNavigationBar: bottomNavigationBar(context: context),
      ),
    );
  }

  Widget bottomNavigationBar({required BuildContext context}) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async => await pickMedia(pickType: PickType.onlyImage),
          child: const Text("Image"),
        ),
        ElevatedButton(
          onPressed: () async => await pickMedia(pickType: PickType.onlyVideo),
          child: const Text("Video"),
        ),
        ElevatedButton(
          onPressed: () async => await pickMedia(pickType: PickType.imageOrVideo),
          child: const Text("Image Or Video"),
        ),
        ElevatedButton(
          onPressed: () async => await pickMedia(pickType: PickType.onlyImage, singleMedia: true),
          child: const Text("Signle Image"),
        ),
        ElevatedButton(
          onPressed: () async => await pickMedia(pickType: PickType.onlyVideo, singleMedia: true),
          child: const Text("Signle Video"),
        ),
        ElevatedButton(
          onPressed: () async => await pickMedia(pickType: PickType.imageOrVideo, singleMedia: true),
          child: const Text("Signle Image Or Video"),
        ),
      ],
    );
  }

  Future<void> pickMedia({
    required PickType pickType,
    bool isInitialSelectMedia = false,
    bool singleMedia = false,
  }) async {
    List<MediaFile>? data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return GalleryPickerView(
            singleMedia: singleMedia,
            pickType: pickType,
            startWithRecent: true,
            initSelectedMedia: isInitialSelectMedia ? selectedMediaList : [],
          );
        },
      ),
    );
    if (data != null) {
      selectedMediaList.clear();
      selectedMediaList.addAll(data.toSet().toList());
      setState(() {});
    }
  }
}
