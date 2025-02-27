import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/view/faculty/CoursePage.dart';
import 'package:track_tracing/view/faculty/addCoursePage.dart';
import 'package:track_tracing/view/faculty/manageCourses.dart';

class FacultyHomePage extends StatefulWidget {
  final int initialIndex; 

  const FacultyHomePage({super.key, this.initialIndex = 0}); 

  @override
  State<FacultyHomePage> createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  late int _selectedIndex; 

  // List of pages
  final List<Widget> _pages = [
    const FacultyCoursePage(),
    const AddCoursePage(),
    const ManageCourses(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; 
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show the currently selected page
      body: _pages[_selectedIndex],

      // BottomNavigationBar for page navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Course",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: "Manage",
          ),
        ],
        selectedItemColor: const Color.fromRGBO(255, 255, 255, 1),
        unselectedItemColor: const Color.fromRGBO(32, 34, 68, 1),
        backgroundColor: Colors.blueAccent,
        iconSize: 30,
        selectedLabelStyle: GoogleFonts.mulish(
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: GoogleFonts.mulish(
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
