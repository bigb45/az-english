import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/account.dart';
import 'package:ez_english/features/home/test_results.dart';
import 'package:ez_english/features/levels/screens/level_selection.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  void _onItemTapped(int index) {
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
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.change_circle, 'Results', 1),
            _buildNavItem(Icons.account_circle, 'Account', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData iconData, String label, int index) {
    bool isSelected = _pageIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: ShapeDecoration(
              color: isSelected
                  ? Palette.secondaryVariantStroke
                  : Colors.transparent,
              shape: const StadiumBorder(),
            ),
            child: Icon(
              iconData,
              size: Constants.iconSizeWidth20,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
