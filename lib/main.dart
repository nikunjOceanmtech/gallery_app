import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gallery_app/di/get_it.dart' as get_it;
import 'package:gallery_app/screen/gallery_picker_view.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  unawaited(get_it.init());

  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GalleryPickerView(
          onSelect: (selectedMedia) {},
        ),
      ),
    );
  }
}
