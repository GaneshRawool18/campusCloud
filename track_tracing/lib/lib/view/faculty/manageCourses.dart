import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:track_tracing/controller/faculty/courseController.dart';
import 'package:track_tracing/view/faculty/HomePage.dart';
import 'package:track_tracing/view/faculty/student_list_page.dart';

Map<String, dynamic> editableCourseData = {};

class ManageCourses extends StatefulWidget {
  const ManageCourses({super.key});

  @override
  State<ManageCourses> createState() => _ManageCoursesState();
}

class _ManageCoursesState extends State<ManageCourses> {
  TextEditingController searchController = TextEditingController();
  String? selectedValue;
  bool isLoading = false;
  List<Map<String, dynamic>> courseList = [];
  List<Map<String, dynamic>> orignalCourseList = [];
  List<String> departmentNameList = [];

  @override
  void initState() {
    super.initState();
    _fetchAllCourses();
  }

  void _toDepartmentNameList() {
    String departmentName = "";
    for (var course in orignalCourseList) {
      if (course['department'] != departmentName) {
        departmentName = course['department'];
        departmentNameList.add("${course['department']}");
      }
      setState(() {});
    }
  }

  void _fetchAllCourses() async {
    setState(() {
      isLoading = true;
    });
    FacultyCourseController().getCourseList().then((value) {
      setState(() {
        courseList = value;
        orignalCourseList = value;
        isLoading = false;
        _toDepartmentNameList();
        if (!departmentNameList.contains(selectedValue)) {
          selectedValue = null;
        }
      });
    });
  }

  void _deleteCourse(
      int index, String deptName, String semesterName, String courseName) {
    FacultyCourseController()
        .deleteCourse(deptName, "Semester $semesterName", courseName)
        .then((value) {
      if (value) {
        setState(() {
          courseList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Course deleted successfully",
              style: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error deleting course",
              style: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _fetchCoursesByDepartment(String semester) async {
    log("semester: $semester");
    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> filteredCourses = [];

      for (var course in orignalCourseList) {
        if (course['department'] == semester) {
          log("entered");
          log("semester: $semester");
          filteredCourses.add(course);
        }
      }

      setState(() {
        courseList = filteredCourses;
        isLoading = false;
      });
      log("Courses by department: $courseList");
    } catch (e) {
      log("Error fetching courses by department: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          title: Text(
            'Manage Courses',
            style: GoogleFonts.jost(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 14, left: 5, right: 5),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("All Courses",
                  style: GoogleFonts.jost(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  )),
              Expanded(
                child: (isLoading)
                    ? Center(
                        child: LoadingAnimationWidget.inkDrop(
                            color: Colors.blueAccent, size: 50),
                      )
                    : ListView.builder(
                        itemCount: courseList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          List<dynamic> enrolled = courseList[index]
                              ["enrollStudents"] as List<dynamic>;

                          int length = enrolled.length;
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            elevation: 4,
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              courseList[index]['images'],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            courseList[index]['courseCode'],
                                            style: GoogleFonts.jost(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              courseList[index]['courseName'],
                                              style: GoogleFonts.jost(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "Duration: 10 weeks",
                                              style: GoogleFonts.jost(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Semester: ${courseList[index]['semester']}",
                                              style: GoogleFonts.jost(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Department: ${courseList[index]['department']}",
                                              style: GoogleFonts.jost(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return const StudentListPage();
                                                }));
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Enrolled Students: ${length.toString()}",
                                                    style: GoogleFonts.jost(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Icon(
                                                    Icons.info_outline,
                                                    color: Colors.blueAccent,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        label: Text(
                                          "Edit",
                                          style: GoogleFonts.jost(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onPressed: () {
                                          editableCourseData =
                                              courseList[index];
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FacultyHomePage(
                                                        initialIndex: 1,
                                                      )));
                                        },
                                      ),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        label: Text(
                                          "Delete",
                                          style: GoogleFonts.jost(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onPressed: () =>
                                            _showConfirmationDialog(
                                                context, index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ));
  }

  void _showConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[50], // Background color of the dialog
          title: Text(
            'Confirm Deletion',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900], // Title text color
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this course? This action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87, // Content text color
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
                print('Assignment not deleted.');
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue, // Cancel button text color
                  fontSize: 16,
                ),
              ),
            ),
            // Confirm Button
            TextButton(
              onPressed: () {
                _deleteCourse(
                    index,
                    courseList[index]['department'],
                    courseList[index]['semester'],
                    courseList[index]['courseName']);
                Navigator.of(context).pop(); // Close the dialog with action
                print('Assignment deleted.');
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red, // Confirm button text color
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
