import 'package:ez_english/features/home/viewmodel/home_viewmodel.dart';
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
  late HomeViewmodel homeViewmodel;

  @override
  void initState() {
    super.initState();
    homeViewmodel = Provider.of<HomeViewmodel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      homeViewmodel.myInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewmodel>(
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
                      ElevatedButton(
                        onPressed: () async {
                          // Assuming parseData() and saveLevelToFirestore() are methods defined elsewhere
                          // in your UploadDataViewmodel
                          List<Level> levels =
                              await Provider.of<UploadDataViewmodel>(context,
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
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
