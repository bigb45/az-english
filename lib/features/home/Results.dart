import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/levels/data/upload_data_viewmodel.dart';
import 'package:ez_english/features/models/exam_result.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late UploadDataViewmodel _dataViewmodel;
  List<ExamResult> results = [
    ExamResult(
      examId: "1",
      examName: "",
      examDate: "14/2/2024",
      examScore: "80%",
      examStatus: ExamStatus.passed,
    ),
    ExamResult(
      examId: "2",
      examName: "",
      examDate: "17/2/2024",
      examScore: "90%",
      examStatus: ExamStatus.passed,
    ),
    ExamResult(
      examId: "3",
      examName: "",
      examDate: "23/2/2024",
      examScore: "50%",
      examStatus: ExamStatus.failed,
    ),
  ];
  @override
  void initState() {
    _dataViewmodel = Provider.of<UploadDataViewmodel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.resultsScreeenTitle,
          style: TextStyle(color: Palette.primaryText),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding12),
        child: Column(
          children: [
            results.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        AppStrings.resultScreenText,
                        style: TextStyles.bodyLarge,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return ExamResultCard(
                          onTap: () {
                            context.push(
                              "/result_overview/:${results[index].examId}",
                            );
                          },
                          result: results[index],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      // Column(
      //   children: [
      //     ElevatedButton(
      //       onPressed: () async {
      //         List<Level> levels = await _dataViewmodel.parseData();
      //         for (Level level in levels) {
      //           await _dataViewmodel.saveLevelToFirestore(level);
      //         }
      //       },
      //       child: const Text("Add data"),
      //     ),
      //     ElevatedButton(
      //       onPressed: () async {
      //         context.push("/settings");
      //       },
      //       child: const Text("Test screen"),
      //     ),
      //     Center(
      //       child: Text(
      //         AppStrings.resultScreenText,
      //         style: TextStyles.bodyLarge,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class ExamResultCard extends StatelessWidget {
  final ExamResult result;
  final VoidCallback onTap;
  const ExamResultCard({super.key, required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constants.padding8),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Palette.secondaryStroke),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constants.padding20, vertical: Constants.padding20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: ScreenUtil().screenWidth * 0.5),
                          child: Text(
                            result.examDate,
                            style: TextStyles.practiceCardSecondaryText,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Icon(
                          Icons.circle,
                          color: Palette.primaryText,
                          size: 5,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          result.examScore,
                          style: TextStyles.wordType,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Icon(
                          Icons.circle,
                          color: Palette.primaryText,
                          size: 5,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        result.examStatus == ExamStatus.passed
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                        SizedBox(
                          width: 10.w,
                        ),
                        result.examStatus == ExamStatus.passed
                            ? Text(
                                "Passed",
                                style: TextStyles.wordType.copyWith(
                                  color: Palette.primary,
                                  fontSize: 16,
                                ),
                              )
                            : Text(
                                "Failed",
                                style: TextStyles.wordType.copyWith(
                                  color: Palette.error,
                                  fontSize: 16,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                // result.examStatus == ExamStatus.passed
                //     ? const Icon(
                //         Icons.check_circle,
                //         color: Colors.green,
                //       )
                //     : const Icon(
                //         Icons.cancel,
                //         color: Colors.red,
                //       ),
                const Icon(Icons.arrow_forward)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
