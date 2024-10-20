import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/home/admin/question_assignment/question_assignment_viewmodel.dart';
import 'package:ez_english/features/home/admin/users/users_settings_viewmodel.dart';
import 'package:ez_english/features/home/admin/worksheets/worksheets_viewmodel.dart';
import 'package:ez_english/features/home/content/viewmodels/whiteboard_viewmodel.dart';
import 'package:ez_english/features/home/test/viewmodel/test_viewmodel.dart';
import 'package:ez_english/features/levels/data/upload_data_viewmodel.dart';
import 'package:ez_english/features/levels/screens/levels/level_selection_viewmodel.dart';
import 'package:ez_english/features/levels/screens/school/school_section_viewmodel.dart';
import 'package:ez_english/features/sections/components/view_model/dictation_question_view.model.dart';
import 'package:ez_english/features/sections/exam/viewmodel/test_section_viewmodel.dart';
import 'package:ez_english/features/sections/grammar/grammar_section_viewmodel.dart';
import 'package:ez_english/features/sections/listening/viewmodel/listening_section_viewmodel.dart';
import 'package:ez_english/features/sections/reading/view_model/reading_section_viewmodel.dart';
import 'package:ez_english/features/sections/vocabulary/viewmodel/vocabulary_section_viewmodel.dart';
import 'package:ez_english/features/sections/worksheet/student_worksheet_viewmodel.dart';
import 'package:ez_english/features/sections/writing/viewmodel/writing_section_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProxyProvider<AuthViewModel, LevelSelectionViewmodel>(
          update: (context, auth, levels) => levels!..update(auth),
          create: (BuildContext context) => LevelSelectionViewmodel(),
        ),
        ChangeNotifierProvider(create: (_) => ReadingSectionViewmodel()),
        ChangeNotifierProvider(create: (_) => WritingSectionViewmodel()),
        ChangeNotifierProvider(create: (_) => ListeningSectionViewmodel()),
        ChangeNotifierProvider(create: (_) => VocabularySectionViewmodel()),
        ChangeNotifierProvider(create: (_) => UploadDataViewmodel()),
        ChangeNotifierProvider(create: (_) => GrammarSectionViewmodel()),
        ChangeNotifierProvider(create: (_) => TestSectionViewmodel()),
        ChangeNotifierProvider(create: (_) => DictationQuestionViewModel()),
        ChangeNotifierProvider(create: (_) => TestViewmodel()),
        ChangeNotifierProvider(create: (_) => UsersSettingsViewmodel()),
        ChangeNotifierProvider(create: (_) => SchoolSectionViewmodel()),
        ChangeNotifierProvider(create: (_) => QuestionAssignmentViewmodel()),
        ChangeNotifierProvider(create: (_) => AdminWorksheetsViewmodel()),
        ChangeNotifierProvider(create: (_) => StudentWorksheetViewModel()),
        ChangeNotifierProvider(create: (_) => WhiteboardViewmodel()),
      ],
      child: child,
    );
  }
}
