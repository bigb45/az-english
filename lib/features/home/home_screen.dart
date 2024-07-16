// ignore_for_file: avoid_print

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/home/account.dart';
import 'package:ez_english/features/home/admin/admin_screen.dart';
import 'package:ez_english/features/home/test/test_results.dart';
import 'package:ez_english/features/levels/screens/level_selection.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestoreService = FirestoreService();
  late String currentUserId;

  static bool isUserAdmin = true;
  List<Widget>? _pages;

  final Map<String, IconData> _labelIcons = {
    "Home": Icons.home,
  };

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid;
    // TODO: fix 'Index out of range' error
    getIsUserAdmin().then((_) {
      if (isUserAdmin) {
        _labelIcons["Admin"] = Icons.shield_outlined;
      } else {
        _labelIcons["Results"] = Icons.assignment_turned_in_outlined;
      }
      _labelIcons["Account"] = Icons.person;
      _pages = [
        const LevelSelection(),
        (isUserAdmin ? const AdminScreen() : const TestResults()),
        Account(),
      ];
      setState(() {});
    });
  }

  Future<void> getIsUserAdmin() async {
    var value = await _firestoreService.getUser(currentUserId);
    if (value != null) {
      // TODO: uncomment the code below to change to get user type from database
      // isUserAdmin = value.userType == UserType.admin ||
      //     value.userType == UserType.developer;
    }
  }

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
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        controller: _pageController,
        children: _pages!,
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _pages!.length,
            (index) => _buildNavItem(
              _labelIcons.values.elementAt(index),
              _labelIcons.keys.elementAt(index),
              index,
            ),
          ),
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
