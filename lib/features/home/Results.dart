import 'package:ez_english/features/home/viewmodel/home_viewmodel.dart';
import 'package:ez_english/features/levels/data/upload_data_viewmodel.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/exam_result_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Results extends StatelessWidget {
  const Results({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewmodel>(
      builder: (context, viewmodel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Exam Results',
              style: TextStyle(color: Palette.primaryText),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                viewmodel.examResults.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No exam results available.',
                            style: TextStyles.bodyLarge,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: viewmodel.examResults.length,
                          itemBuilder: (context, index) {
                            return ExamResultCard(
                              onTap: () {
                                context.push(
                                  "/result_overview/:${viewmodel.examResults[index].examId}",
                                );
                              },
                              result: viewmodel.examResults[index],
                            );
                          },
                        ),
                      ),
                ElevatedButton(
                  onPressed: () async {
                    // Assuming parseData() and saveLevelToFirestore() are methods defined elsewhere
                    // in your UploadDataViewmodel
                    List<Level> levels = await Provider.of<UploadDataViewmodel>(
                            context,
                            listen: false)
                        .parseData();
                    for (Level level in levels) {
                      await Provider.of<UploadDataViewmodel>(context,
                              listen: false)
                          .saveLevelToFirestore(level);
                    }
                  },
                  child: const Text("Add data"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
