import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/levels/screens/level_selection_viewmodel.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    hintTexts = [
      AppStrings.readingSectionCardTitle,
      AppStrings.writingSectionCardTitle,
      AppStrings.listeningSectionCardTitle,
      AppStrings.vocabSectionCardTitle,
      AppStrings.grammarSectionCardTitle,
      AppStrings.skillTestSectionCardTitle
    ];
    imageAssets = [
      "assets/images/reading_section_card.svg",
      "assets/images/writing_section_card.svg",
      "assets/images/listening_section_card.svg",
      "assets/images/vocabulary_section_card.svg",
      "assets/images/grammar_section_card.svg",
      null
    ];
    backgroundColors = [
      const Color(0xFFFFA500),
      const Color(0xFFae9d7e),
      const Color(0xFF3498DB),
      const Color(0xFF8F8F8F),
      const Color(0xFF663399),
      const Color(0xFF34495E)
    ];

    super.initState();
  }

  void navigateToSection({required String sectionId}) {
    context.push('/landing_page/${widget.levelId}/$sectionId');
  }

  @override
  Widget build(BuildContext context) {
    LevelSelectionViewmodel viewmodel =
        Provider.of<LevelSelectionViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            AppStrings.practiceScreenTitle,
            style: TextStyles.titleTextStyle,
          ),
          subtitle: Text(
            widget.levelName,
            style: TextStyles.subtitleTextStyle,
          ),
        ),
      ),
      body: viewmodel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(Constants.padding20),
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

                                String hintText = entry.value;
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
    );
  }

  Widget _buildCard({
    required String headerText,
    required String cardText,
    required Color backgroundColor,
    required Section section,
    required VoidCallback? onTap,
    String? imagePath,
    Color? cardShadowColor,
  }) {
    return ExerciseCard(
      onPressed: onTap != null
          ? () {
              onTap();
            }
          : null,
      cardBackgroundColor: backgroundColor,
      image: imagePath,
      cardShadowColor: cardShadowColor,
      text: headerText,
      section: section,
    );
  }
}
