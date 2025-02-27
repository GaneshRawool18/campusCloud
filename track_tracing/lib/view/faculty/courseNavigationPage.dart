import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/view/faculty/courseContentPage.dart';
import 'package:track_tracing/view/faculty/courseOtherPage.dart';
import 'package:track_tracing/view/faculty/facultyRatingPage.dart';
import 'package:track_tracing/view/faculty/summaryPage.dart';

String? facultySelectedDept;
String? facultySelectedCourse;
String? facultySelectedSem;

class CourseNavigationPage extends StatefulWidget {
  final String? selectdcourseName;
  final String? selectedDept;
  final String? selectdSem;
  const CourseNavigationPage(
      {super.key,
      required this.selectdSem,
      required this.selectedDept,
      required this.selectdcourseName});

  @override
  State<CourseNavigationPage> createState() => _CourseNavigationPageState();
}

class _CourseNavigationPageState extends State<CourseNavigationPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    facultySelectedDept = widget.selectedDept;
    facultySelectedCourse = widget.selectdcourseName;
    facultySelectedSem = widget.selectdSem;
    log("Selected Dept: $facultySelectedDept");
    log("Selected Course: $facultySelectedCourse");
    log("Selected Sem: $facultySelectedSem");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 25,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.blueAccent,
          title: Text(
            facultySelectedCourse!,
            style: GoogleFonts.jost(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                text: 'Content',
                icon: Icon(Icons.library_books_outlined),
              ),
              Tab(
                text: 'Summary',
                icon: Icon(Icons.assessment_outlined),
              ),
              Tab(
                text: 'Rating',
                icon: Icon(Icons.star),
              ),
              Tab(
                text: 'Other',
                icon: Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CourseContentPage(),
            SummaryPage(),
            FacultyRatingPage(),
            CourseOtherPage(),
          ],
        ),
      ),
    );
  }
}
