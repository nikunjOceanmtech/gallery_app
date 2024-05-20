import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/data/models/media_file.dart';
import 'package:gallery_app/features/image_or_video_show/presentation/view/image_or_video_show_screen.dart';

import 'features/gallery_picker/presentation/pages/gallery_picker_view.dart';

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
            crossAxisCount: 3,
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
                child: Image.memory(
                  selectedMediaList[index].thumbnail!,
                  fit: BoxFit.cover,
                ),
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GalleryPickerView(
                    onSelect: (selectedMedia) {
                      if (kDebugMode) {
                        print("============$selectedMedia");
                      }
                      selectedMediaList = selectedMedia;
                      setState(() {});
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
