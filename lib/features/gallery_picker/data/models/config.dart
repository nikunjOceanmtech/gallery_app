import 'package:flutter/material.dart';
import 'package:gallery_app/global.dart';

import 'mode.dart';

class Config {
  late Widget selectIcon;
  Widget? permissionDeniedPage;
  late Color backgroundColor, appbarIconColor, underlineColor;
  late TextStyle textStyle, appbarTextStyle, selectedMenuStyle, unselectedMenuStyle;
  String recents, recent, gallery, lastMonth, lastWeek, tapPhotoSelect, selected;
  Mode mode;

  Config({
    Color? backgroundColor,
    Color? appbarIconColor,
    Color? underlineColor,
    TextStyle? selectedMenuStyle,
    TextStyle? unselectedMenuStyle,
    TextStyle? textStyle,
    TextStyle? appbarTextStyle,
    this.permissionDeniedPage,
    this.recents = "Recents",
    this.recent = "Recent",
    this.gallery = "Gallery",
    this.lastMonth = "Last Month",
    this.lastWeek = "Last Week",
    this.tapPhotoSelect = "Tap photo to select",
    this.selected = "Selected",
    this.mode = Mode.light,
    Widget? selectIcon,
  }) {
    if (backgroundColor == null) {
      this.backgroundColor = mode == Mode.dark ? const Color.fromARGB(255, 18, 27, 34) : AppColor.whiteColor;
    }
    if (appbarIconColor == null) {
      this.appbarIconColor = mode == Mode.dark ? AppColor.whiteColor : const Color.fromARGB(255, 130, 141, 148);
    }
    if (underlineColor == null) {
      this.underlineColor =
          mode == Mode.dark ? const Color.fromARGB(255, 6, 164, 130) : const Color.fromARGB(255, 20, 161, 131);
    }
    if (selectedMenuStyle == null) {
      this.selectedMenuStyle = TextStyle(color: mode == Mode.dark ? AppColor.whiteColor : AppColor.blackColor);
    }
    if (unselectedMenuStyle == null) {
      this.unselectedMenuStyle =
          TextStyle(color: mode == Mode.dark ? Colors.grey : const Color.fromARGB(255, 102, 112, 117));
    }
    if (textStyle == null) {
      this.textStyle = TextStyle(
        color: mode == Mode.dark ? Colors.grey[300]! : const Color.fromARGB(255, 108, 115, 121),
        fontWeight: FontWeight.bold,
      );
    }
    if (appbarTextStyle == null) {
      this.appbarTextStyle = TextStyle(color: mode == Mode.dark ? AppColor.whiteColor : AppColor.blackColor);
    }
    this.selectIcon = selectIcon ??
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 0, 168, 132),
          ),
          child: Icon(Icons.check, color: AppColor.whiteColor),
        );
  }
}
