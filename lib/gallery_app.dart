// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/di/get_it.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/global.dart';
import 'package:gallery_app/home_screen.dart';

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
      child: const SafeArea(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
  }
}
