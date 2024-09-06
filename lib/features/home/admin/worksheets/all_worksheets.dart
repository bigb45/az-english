import 'dart:math';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/vertical_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AllWorksheets extends StatelessWidget {
  const AllWorksheets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => VerticalListItemCard(
              mainText: "Worksheet $index",
              showDeleteIcon: false,
              action: Icons.arrow_forward_ios,
              info: Text("${DateTime.now()}"),
              subText:
                  "${Random().nextInt(10)} submission${Random().nextBool() ? "s" : ""}",
              onTap: () {
                context.push(
                  '/worksheet/$index',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
