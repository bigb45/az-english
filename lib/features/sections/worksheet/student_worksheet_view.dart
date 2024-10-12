import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/worksheet/student_worksheet_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentWorksheetView extends StatefulWidget {
  final String worksheetId;

  const StudentWorksheetView({super.key, required this.worksheetId});

  @override
  State<StudentWorksheetView> createState() => _StudentWorksheetViewState();
}

class _StudentWorksheetViewState extends State<StudentWorksheetView> {
  @override
  void initState() {
    super.initState();
    final viewmodel = context.read<StudentWorksheetViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewmodel.getCurrentUserSubmission(widget.worksheetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StudentWorksheetViewModel>(context);

    return Consumer<StudentWorksheetViewModel>(
      builder: (context, viewmodel, _) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Palette.primaryText),
          title: const Text(
            'Worksheet view',
            style: TextStyle(color: Palette.primaryText),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(Constants.padding12),
          child: Center(
              child: viewmodel.isLoading
                  ? const CircularProgressIndicator()
                  : SingleChildScrollView(
                      // scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Text("Your submission", style: TextStyles.bodyLarge),
                          Container(
                            decoration: const BoxDecoration(),
                            child: InteractiveViewer(
                              child: CachedNetworkImage(
                                imageUrl:
                                    viewmodel.uploadedWorksheet?.imagePath ??
                                        '',
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Constants.padding12,
                          ),
                          Text("Answer key", style: TextStyles.bodyLarge),
                          Container(
                            child: InteractiveViewer(
                              child: CachedNetworkImage(
                                imageUrl:
                                    viewmodel.worksheetAnswer?.imageUrl ?? '',
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
        ),
      ),
    );
  }
}
