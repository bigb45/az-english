import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/levels/data/upload_data_viewmodel.dart';
import 'package:ez_english/features/levels/screens/level_selection_viewmodel.dart';
import 'package:ez_english/features/sections/grammar/grammar_section_viewmodel.dart';
import 'package:ez_english/features/sections/reading/view_model/reading_section_viewmodel.dart';
import 'package:ez_english/features/sections/vocabulary/viewmodel/vocabulary_section_viewmodel.dart';
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
        ChangeNotifierProvider(create: (_) => ReadingQuestionViewmodel()),
        ChangeNotifierProvider(create: (_) => WritingSectionViewmodel()),
        ChangeNotifierProvider(create: (_) => VocabularySectionViewmodel()),
        ChangeNotifierProvider(create: (_) => UploadDataViewmodel()),
        ChangeNotifierProvider(create: (_) => GrammarSectionViewmodel()),
      ],
      child: child,
    );
  }
}
