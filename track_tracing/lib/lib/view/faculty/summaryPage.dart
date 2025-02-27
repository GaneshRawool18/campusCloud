import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/faculty/courseContentControlller.dart';
import 'package:track_tracing/view/faculty/courseNavigationPage.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  List<dynamic> topics = [];
  List<String> assignments = [];
  List<Map<String, dynamic>> totalEnrolledStudents = [];
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> pendingStudents = [];
  String? selectedValue;
  String? selectedAssignment;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  void fetchTopics() {
    CourseContentController()
        .fetchTopicsList(
            facultySelectedDept, facultySelectedSem, facultySelectedCourse)
        .then((value) {
      setState(() {
        topics = value;
      });
    });
  }

  void _fetchAssignments(String topic) async {
    await CourseContentController()
        .fetchAssignemtsNameList(facultySelectedDept, facultySelectedSem,
            facultySelectedCourse, topic)
        .then((value) {
      assignments = value;
    });
    setState(() {});
  }

  void _searchStudents() async {
    try {
      setState(() {
        isLoading = true;
      });
      await CourseContentController()
          .fetchTotalEnrolledStudents(
              facultySelectedDept, facultySelectedSem, facultySelectedCourse)
          .then((value) {
        totalEnrolledStudents = value;
      });

      await CourseContentController()
          .fetchStudentsList(facultySelectedDept, facultySelectedSem,
              facultySelectedCourse, selectedValue, selectedAssignment)
          .then((value) {
        students = value;
      });

      pendingStudents.clear();
      for (var studentId in totalEnrolledStudents) {
        bool isCompleted = false;
        for (var student in students) {
          if (studentId['studentId'] == student['studentId']) {
            studentId['studentName'] = student['studentName'];
            isCompleted = true;
            break;
          }
        }
        if (!isCompleted) {
          pendingStudents.add({
            ...studentId,
            'status': 'Pending',
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching students: $e');
    }
  }

  Widget getDropDownBox({
    required List<dynamic> items,
    required String title,
    String? selectedValue,
    Function(String?)? onChanged,
  }) {
    return DropdownButton2<String>(
      underline: const SizedBox.shrink(),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
          size: 24,
        ),
      ),
      buttonStyleData: ButtonStyleData(
        height: 48,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
      value: selectedValue,
      items: items.map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem(
          value: value,
          child: Text(
            value,
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      hint: Text(
        "Select $title",
        style: GoogleFonts.mulish(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
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
              getDropDownBox(
                title: 'Topic',
                items: topics,
                selectedValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedAssignment = null;
                    assignments.clear();
                    selectedValue = value;
                    _fetchAssignments(value!);
                  });
                },
              ),
              const SizedBox(height: 16),
              getDropDownBox(
                title: 'Assignment',
                items: assignments,
                selectedValue: selectedAssignment,
                onChanged: (value) {
                  setState(() {
                    selectedAssignment = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => _searchStudents(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStudentStatus('Completed', students.length),
                  _buildStudentStatus('Pending', pendingStudents.length),
                ],
              ),
              const SizedBox(height: 24),
              (students.isEmpty)
                  ? const SizedBox()
                  : _buildStudentList('Completed Students', students),
              const SizedBox(height: 16),
              (pendingStudents.isEmpty)
                  ? const SizedBox()
                  : _buildStudentList('Pending Students', pendingStudents),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentStatus(String status, int count) {
    return Card(
      color: const Color.fromRGBO(255, 255, 255, 1),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status,
              style: GoogleFonts.jost(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            (isLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    '$count Students',
                    style: GoogleFonts.jost(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList(String title, List<Map<String, dynamic>> students) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.jost(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
            
            final student = students[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: const Color.fromRGBO(9, 97, 245, 1),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  student['studentName'],
                  style: GoogleFonts.jost(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                subtitle: Text(
                  'ID: ${student['studentId']}',
                  style: GoogleFonts.jost(
                    fontSize: 14,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                trailing: Chip(
                  label: Text(
                    student['status'],
                    style: GoogleFonts.jost(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: student['status'] == 'Completed'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  backgroundColor: student['status'] == 'Completed'
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
