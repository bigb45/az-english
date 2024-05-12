import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:ez_english/theme/palette.dart';

class LevelSelection extends StatefulWidget {
  const LevelSelection({Key? key}) : super(key: key);

  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Assigned Levels',
          style: TextStyle(color: Palette.blackColor),
        ),
      ),
      // TODO: place this inside a SingleChildScrollView
      body: SizedBox(
        child: Column(
          children: [
            // First row
            Constants.gapH36,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  _buildCard(
                      headerText: 'A1',
                      cardText:
                          "learn common everyday expressions and simple phrases"),
                  Constants.gapW10,
                  _buildCard(
                      headerText: 'A1',
                      cardText:
                          "learn common everyday expressions and simple phrases"),
                ],
              ),
            ),
            // Second row
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  _buildCard(
                      headerText: 'A1',
                      cardText:
                          "learn common everyday expressions and simple phrases"),
                  Constants.gapW10,
                  _buildCard(
                      headerText: 'A1',
                      cardText:
                          "learn common everyday expressions and simple phrases"),
                ],
              ),
            ),
            // Third row
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(
                    headerText: 'A1',
                    cardText:
                        "learn common everyday expressions and simple phrases",
                  ),
                ],
              ),
            ),
            Constants.gapH36,
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.change_circle),
            label: 'Result',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Palette.primary,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCard({required String headerText, required String cardText}) {
    return SelectableCard(
      onPressed: () {},
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
