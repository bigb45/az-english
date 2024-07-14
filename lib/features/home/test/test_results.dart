import 'package:ez_english/features/home/viewmodel/test_viewmodel.dart';
import 'package:ez_english/features/levels/data/upload_data_viewmodel.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/test_result_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TestResults extends StatefulWidget {
  const TestResults({super.key});

  @override
  State<TestResults> createState() => _TestResultsState();
}

class _TestResultsState extends State<TestResults> {
  late TestViewmodel viewmodel;

  @override
  void initState() {
    super.initState();
    viewmodel = Provider.of<TestViewmodel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewmodel.myInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestViewmodel>(
      builder: (context, viewmodel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Test Results',
              style: TextStyle(color: Palette.primaryText),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: viewmodel.isInitialized && viewmodel.isLoading == false
              ? Padding(
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
                                  return TestResultCard(
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
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
