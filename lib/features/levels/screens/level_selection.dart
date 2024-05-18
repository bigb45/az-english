import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/levels/screens/level_selection_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LevelSelection extends StatefulWidget {
  const LevelSelection({Key? key}) : super(key: key);

  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection> {
  @override
  void initState() {
    super.initState();
    changeColor();
  }

  void changeColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(Palette.secondary);
  }

  void navigateToLevel({required String levelId}) {
    context.push('/level/$levelId');
  }

  @override
  Widget build(BuildContext context) {
    final levelSelectionVm = Provider.of<LevelSelectionViewmodel>(context);
    changeColor();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text(
          'Assigned Levels',
          style: TextStyle(color: Palette.primaryText),
        ),
      ),
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 10,
              spacing: 10,
              children: [
                ...levelSelectionVm.assignedLevels.map(
                  (level) {
                    return _buildCard(
                      headerText: level.name,
                      isAssigned: true,
                      cardText: level.description,
                      onTap: () {
                        // TODO: replace "1" with level.id
                        navigateToLevel(levelId: "1");
                      },
                    );
                  },
                )
              ],
            ),
          ),
          // child: Column(
          //   children: [
          //     // First row
          //     Constants.gapH36,
          //     Padding(
          //       padding: const EdgeInsets.all(10.0),
          //       child: Row(
          //         children: [
          //           _buildCard(
          //               headerText: 'A1',
          //               isAssigned: true,
          //               cardText:
          //                   "learn common everyday expressions and simple phrases",
          //               onTap: (levelId) {
          //                 navigateToLevel(levelId: "1");
          //               }),
          //           Constants.gapW10,
          //           _buildCard(
          //             isAssigned: true,
          //             headerText: 'A2',
          //             cardText:
          //                 "learn common everyday expressions and simple phrases",
          //             onTap: (levelId) {
          //               levelSelectionVm.setSelectedLevel(levelId);
          //               navigateToLevel(levelId: levelId.toString());
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //     // Second row
          //     Padding(
          //       padding: const EdgeInsets.all(10.0),
          //       child: Row(
          //         children: [
          //           _buildCard(
          //             headerText: 'B1',
          //             cardText:
          //                 "learn common everyday expressions and simple phrases",
          //             onTap: (levelId) {
          //               navigateToLevel(levelId: "1");
          //             },
          //           ),
          //           Constants.gapW10,
          //           _buildCard(
          //             headerText: 'B2',
          //             cardText:
          //                 "learn common everyday expressions and simple phrases",
          //             onTap: (levelId) {
          //               navigateToLevel(levelId: "1");
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //     // Third row
          //     Padding(
          //       padding: const EdgeInsets.all(10.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           _buildCard(
          //             headerText: 'C2',
          //             cardText:
          //                 "learn common everyday expressions and simple phrases",
          //             onTap: (levelId) {
          //               navigateToLevel(levelId: "1");
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //     Constants.gapH36,
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String headerText,
      required String cardText,
      required Function() onTap,
      bool isAssigned = false}) {
    return SelectableCard(
      selected: isAssigned,
      onPressed: isAssigned
          ? () {
              onTap();
            }
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            headerText,
            style: TextStyles.cardHeader,
            textAlign: TextAlign.center,
          ),
          Constants.gapH20,
          Text(
            cardText,
            style: TextStyles.cardText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
