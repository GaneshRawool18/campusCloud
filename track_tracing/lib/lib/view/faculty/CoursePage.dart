import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:track_tracing/controller/faculty/courseController.dart';
import 'package:track_tracing/controller/faculty/facultyProfileController.dart';
import 'package:track_tracing/view/faculty/courseNavigationPage.dart';
import 'package:track_tracing/view/faculty/facultyProfilePage.dart';

Map<String, dynamic> facutlyProfileData = {};
List<Map<String, dynamic>> coursesByDepartment = [];

class FacultyCoursePage extends StatefulWidget {
  const FacultyCoursePage({super.key});

  @override
  State<FacultyCoursePage> createState() => _FacultyCoursePageState();
}

class _FacultyCoursePageState extends State<FacultyCoursePage> {
  bool isLoding = false;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  void _fetchCourses() async {
    setState(() {
      isLoding = true;
    });
    coursesByDepartment = [];

    await FacultyProfileController().fetchFacultyDetails().then((value) {
      facutlyProfileData.addAll(value);
    });

    await FacultyCourseController().fetchCoursesByDepartment().then((value) {
      coursesByDepartment.addAll(value);
    });

    setState(() {
      isLoding = false;
    });
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
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Faculty Dashboard",
                style: GoogleFonts.jost(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          facutlyProfileData["profileImgUrl"] ??
                              "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              facutlyProfileData["facultyName"] ??
                                  "Faculty Name",
                              style: GoogleFonts.jost(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(32, 34, 68, 1),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              facutlyProfileData["emailId"] ?? "Faculty Email",
                              style: GoogleFonts.jost(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(32, 34, 68, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FacultyProfilePage(),
                                  ),
                                );
                              },
                              child: Text(
                                "View Profile",
                                style: GoogleFonts.jost(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Courses",
                style: GoogleFonts.jost(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: const Color.fromRGBO(32, 34, 68, 1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: (isLoding)
                    ? Center(
                        child: LoadingAnimationWidget.inkDrop(
                            color: Colors.blueAccent, size: 50),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: coursesByDepartment.length,
                        itemBuilder: (context, index) {
                          List<Map<String, dynamic>> course =
                              coursesByDepartment[index]["courses"];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                coursesByDepartment[index]["departmentName"] ??
                                    "Department Name",
                                style: GoogleFonts.jost(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(32, 34, 68, 1),
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 330,
                                child: ListView.builder(
                                  itemCount: course.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, subIndex) {
                                    List<dynamic> enrolled = course[subIndex]
                                        ["enrollStudents"] as List<dynamic>;

                                    int length = enrolled.length;
                                    return FittedBox(
                                      child: Container(
                                        width: 250,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .white, // Background color of the column
                                          borderRadius: BorderRadius.circular(
                                              15), // Rounded corners
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors
                                                  .black26, // Shadow color
                                              offset:
                                                  Offset(0, 2), // Shadow offset
                                              blurRadius:
                                                  6, // Shadow blur radius
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Course Image
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                course[subIndex]["images"] ??
                                                    "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                                                height: 150,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 15),

                                            Text(
                                              course[subIndex]["courseName"] ??
                                                  "Course Name",
                                              style: GoogleFonts.jost(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromRGBO(
                                                    32, 34, 68, 1),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Enrolled Students: $length",
                                                    style: GoogleFonts.jost(
                                                      fontSize: 14,
                                                      color:
                                                          const Color.fromRGBO(
                                                              32, 34, 68, 0.8),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Course Code: ${course[subIndex]["courseCode"]} ",
                                                    style: GoogleFonts.jost(
                                                      fontSize: 14,
                                                      color:
                                                          const Color.fromRGBO(
                                                              32, 34, 68, 0.8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          32, 34, 68, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 25,
                                                      vertical: 10),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CourseNavigationPage(
                                                        selectdSem:
                                                            "Semester ${course[subIndex]["semester"]}",
                                                        selectdcourseName:
                                                            course[subIndex]
                                                                ["courseName"],
                                                        selectedDept:
                                                            course[subIndex]
                                                                ["department"],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  "Go To Course",
                                                  style: GoogleFonts.jost(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
