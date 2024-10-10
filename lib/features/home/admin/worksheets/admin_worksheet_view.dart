import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/admin/worksheets/worksheets_viewmodel.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/expandable_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AdminWorksheetView extends StatelessWidget {
  final String worksheetId;
  const AdminWorksheetView({super.key, required this.worksheetId});

  @override
  Widget build(BuildContext context) {
    final int worksheetIndex = int.tryParse(worksheetId) ?? 0;
    return Consumer<AdminWorksheetsViewmodel>(builder: (context, viewmodel, _) {
      List<Worksheet> worksheets = viewmodel.worksheets.cast<Worksheet>();

      final submissionsList = worksheets[worksheetIndex].students ?? {};
      // print("submissionsList: ${submissionsList[0].studentName}");
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Palette.primaryText),
          title: Text(
            "Worksheet view",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Palette.primaryText),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(Constants.padding12),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      builder: (context) {
                        return Center(
                          child: InteractiveViewer(
                            child: CachedNetworkImage(
                              progressIndicatorBuilder:
                                  (context, url, progress) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                );
                              },
                              imageUrl: viewmodel
                                      .worksheets[worksheetIndex]?.imageUrl ??
                                  "",
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Palette.secondary,
                    border:
                        Border.all(color: Palette.secondaryStroke, width: 2),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Palette.secondaryStroke,
                        offset: Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  width: 60.w,
                  height: 60.h,
                  child: const Center(
                    child: Icon(
                      Icons.task,
                      color: Palette.secondaryText,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                    return ExpandableListTile(
                      title:
                          submissionsList.values.elementAt(index).studentName!,
                      subtitle: submissionsList.values
                          .elementAt(index)
                          .dateSolved
                          .toString()
                          .split(" ")[0],
                      imageUrl:
                          submissionsList.values.elementAt(index).imagePath!,
                    );
                  },
                ),
        ),
      );
    });
  }
}
