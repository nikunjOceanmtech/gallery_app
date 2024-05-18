import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/di/get_it.dart' as get_it;
import 'package:gallery_app/di/get_it.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/global.dart';
import 'package:gallery_app/features/gallery_picker/presentation/pages/gallery_picker_view.dart';

void main() {
  unawaited(get_it.init());

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GalleryPickerCubit _galleryPickerCubit;

  @override
  void initState() {
    _galleryPickerCubit = getItInstance<GalleryPickerCubit>();
    galleryPickerCubit = _galleryPickerCubit;
    super.initState();
  }

  @override
  void dispose() {
    _galleryPickerCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GalleryPickerCubit>.value(value: _galleryPickerCubit),
      ],
      child: SafeArea(
        child: Scaffold(
          body: GalleryPickerView(
            onSelect: (selectedMedia) {},
          ),
        ),
      ),
    );
  }
}
