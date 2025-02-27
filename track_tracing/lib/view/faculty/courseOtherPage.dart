import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/faculty/courseController.dart';
import 'package:track_tracing/view/faculty/courseNavigationPage.dart';

class CourseOtherPage extends StatefulWidget {
  const CourseOtherPage({super.key});

  @override
  State<CourseOtherPage> createState() => _CourseOtherPageState();
}

class _CourseOtherPageState extends State<CourseOtherPage> {
  final TextEditingController _summaryController = TextEditingController();
  Map<String, dynamic> courseDetails = {};
  bool isLoading = false;

  List<String> assignmentTopics = [];

  @override
  void initState() {
    super.initState();
    _fetchSelectedCourseDetails();
  }

  void _fetchSelectedCourseDetails() async {
    setState(() {
      isLoading = true;
    });
    await FacultyCourseController()
        .getCourseDetails(
            facultySelectedDept!, facultySelectedSem!, facultySelectedCourse!)
        .then((value) {
      courseDetails = value;
      assignmentTopics = List<String>.from(value['courseSummary'] ?? []);
    });
    setState(() {
      isLoading = false;
    });
  }

  void _addTopicSummary() async {
    if (_summaryController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await FacultyCourseController().addCourseSummary(facultySelectedDept!,
          facultySelectedSem!, facultySelectedCourse!, _summaryController.text);

      setState(() {
        assignmentTopics.add(_summaryController.text);
        _summaryController.clear();
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a topic name'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Description: ${courseDetails['courseDescription'] ?? ''}',
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard('Semester', courseDetails['semester'] ?? ''),
                  _buildInfoCard(
                      'Department', courseDetails['department'] ?? ''),
                  _buildInfoCard(
                      'Course Code', courseDetails['courseCode'] ?? ''),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Course Summary',
                style: GoogleFonts.mulish(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3 + 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                child: (isLoading)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: assignmentTopics.isEmpty
                            ? 1
                            : assignmentTopics.length,
                        itemBuilder: (context, index) {
                          return assignmentTopics.isEmpty
                              ? const Center(child: Text('No topics available'))
                              : _buildAssignmentTopic(
                                  index + 1, assignmentTopics[index]);
                        },
                      ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                child: Column(
                  children: [
                    TextField(
                      controller: _summaryController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Enter topic name',
                        label: Text('Add Topic'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _addTopicSummary,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: const Color.fromRGBO(9, 97, 254, 1)),
                      child: Text(
                        'Add Topic',
                        style: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(255, 255, 255, 1)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentTopic(int number, String topic) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.black,
            child: Text(
              number.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(topic,
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ],
      ),
    );
  }
}
