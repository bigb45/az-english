import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/admin/worksheets/worksheets_viewmodel.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/drawer_button.dart';
import 'package:ez_english/widgets/vertical_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AllWorksheets extends StatefulWidget {
  const AllWorksheets({super.key});

  @override
  State<AllWorksheets> createState() => _AllWorksheetsState();
}

class _AllWorksheetsState extends State<AllWorksheets> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int tempUnitNumber = 0;
  int selectedLevelNumber = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminWorksheetsViewmodel>(context, listen: false)
          .getWorksheets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminWorksheetsViewmodel>(
      builder: (context, viewmodel, _) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.all(Constants.padding20),
              child: DrawerActionButton(
                  invertColors: true,
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  }),
            )
          ],
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
                          Worksheet currentWorksheet =
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
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 158.h,
                child: const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Palette.primaryButtonStroke,
                  ),
                  child: Center(
                    child: Text(
                      'Choose a Unit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              ...List.generate(viewmodel.levels.length, (levelIndex) {
                return Container(
                    padding: EdgeInsets.all(Constants.padding8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Level ${levelIndex + 1}",
                          style: TextStyles.bodyLarge,
                        ),
                        ...List.generate(
                            /*originalCurrentUnitNumber*/
                            viewmodel.levels["level$levelIndex"]?.length ?? 3,
                            (unitIndex) {
                          int unitNumber = unitIndex + 1;
                          return ListTile(
                            leading: const Icon(Icons.book),
                            title: Text('Unit $unitNumber'),
                            selected: unitNumber == tempUnitNumber &&
                                levelIndex ==
                                    selectedLevelNumber /* tempCurrentUnitNumber */,
                            onTap: () async {
                              // Navigator.of(context).pop();
                              setState(() {
                                /* tempCurrentUnitNumber = unitNumber; */
                                tempUnitNumber = unitNumber;
                                selectedLevelNumber = levelIndex;
                              });
                              // if (unitNumber != 3) {
                              viewmodel.selectWorksheet(
                                  selectedLevelNumber, unitNumber - 1);
                              //   await viewmodel.fetchSections(
                              //       viewmodel.levels[int.tryParse(widget.levelId)!],
                              //       desiredDay: unitNumber);
                              // } else {
                              //   await viewmodel.fetchSections(
                              //     viewmodel.levels[int.tryParse(widget.levelId)!],
                              //   );
                              // }
                            },
                          );
                        }),
                      ],
                    ));
              })
            ],
          ),
        ),
      ),
    );
  }
}
