import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery_picker/presentation/cubit/gallery_picker_cubit.dart';
import 'package:gallery_app/global.dart';
import 'package:gallery_app/models/gallery_album.dart';

AppBar customAppBar({
  required BuildContext context,
  GalleryAlbum? album,
  GalleryPickerCubit? controller,
  List<Widget>? actions,
  bool isLeadingIcon = false,
  bool isBack = false,
  Color? leadingIconColor,
  Color? backgroundColor,
  Color? textColor,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppColor.whiteColor,
    surfaceTintColor: backgroundColor ?? AppColor.whiteColor,
    leadingWidth: isLeadingIcon ? 50 : 0,
    leading: isLeadingIcon
        ? IconButton(
            onPressed: () => isBack ? Navigator.pop(context) : controller?.backToPicker(),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: leadingIconColor ?? AppColor.blackColor),
          )
        : const SizedBox.shrink(),
    title: Text(
      isLeadingIcon ? getTitle(album: album, controller: controller) : "Gallery",
      style: TextStyle(
        color: textColor ?? AppColor.blackColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    actions: actions,
  );
}

String getTitle({GalleryAlbum? album, GalleryPickerCubit? controller}) {
  if (!(controller?.pickerMode ?? false) && (controller?.selectedFiles.isEmpty ?? false)) {
    return "${album?.name}";
  } else if ((controller?.pickerMode ?? false) && (controller?.selectedFiles.isEmpty ?? false)) {
    return controller?.config.tapPhotoSelect ?? "";
  } else if ((controller?.pickerMode ?? false) && (controller?.selectedFiles.isNotEmpty ?? false)) {
    return "${controller?.selectedFiles.length} ${controller?.config.selected}";
  } else {
    return "";
  }
}
