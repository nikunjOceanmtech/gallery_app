// import 'package:flutter/material.dart';

// class ViewScreen extends StatefulWidget {
//   final List<AssetPathEntity> paths;

//   const ViewScreen({super.key, required this.paths});

//   @override
//   State<ViewScreen> createState() => _ViewScreenState();
// }

// class _ViewScreenState extends State<ViewScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GridView.builder(
//         itemCount: widget.paths.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//         itemBuilder: (context, index) {
//           return Container(
//             alignment: Alignment.center,
//             child: Text(
//               widget.paths[index].name,
//               textAlign: TextAlign.center,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xff084277);
  static const Color whiteColor = Color(0xffffffff);
}
