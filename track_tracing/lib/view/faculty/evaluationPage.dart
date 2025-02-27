import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/faculty/courseContentControlller.dart';
import 'package:track_tracing/controller/faculty/courseController.dart';
import 'package:track_tracing/view/faculty/courseNavigationPage.dart';
import 'package:url_launcher/url_launcher.dart';

class EvaluationPage extends StatefulWidget {
  final String? facultySelectedAssignment;
  final String? facultySelectedTopic;
  const EvaluationPage(
      {super.key,
      required this.facultySelectedAssignment,
      required this.facultySelectedTopic});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final List<Map<String, dynamic>> studentEvaluations = [];
  String? facultySelectedAssignment;
  String? facultySelectedTopic;
  bool isLoaded = false;

  @override
  initState() {
    super.initState();
    facultySelectedAssignment = widget.facultySelectedAssignment;
    facultySelectedTopic = widget.facultySelectedTopic;
    _fetchStudentEvaluations();
  }

  void _fetchStudentEvaluations() async {
    setState(() {
      isLoaded = true;
    });
    await CourseContentController()
        .fetchStudentEvaluations(
            facultySelectedDept,
            facultySelectedSem,
            facultySelectedCourse,
            facultySelectedTopic,
            facultySelectedAssignment)
        .then((value) {
      studentEvaluations.addAll(value);
      log("Student Evaluations: $studentEvaluations");
    }).catchError((e) {
      log("Error in fetchin evaluation: $e");
    });

    log("Student Evaluations: $studentEvaluations");
    setState(() {
      isLoaded = false;
    });
  }

  void _updateStudentMarks(String studentId, String marks) async {
    await CourseContentController()
        .updateMarks(
            facultySelectedDept,
            facultySelectedSem,
            facultySelectedCourse,
            facultySelectedTopic,
            facultySelectedAssignment,
            studentId,
            marks)
        .then((value) {
      log("Marks updated successfully");
    }).catchError((e) {
      log("Error in updating marks: $e");
    });
  }

  void _downloadDocument(int index) {
    Uri? documentUrl = Uri.parse(studentEvaluations[index]['submittedLink']);
    if (documentUrl != null) {
      launch(documentUrl.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Evaluation Page',
          style: GoogleFonts.jost(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignment: $facultySelectedAssignment',
              style: GoogleFonts.jost(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Students: ${studentEvaluations.length}',
              style: GoogleFonts.jost(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: (isLoaded)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: studentEvaluations.length,
                      itemBuilder: (context, index) {
                        final student = studentEvaluations[index];
                        return _buildStudentCard(
                          index,
                          student['studentId'] ?? '',
                          student['studentName'] ?? '',
                          student['marks'] ?? '',
                          (newMarks) {
                            setState(() {
                              _updateStudentMarks(
                                  student['studentId'], newMarks);
                              studentEvaluations[index]['marks'] = newMarks;
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(int index, String studentId, String studentName,
      String marks, ValueChanged<String> onMarksChanged) {
    final TextEditingController marksController =
        TextEditingController(text: marks);
    bool isUpdated = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          color: const Color.fromRGBO(245, 245, 245, 1),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: $studentId',
                          style: GoogleFonts.jost(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Name: $studentName',
                          style: GoogleFonts.jost(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Marks: ',
                              style: GoogleFonts.jost(
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(
                              width: 35,
                              height: 25,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: marksController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.jost(
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                ),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    isUpdated = true;
                                  });
                                },
                              ),
                            ),
                            Text(
                              ' /10',
                              style: GoogleFonts.jost(
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.visibility, color: Colors.green),
                          onPressed: () {},
                        ),
                        IconButton(
                            icon: const Icon(Icons.download, color: Colors.red),
                            onPressed: () => _downloadDocument(index)),
                      ],
                    ),
                  ],
                ),
                if (isUpdated)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        String newMarks = marksController.text;
                        if (int.tryParse(newMarks) != null &&
                            int.parse(newMarks) > 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Marks should be less than 10.',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          );
                          return;
                        }
                        onMarksChanged(newMarks.toString());
                        setState(() {
                          isUpdated = false;
                        });
                      },
                      child: const Text('Save'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
