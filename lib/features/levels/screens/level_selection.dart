import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/levels/screens/level_selection_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LevelSelection extends StatefulWidget {
  const LevelSelection({Key? key}) : super(key: key);

  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection> {
  // late LevelSelectionViewmodel levelSelectionVm;

  @override
  void initState() {
    super.initState();
    // levelSelectionVm =
    //     Provider.of<LevelSelectionViewmodel>(context, listen: false);
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
    LevelSelectionViewmodel levelSelectionVm =
        Provider.of<LevelSelectionViewmodel>(context);

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
      body: levelSelectionVm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : levelSelectionVm.error != null
              ? ErrorWidget(
                  error: levelSelectionVm.error ??
                      CustomException(
                        "",
                      ))
              : SingleChildScrollView(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            ...levelSelectionVm.levels.map(
                              (level) {
                                return _buildCard(
                                  headerText: level.name,
                                  isAssigned: level.isAssigned,
                                  cardText: level.description,
                                  onTap: () {
                                    navigateToLevel(levelId: "${level.id}");
                                  },
                                );
                              },
                            ),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     levelSelectionVm.fetchLevels();
                            //   },
                            //   child: Text(
                            //     "Refresh",
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
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

class ErrorWidget extends StatelessWidget {
  final CustomException error;
  const ErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 100.h,
          ),
          Text(error.message),
          SizedBox(
            height: 30.h,
          ),
          Button(
              onPressed: () {
                context.read<LevelSelectionViewmodel>().fetchLevels();
              },
              text: 'Retry')
        ],
      ),
    );
  }
}
