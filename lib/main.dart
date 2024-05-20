import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gallery_app/di/get_it.dart' as get_it;
import 'package:gallery_app/gallery_app.dart';

void main() {
  unawaited(get_it.init());

  runApp(const MyApp());
}
