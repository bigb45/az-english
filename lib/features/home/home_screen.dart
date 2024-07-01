import 'package:ez_english/features/home/account.dart';
import 'package:ez_english/features/home/test_results.dart';
import 'package:ez_english/features/levels/screens/level_selection.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;

  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const LevelSelection(),
    const TestResults(),
    Account(),
  ];
  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
      _pageController.jumpToPage(_pageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.change_circle),
            label: 'Result',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],

        selectedIndex: _pageIndex,
        indicatorColor: Palette.secondaryVariantStroke,
        // selectedItemColor: Palette.primary,
        onDestinationSelected: _onPageChanged,
      ),
    );
  }
}
