import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/levels/screens/levels/level_selection_viewmodel.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/drawer_button.dart';
import 'package:ez_english/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PracticeSections extends StatefulWidget {
  final String levelId;
  final String levelName;
  const PracticeSections({
    Key? key,
    required this.levelId,
    required this.levelName,
  }) : super(key: key);

  @override
  State<PracticeSections> createState() => _PracticeSectionsState();
}

class _PracticeSectionsState extends State<PracticeSections> {
  late List<String> hintTexts = [];
  late List<String?> imageAssets = [];
  late List<Color> backgroundColors = [];
  late List<String> sectionNames = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late LevelSelectionViewmodel viewmodel;
  int originalCurrentUnitNumber = 1;
  int tempCurrentUnitNumber = 1;

  bool _isLoading = true;
  @override
  void initState() {
    hintTexts = [
      AppStrings.readingSectionCardTitle,
      AppStrings.writingSectionCardTitle,
      AppStrings.listeningSectionCardTitle,
      AppStrings.vocabSectionCardTitle,
      AppStrings.grammarSectionCardTitle,
      AppStrings.skillTestSectionCardTitle,
      AppStrings.worksheetSectionCardTitle,
    ];
    imageAssets = [
      "assets/images/reading_section_card.svg",
      "assets/images/writing_section_card.svg",
      "assets/images/listening_section_card.svg",
      "assets/images/vocabulary_section_card.svg",
      "assets/images/grammar_section_card.svg",
      null,
      "assets/images/worksheet.svg"
    ];
    backgroundColors = [
      const Color(0xFFFFA500),
      const Color(0xFFae9d7e),
      const Color(0xFF3498DB),
      const Color(0xFF8F8F8F),
      const Color(0xFF663399),
      const Color(0xFF34495E),
      const Color(0xFF2ECC71),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchSections();
    });

    super.initState();
  }

  Future<void> _fetchSections() async {
    viewmodel = Provider.of<LevelSelectionViewmodel>(context, listen: false);
    await viewmodel
        .fetchSections(viewmodel.levels[int.tryParse(widget.levelId)!]);
    viewmodel.tempUnit = false;
    originalCurrentUnitNumber = viewmodel.userCurrentDay;
    tempCurrentUnitNumber = originalCurrentUnitNumber;
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSection({required String sectionId}) {
    context.push('/landing_page/${widget.levelId}/$sectionId');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LevelSelectionViewmodel>(builder: (context, viewmodel, _) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.all(Constants.padding20),
              child: DrawerActionButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            )
          ],
          title: ListTile(
            contentPadding: const EdgeInsets.only(left: 0, right: 0),
            title: Text(
              AppStrings.practiceScreenTitle,
              style: TextStyles.titleTextStyle,
            ),
            subtitle: Text(
              "Speaking Practice",
              style: TextStyles.subtitleTextStyle,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                child: SingleChildScrollView(
                  child: SizedBox(
                    child: Padding(
                      padding: EdgeInsets.all(Constants.padding8),
                      child: Center(
                        child: Column(
                          children: [
                            Constants.gapH20,
                            Wrap(
                              alignment: WrapAlignment.center,
                              runSpacing: 15.h,
                              spacing: 10.w,
                              children: [
                                ...hintTexts.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Section section = viewmodel
                                      .levels[int.tryParse(widget.levelId)!]
                                      .sections![index];
                                  printDebug(
                                      "${section.name} ${section.isAssigned}, ${section.numberOfQuestions}");
                                  String hintText = entry.value;
                                  bool showCardInfo = section.name !=
                                      RouteConstants.worksheetSectionName;
                                  return _buildCard(
                                    headerText: hintText,
                                    cardText:
                                        "Learn common everyday expressions and simple phrases",
                                    onTap: !section.isAssigned
                                        ? null
                                        : () {
                                            navigateToSection(
                                              sectionId:
                                                  RouteConstants.getSectionIds(
                                                      section.name),
                                            );
                                            viewmodel.updateSectionStatus(
                                                section, widget.levelName);
                                          },
                                    shouldShowCardInformation: showCardInfo,
                                    imagePath: imageAssets[index],
                                    backgroundColor: backgroundColors[index],
                                    section: section,
                                  );
                                }).toList(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
              ...List.generate(originalCurrentUnitNumber, (index) {
                int unitNumber = index + 1;
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text('Unit $unitNumber'),
                  selected: unitNumber == tempCurrentUnitNumber,
                  onTap: () async {
                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading = true;
                      tempCurrentUnitNumber = unitNumber;
                    });
                    if (unitNumber != originalCurrentUnitNumber) {
                      viewmodel.tempUnit = true;
                      await viewmodel.fetchSections(
                          viewmodel.levels[int.tryParse(widget.levelId)!],
                          desiredDay: unitNumber);
                    } else {
                      await viewmodel.fetchSections(
                        viewmodel.levels[int.tryParse(widget.levelId)!],
                      );
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCircularSvgIcon(String assetPath) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black.withOpacity(0.2), width: 2),
          borderRadius: BorderRadius.circular(12)),
      child: ClipOval(
        child: SvgPicture.asset(
          assetPath,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  Widget _buildCard({
    required String headerText,
    required String cardText,
    required Color backgroundColor,
    required Section section,
    required VoidCallback? onTap,
    bool shouldShowCardInformation = true,
    String? imagePath,
    Color? cardShadowColor,
  }) {
    return ExerciseCard(
      onPressed: onTap != null
          ? () {
              onTap();
            }
          : null,
      showCardInfo: shouldShowCardInformation,
      cardBackgroundColor: backgroundColor,
      image: imagePath,
      cardShadowColor: cardShadowColor,
      text: headerText,
      section: section,
    );
  }
}
