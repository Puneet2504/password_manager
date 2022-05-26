import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/pages/add_page.dart';
import 'package:password_manager/pages/home_page.dart';
import 'package:password_manager/pages/profile_page.dart';

class BottomNavigateBar extends StatefulWidget {
  const BottomNavigateBar({Key? key}) : super(key: key);

  @override
  State<BottomNavigateBar> createState() => _BottomNavigateBarState();
}

class _BottomNavigateBarState extends State<BottomNavigateBar> {
  int currentIndex = 0;
  final screens = [HomePage(), AddPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            backgroundColor: Colors.transparent,
            color: Colors.purple.shade700,
            buttonBackgroundColor: Colors.purple.shade700,
            index: currentIndex,
            onTap: (index) => setState(() {
                  currentIndex = index;
                }),
            items: const [
              Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.add_circle_rounded,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ]));
  }
}
