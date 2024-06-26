import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/features/image_or_video_show/presentation/cubit/image_or_video_show_cubit.dart';
import 'package:get_it/get_it.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerFactory(() => ImageOrVideoShowCubit());
  getItInstance.registerFactory(() => GalleryPickerCubit());
}
