// import 'dart:async';
// import 'dart:math';

// import 'package:ez_english/features/home/whiteboard/whiteboard_model.dart';
// import 'package:ez_english/features/models/base_viewmodel.dart';

// class WhiteboardViewmodel extends BaseViewModel {
//   @override
//   FutureOr<void> init() {}
//   List<WhiteboardModel> _whiteboards = [];
//   List<WhiteboardModel> get whiteboards => _whiteboards;

//   Future<void> fetchWhiteboards() async {
//     if (_whiteboards.isNotEmpty) return;
//     isLoading = true;
//     try {
//       _whiteboards = List.generate(5, (index) {
//         return WhiteboardModel(
//           title: "${firstWords[Random().nextInt(firstWords.length)]} practice",
//           description: "This is a description",
//           imageUrl: Random().nextBool()
//               ? 'https://source.cocosign.com/images/contract-templates/wedding/wedding_1.jpg'
//               : "https://picsum.photos/200/300?random=${Random().nextInt(100)}",
//         );
//       });
//       await Future.delayed(const Duration(seconds: 2));
//     } catch (e) {
//       handleError(e);
//     } finally {
//       isLoading = false;
//     }
//   }

//   void handleError(Object error) {}
// }

// List<String> firstWords = [
//   "Speaking",
//   "Listening",
//   "Reading",
//   "Writing",
//   "Grammar",
//   "Vocabulary",
//   "Pronunciation",
// ];
