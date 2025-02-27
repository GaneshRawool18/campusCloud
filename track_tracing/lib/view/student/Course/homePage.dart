import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/authservice.dart';
import 'package:track_tracing/controller/student/sqfliteController.dart';
import 'package:track_tracing/view/student/Course/coursePage.dart';
import 'package:track_tracing/view/student/Home/opportunities.dart';
import 'package:track_tracing/view/student/Home/profilePage.dart';
import 'package:track_tracing/view/student/Home/skillPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _setSqflite();
  }

  void _setSqflite() async {
   await SqfliteController().fetchStudentData(Authservice.studentID!);
    // await SqfliteController().initDatabase();
    // await SqfliteController().insertData();
    // SqfliteController().readData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Coursepage(),
    const SkillPage(),
    const Opportunities(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Skills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch_rounded),
            label: 'Opportunities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(22, 127, 113, 1),
        unselectedItemColor: const Color.fromRGBO(32, 34, 68, 1),
        iconSize: 30,
        unselectedLabelStyle:
            GoogleFonts.mulish(fontSize: 12, fontWeight: FontWeight.w800),
        selectedLabelStyle:
            GoogleFonts.mulish(fontSize: 14, fontWeight: FontWeight.w800),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
