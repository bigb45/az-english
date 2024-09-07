import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/admin/worksheets/worksheets_viewmodel.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/vertical_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AllWorksheets extends StatefulWidget {
  const AllWorksheets({super.key});

  @override
  State<AllWorksheets> createState() => _AllWorksheetsState();
}

class _AllWorksheetsState extends State<AllWorksheets> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorksheetsViewmodel>(context, listen: false).getWorksheets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorksheetsViewmodel>(
      builder: (context, viewmodel, _) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Palette.primaryText),
          title: const Text(
            'All worksheets',
            style: TextStyle(color: Palette.primaryText),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.padding12, vertical: Constants.padding8),
          child: Center(
            child: viewmodel.isLoading
                ? const CircularProgressIndicator()
                : viewmodel.worksheets.isEmpty
                    ? Text(
                        "No worksheets uploaded yet",
                        style: TextStyles.bodyLarge,
                      )
                    : ListView.builder(
                        itemCount: viewmodel.worksheets.length,
                        itemBuilder: (context, index) {
                          WorkSheet currentWorksheet =
                              viewmodel.worksheets[index];
                          int submissionCount =
                              currentWorksheet.students?.length ?? 0;
                          return VerticalListItemCard(
                            mainText: "${currentWorksheet.title}",
                            showDeleteIcon: false,
                            action: Icons.arrow_forward_ios,
                            info: Text(currentWorksheet.timestamp!
                                .toDate()
                                .toString()
                                .split(" ")[0]),
                            subText:
                                "$submissionCount submission${submissionCount == 1 ? "" : "s"}",
                            onTap: () {
                              context.push(
                                '/worksheet/$index',
                              );
                            },
                          );
                        }),
          ),
        ),
      ),
    );
  }
}
