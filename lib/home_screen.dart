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
        body: GridView.builder(
          itemCount: selectedMediaList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemBuilder: (context, index) {
            if (selectedMediaList[index].thumbnail != null) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageOrVideoShowScreen(
                        mediaFile: selectedMediaList[index],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () async {
            List<MediaFile>? data = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GalleryPickerView(
                    initSelectedMedia: selectedMediaList,
                    pickType: PickType.onlyImage,
                    startWithRecent: true,
                    isBottomSheet: true,
                  );
                },
              ),
            );

            if (data != null) {
              selectedMediaList.clear();
              selectedMediaList.addAll(data.toSet().toList());
              setState(() {});
            }
          },
          child: const Text("Only Image"),
        ),
        ElevatedButton(
          onPressed: () async {
            List<MediaFile>? data = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const GalleryPickerView(
                    pickType: PickType.onlyVideo,
                    startWithRecent: true,
                  );
                },
              ),
            );
            if (data != null) {
              selectedMediaList.clear();
              selectedMediaList.addAll(data.toSet().toList());
              setState(() {});
            }
          },
          child: const Text("Only Video"),
        ),
        ElevatedButton(
          onPressed: () async {
            List<MediaFile>? data = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GalleryPickerView(
                    pickType: PickType.imageOrVideo,
                    startWithRecent: true,
                    initSelectedMedia: selectedMediaList,
                  );
                },
              ),
            );
            if (data != null) {
              selectedMediaList.clear();
              selectedMediaList.addAll(data.toSet().toList());
              setState(() {});
            }
          },
          child: const Text("Image Or Video"),
        ),
      ],
    );
  }
}
