import 'package:flutter/material.dart';
import 'package:gallery_app/global.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDeniedView extends StatelessWidget {
  const PermissionDeniedView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColor.whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Please allow access to your photos",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              const Text(
                "This lets access your photos and videos from your library.",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async => await openAppSettings(),
                child: const Text("Enable library access"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
