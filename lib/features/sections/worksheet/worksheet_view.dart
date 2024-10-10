import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/features/sections/worksheet/student_worksheet_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/vertical_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class WorksheetView extends StatefulWidget {
  final String levelId;
  const WorksheetView({super.key, required this.levelId});

  @override
  State<WorksheetView> createState() => _WorksheetViewState();
}

class _WorksheetViewState extends State<WorksheetView> {
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    final viewmodel = context.read<StudentWorksheetViewModel>();

    viewmodel.levelId = widget.levelId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewmodel.setValuesAndInit();
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentWorksheetViewModel>(
      builder: (test, viewmodel, _) => Scaffold(
        appBar: AppBar(
          title: const Text("Worksheets"),
        ),
        body: Center(
          child: _isloading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constants.padding12,
                      vertical: Constants.padding8),
                  child: Column(
                    children: [
                      Expanded(
                        child: viewmodel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: viewmodel.worksheets.length,
                                itemBuilder: (context, index) {
                                  final currentWorksheet = viewmodel
                                      .worksheets.entries
                                      .elementAt(index);
                                  final worksheetId =
                                      currentWorksheet.key.toString();
                                  final worksheet =
                                      currentWorksheet.value as Worksheet;
                                  final isSubmitted = viewmodel
                                      .getCurrentUserSubmission(worksheetId);
                                  return VerticalListItemCard(
                                    mainText: worksheet.title ??
                                        "Worksheet #${index + 1}",
                                    //
                                    // subText: "", TODO: ADD DESCRIPTION
                                    info: Text(
                                      "Due on ${worksheet.timestamp!.toDate().toString().split(" ")[0]}",
                                      style: const TextStyle(
                                        color: Palette.secondaryText,
                                      ),
                                    ),
                                    action: isSubmitted
                                        ? Icons.remove_red_eye
                                        : Icons.arrow_forward_ios,
                                    showDeleteIcon: false,
                                    showIconDivider: false,
                                    onTap: () async {
                                      if (isSubmitted) {
                                        viewmodel.getCurrentUserSubmission(
                                            worksheetId);
                                        context.push(
                                            '/student_worksheet_view/$worksheetId');
                                      } else {
                                        final pickedImage =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (pickedImage != null) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: const Text(
                                                    "Are you sure you want to upload the selected image?"),
                                                title: const Text(
                                                    'Confirm Upload'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      await viewmodel
                                                          .uploadStudentSubmission(
                                                              imagePath:
                                                                  pickedImage
                                                                      .path,
                                                              worksheetID:
                                                                  worksheetId);
                                                    },
                                                    child: const Text('Upload'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// UploadCard(
//                             onPressed: () async {
//                               // TODO: Implement image upload in viewmodel
//                               final pickedImage = await ImagePicker().pickImage(
//                                 source: ImageSource.gallery,
//                               );
//                               if (pickedImage != null) {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       content: const Text(
//                                           "Are you sure you want to upload the selected image?"),
//                                       title: const Text('Confirm Upload'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: const Text('Cancel'),
//                                         ),
//                                         TextButton(
//                                           onPressed: () async {
//                                             Navigator.pop(context);
//                                             // TODO: Change the paramaters after implementing the UI
//                                             await viewmodel
//                                                 .uploadStudentSubmission(
//                                                     levelID: "A1",
//                                                     imagePath: pickedImage.path,
//                                                     worksheetID: "1");
//                                           },
//                                           child: const Text('Upload'),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               }
//                             },
//                             child: SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   AutoSizeText(
//                                     'Add Worksheet',
//                                     style: TextStyles.cardHeader
//                                         .copyWith(fontSize: 18),
//                                     textAlign: TextAlign.center,
//                                     maxLines: 3,
//                                   ),
//                                   const Expanded(
//                                     child: FittedBox(
//                                       child: Icon(
//                                         Icons.add_rounded,
//                                         color: Palette.secondaryText,
//                                       ),
//                                     ),
//                                   ),
//                                   AutoSizeText(
//                                     "Submit your worksheet",
//                                     style: TextStyles.cardText,
//                                     textAlign: TextAlign.center,
//                                     maxLines: 3,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
