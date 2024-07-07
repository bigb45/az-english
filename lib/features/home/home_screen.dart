import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/account.dart';
import 'package:ez_english/features/home/admin_screen.dart';
import 'package:ez_english/features/home/test_results.dart';
import 'package:ez_english/features/levels/data/upload_data_viewmodel.dart';
import 'package:ez_english/features/levels/screens/level_selection.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  static bool isUserAdmin = false;

  final List<Widget> _pages = [
    const LevelSelection(),
    const TestResults(),
    const AdminScreen(),
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
            isUserAdmin
                ? _buildNavItem(Icons.shield_outlined, 'Admin', 2)
                : _buildNavItem(
                    Icons.assignment_turned_in_outlined, 'Results', 1),
            _buildNavItem(Icons.account_circle, 'Account', 3),
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
