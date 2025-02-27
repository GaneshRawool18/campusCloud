import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/courseFIrestoreController.dart';
import 'package:track_tracing/view/student/Course/contentPage.dart';
import 'package:track_tracing/view/student/Course/courseRatingPage.dart';
import 'package:track_tracing/view/student/Course/marksPage.dart';

class DescriptionPage extends StatefulWidget {
   Map<String,dynamic> description = {};
   DescriptionPage({
    super.key,
   required this.description
  });

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  int selectedNum = 0;
  String? courseName;
  String? semester;
  Map<String, dynamic> description = {};
  bool isLoading = false;
  List<String> assignmentTopics = [];

   void initState() {
    super.initState();
    description = widget.description; 
    if (description.isEmpty) {
      _fetchCourseDescription(); 
    } else {
      assignmentTopics =
          List<String>.from(description['courseSummary'] ?? []);
    }
  }

  void _fetchCourseDescription() async {
    setState(() {
      isLoading = true;
    });
    await CourseController()
        .fetchCourseDescription(
            CourseController.selectedDeptName!,
            CourseController.selectedSemister!,
            CourseController.selectedCurseName!)
        .then((value) {
      setState(() {
        log("data is retrived");
        description = value;
        // isLoading = false;
        assignmentTopics = List<String>.from(description['courseSummary'] ?? []);
      });
      log("Assignment Topics: $assignmentTopics");
    });
    setState(() {
      isLoading = false;  
    });
  }
  
  void _changePage(int num) {
    setState(() {
      selectedNum = num;
    });
  }

  final List<String> _title = ["Description", "Content", "Marks", "Rating"];

  Widget descriptionPage() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("About course: ",
                        style: GoogleFonts.mulish(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                    Expanded(
                      child: Text(
                          "(${description['courseName'] ?? "Course Name"})",
                          style: GoogleFonts.mulish(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                    "Description: ${description['courseDescription'] ?? "No Description"}",
                    style: GoogleFonts.mulish(
                        fontSize: 18, fontWeight: FontWeight.w400)),
                const SizedBox(height: 15),
                const Text("- Course Summary",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
                const SizedBox(height: 10),
                assignmentTopics.isEmpty
                    ? const Center(child: Text('No topics available'))
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: assignmentTopics.length,
                          itemBuilder: (context, index) {
                            return _buildAssignmentTopic(
                                index + 1, assignmentTopics[index]);
                          },
                        ),
                      ),
              ],
            ),
    );
  }

  Widget _buildAssignmentTopic(int index, String topic) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('$index'),
      ),
      title: Text(topic, style: GoogleFonts.mulish(fontSize: 16)),
    );
  }

  Widget _buildNavigationButton(int index, IconData icon, String label) {
    return Column(
      children: [
        Container(
          decoration: (selectedNum == index)
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(22, 127, 113, 1))
              : const BoxDecoration(),
          child: IconButton(
            onPressed: () {
              _changePage(index);
            },
            icon: Icon(icon),
            color: (selectedNum == index)
                ? const Color.fromRGBO(255, 255, 255, 1)
                : const Color.fromRGBO(32, 34, 68, 1),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.mulish(fontSize: 12, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  final List<Widget> _selectedPage = [
    const SizedBox(), // Placeholder for Description (dynamically built later)
    const Contentpage(),
    const MarksPage(),
    const RatingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          _title[selectedNum],
          style: GoogleFonts.quicksand(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            description.clear();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavigationButton(0, Icons.description, "Description"),
                _buildNavigationButton(1, Icons.menu_book, "Content"),
                _buildNavigationButton(2, Icons.score, "Marks"),
                _buildNavigationButton(3, Icons.star, "Rating"),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: selectedNum == 0 ? descriptionPage() : _selectedPage[selectedNum],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    description.clear();
    assignmentTopics.clear();
    super.dispose();
  }
}
