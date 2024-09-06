import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/features/home/admin/worksheets/worksheets_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminWorksheetView extends StatelessWidget {
  final String worksheetId;
  AdminWorksheetView({super.key, required this.worksheetId});

  @override
  Widget build(BuildContext context) {
    final int worksheetIndex = int.tryParse(worksheetId) ?? 0;
    return Consumer<WorksheetsViewmodel>(builder: (context, viewmodel, _) {
      final submissionsList = viewmodel.worksheets[worksheetIndex].students;
      // print("submissionsList: ${submissionsList[0].studentName}");
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Palette.primaryText),
          title: const Text(
            'Administrator',
            style: TextStyle(color: Palette.primaryText),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: (submissionsList == null || submissionsList.isEmpty)
              ? Text(
                  "No submissions yet",
                  style: TextStyles.bodyLarge,
                )
              : ListView.builder(
                  itemCount: submissionsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          submissionsList.values.elementAt(index).studentName!),
                      subtitle: Column(
                        // TODO: make expandable
                        children: [
                          Text(
                            submissionsList.values
                                .elementAt(index)
                                .dateSolved
                                .toString(),
                          ),
                          InteractiveViewer(
                            child: CachedNetworkImage(
                              imageUrl: submissionsList.values
                                  .elementAt(index)
                                  .imagePath!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      );
    });
  }
}
