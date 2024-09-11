import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/features/levels/screens/levels/level_selection_viewmodel.dart';
import 'package:ez_english/features/levels/screens/worksheet_view/worksheet_view_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentWorksheetView extends StatelessWidget {
  const StudentWorksheetView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LevelSelectionViewmodel>(context);
    final worksheetPath = viewModel.lastWorksheetPath;

    return Consumer<WorksheetViewViewmodel>(
      builder: (context, viewmodel, _) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Palette.primaryText),
          title: const Text(
            'Worksheet view',
            style: TextStyle(color: Palette.primaryText),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
            child: viewmodel.isLoading
                ? const CircularProgressIndicator()
                : InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl: worksheetPath!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                    ),
                  )),
      ),
    );
  }
}
