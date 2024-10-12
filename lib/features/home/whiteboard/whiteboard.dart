// import 'package:ez_english/features/home/whiteboard/whiteboard_item.dart';
// import 'package:ez_english/features/home/whiteboard/whiteboard_viewmodel.dart';
// import 'package:ez_english/theme/palette.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// class Whiteboard extends StatefulWidget {
//   const Whiteboard({super.key});

//   @override
//   State<Whiteboard> createState() => _WhiteboardState();
// }

// class _WhiteboardState extends State<Whiteboard> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<WhiteboardViewmodel>(context, listen: false).fetchWhiteboards();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WhiteboardViewmodel>(builder: (context, viewmodel, _) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Whiteboard',
//             style: TextStyle(color: Palette.primaryText),
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//         ),
//         body: Center(
//           child: viewmodel.isLoading
//               ? const CircularProgressIndicator()
//               : SingleChildScrollView(
//                   padding: EdgeInsets.all(5.w),
//                   child: Wrap(
//                     spacing: 10.w,
//                     runSpacing: 10.h,
//                     children: List.generate(5, (index) {
//                       return WhiteboardItem(
//                         index: index,
//                         whiteboardModel: viewmodel.whiteboards[index],
//                       );
//                     }),
//                   )),
//         ),
//       );
//     });
//   }
// }
