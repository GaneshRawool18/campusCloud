import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:track_tracing/controller/student/authservice.dart';
import 'package:track_tracing/controller/student/courseFIrestoreController.dart';
import 'package:track_tracing/controller/student/sharedPreference.dart';
import 'package:track_tracing/view/student/Course/descriptionPage.dart';
import 'package:track_tracing/view/student/Home/notificationPage.dart';
import 'package:track_tracing/view/student/Home/rankPage.dart';

class Coursepage extends StatefulWidget {
  const Coursepage({super.key});

  @override
  State<Coursepage> createState() => _CoursepageState();
}

String? selectedStudentDeptName;
List<Map<String, dynamic>> notifications = [];

//index,name
class _CoursepageState extends State<Coursepage> {
  TextEditingController searchController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final CourseController _controller = CourseController();
  List<Map<String, dynamic>> _allCourses = [];
  // List<String> courses = [];
  List<Map<String, dynamic>> filteredItems = [];
  bool isLoading = true;
  bool? isEnrolled;

  List<String> dept = [];
  String? selectedDept;

  @override
  void initState() {
    super.initState();
    _chekLogin();
    _fetchAllCourses();
  }

  void _fetchNotification() async {
    try {
      final value =
          await _controller.fetchNotification(selectedStudentDeptName!);
      setState(() {
        notifications = value.values
            .toList()
            .cast<Map<String, dynamic>>()
            .reversed
            .toList();
      });
      notifications.sort((a, b) {
        final formatA = parseTime(a['time']);
        final formatB = parseTime(b['time']);
        return formatB.compareTo(formatA);
      });
    } catch (e) {
      log("Error fetching notifications: $e");
    }
  }

  void _filterCourses(String query) {
    setState(() {
      filteredItems = _allCourses.where((course) {
        return course["courseName"]!
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  DateTime parseTime(String time) {
    final parts = time.split(" ");
    final isPM = parts[1] == "PM";
    final timeParts = parts[0].split(":").map(int.parse).toList();
    int hour = timeParts[0];
    int minute = timeParts[1];

    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }
    return DateTime(0, 1, 1, hour, minute);
  }

  void _chekLogin() {
    if (SharedPreferenceController.isLogin!) {
      Authservice.studentID = SharedPreferenceController.id;
    }
  }

  void refreshScreen() {
    setState(() {
      _fetchAllCourses();
    });
  }

  void _fetchAllCourses() async {
    setState(() {
      isLoading = true;
    });
    _allCourses = [];
    String deptName = await _controller.fetchDeptNameForCourseHomePage();
    selectedStudentDeptName = deptName;
    _allCourses = await _controller.fetchAllCourses(deptName);
    _fetchNotification();

    filteredItems = _allCourses;

    dept = await _controller.fetchDeptName();
    setState(() {
      isLoading = false;
    });
  }

  bool _checkEnrolled(int index) {
    List<dynamic> enrolls = _allCourses[index]["enrollStudents"] ?? [];
    for (int i = 0; i < enrolls.length; i++) {
      if (enrolls[i] == Authservice.studentID) {
        return true;
      }
    }
    return false;
  }

  void _sendEnrollement(
      String deptmant, String semester, String course, String courseCode) {
    if (_codeController.text.trim().isNotEmpty) {
      log("Enroll in $deptmant, $semester, $course");
      if (_codeController.text == courseCode) {
        CourseController()
            .enrollStudentCourse(deptmant, "Semester $semester", course);
        _fetchAllCourses();
        setState(() {
          _codeController.clear();
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Course Code!"),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  double _calculateProgress(int completed, int total) {
    return completed / total;
  }

  String _calculatePercentage(int completed, int total) {
    if (total == 0) {
      return "0.00";
    }

    double percentage = (completed / total) * 100;

    return percentage.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              "assets/images/graduation.png",
              height: 40,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              "Online Learning Flatform",
              style: GoogleFonts.jost(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationPage()));
              },
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Icon(Icons.notifications,
                          color: Color.fromRGBO(255, 255, 255, 1), size: 35),
                    ),
                  ),
                  Text(
                    notifications.length.toString(),
                    style: GoogleFonts.mulish(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 114, 104)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: _filterCourses,
                style: GoogleFonts.jost(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 1),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(9, 97, 245, 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Color.fromRGBO(255, 255, 255, 1),
                          size: 25,
                        ),
                      ),
                    ),
                    hintText: " Search Course",
                    hintStyle: GoogleFonts.mulish(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade400,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 0.025,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.025),
                        borderRadius: BorderRadius.circular(12)),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _fetchAllCourses,
                  child: Text(
                    "Courses",
                    style: GoogleFonts.jost(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(9, 97, 245, 1),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    refreshScreen();
                  },
                  icon: const Icon(Icons.refresh_outlined),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            (isLoading)
                ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: const Color.fromRGBO(9, 97, 245, 1),
                      size: 50,
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      _checkEnrolled(index);
                      final course = filteredItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: (_checkEnrolled(index))
                              ? () async {
                                  Map<String, dynamic> data = {};
                                  await CourseController()
                                      .fetchCourseDescription(
                                          course["department"] ?? "",
                                          "Semester ${course["semester"]}",
                                          course["courseName"] ?? "")
                                      .then((value) {
                                    if (value.isNotEmpty) {
                                      data.addAll(value);
                                    }
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DescriptionPage(
                                                description: data,
                                              )));
                                }
                              : () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    "Enter course code to access this course",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.mulish(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  width:
                                                      200, // Set the width you want
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all()),
                                                  child: TextField(
                                                    controller: _codeController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Enter code',
                                                            border: InputBorder
                                                                .none),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                GestureDetector(
                                                  onTap: () => _sendEnrollement(
                                                      course["department"] ??
                                                          "", // Default value for null
                                                      course["semester"] ??
                                                          "", // Default value for null
                                                      course["courseName"] ??
                                                          "", // Default value for null
                                                      course["courseCode"] ??
                                                          ""), // Default value for null
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 150,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color:
                                                          const Color.fromRGBO(
                                                              9, 97, 245, 1),
                                                    ),
                                                    child: Text(
                                                      "Send Request",
                                                      style: GoogleFonts.mulish(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color
                                                              .fromRGBO(255,
                                                              255, 255, 1)),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 12,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: (_checkEnrolled(index))
                                    ? const Color.fromRGBO(255, 255, 255, 1)
                                    : Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              children: [
                                FittedBox(
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(0, 0, 0, 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        course["images"] ??
                                            "  https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pexels.com%2Fsearch%2Feducation%2F&psig=AOvVaw3",
                                        fit: BoxFit.contain,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  width: 251,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.person_2_sharp),
                                          Expanded(
                                            child: Text(
                                              course["faculty"] ??
                                                  "Faculty", // Default value for null
                                              style: GoogleFonts.mulish(
                                                  fontSize: 14,
                                                  color: const Color.fromRGBO(
                                                      255, 107, 0, 1),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              course["courseName"] ??
                                                  "Course", // Default value for null
                                              style: GoogleFonts.jost(
                                                  fontSize: 16,
                                                  color: const Color.fromRGBO(
                                                      32, 34, 68, 1),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const RankPage()));
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 40,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      22, 127, 113, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                (_checkEnrolled(
                                                        index)) // Check if the course is enrolled
                                                    ? (course["totalTasks"]
                                                                ?.toString()
                                                                .isNotEmpty ==
                                                            true
                                                        ? course["totalTasks"]
                                                            .toString()
                                                        : "0") // Check if totalTasks is non-null and non-empty
                                                    : "0", // Defaul
                                                style: GoogleFonts.mulish(
                                                    fontSize: 16,
                                                    color: const Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      LinearPercentIndicator(
                                        // ignore: deprecated_member_use
                                        barRadius: const Radius.circular(6),
                                        animationDuration: 1000,
                                        animation: true,
                                        curve: Curves.easeIn,
                                        center: Text(
                                          (_checkEnrolled(index))
                                              ? "${_calculatePercentage(course["taskCompleted"]?[Authservice.studentID] ?? 0, course["totalTasks"] ?? 0)} %"
                                              : "0%",
                                          style: GoogleFonts.mulish(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 1)),
                                        ),
                                        percent: (_checkEnrolled(index))
                                            ? _calculateProgress(
                                                (course["taskCompleted"]?[
                                                            Authservice
                                                                .studentID] ??
                                                        0)
                                                    .toInt(),
                                                (course["totalTasks"] ?? 0)
                                                    .toInt(),
                                              )
                                            : 0,

                                        progressColor:
                                            const Color.fromRGBO(9, 97, 245, 1),
                                        lineHeight: 25,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
          ],
        ),
      ),
    );
  }
}
