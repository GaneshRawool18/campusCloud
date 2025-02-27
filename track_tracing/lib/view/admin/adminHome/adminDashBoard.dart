import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:track_tracing/controller/admin/firebaseAdminController.dart';
import 'package:track_tracing/view/admin/adminDepartment/adminDepartment.dart';
import 'package:track_tracing/view/admin/adminDepartment/bar.dart';
import 'package:track_tracing/view/admin/adminFaculty/facultyManagmentView.dart';
import 'package:track_tracing/view/admin/adminHome/NotificationPage.dart';
import 'package:track_tracing/view/admin/adminHome/adminNotification.dart';
import 'package:track_tracing/view/admin/adminHome/settings.dart';

import '../adminStudent/StudentManagement.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

Map<String, dynamic> adminData = {};
List<Map<String, dynamic>> courseData = [];

class _AdminDashBoardState extends State<AdminDashBoard> {
  Map<String, dynamic> adminAnyalyticsData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
  }

  _fetchAdminData() async {
    setState(() {
      isLoading = true;
    });
    adminData = await AdminController().fetchAdminDetails();
    await AdminController().fetchAllCountsForAnalytics().then((value) {
      adminAnyalyticsData = value;
    });
    await AdminController().fetchCourseTaskData().then((value) {
      courseData = value;
    });
    log("data $courseData");
    log("data $adminData");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
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
                "Admin Dashboard",
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const NotificationRequestScreen()));
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color.fromRGBO(255, 255, 255, 1),
                size: 30,
              ))
        ],
        backgroundColor: const Color.fromARGB(255, 84, 178, 254),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(40),
                  bottomEnd: Radius.circular(40),
                ),
                color: Color.fromARGB(255, 84, 178, 254),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ClipOval(
                    child: Image.network(
                      adminData["ImageUrl"] ?? "",
                      height: 125,
                      width: 125,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person_outline_outlined,
                          size: 120,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    adminData["name"] ?? "admin Name",
                    style: GoogleFonts.jost(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    adminData["position"] ?? "Admin Position",
                    style: GoogleFonts.jost(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    adminData["email"] ?? "admin@example.com",
                    style: GoogleFonts.jost(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(
                      color: Colors.white.withOpacity(0.5),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.35),
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                shadowColor: Colors.blueAccent.withOpacity(0.2),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.indigo.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Settings(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.settings_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseTaskChart(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.analytics,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Analytics',
                                    style: GoogleFonts.jost(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationAdmin(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.notification_add,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        (isLoading)
                            ? Center(
                                child: LoadingAnimationWidget.inkDrop(
                                    color: Colors.white, size: 40),
                              )
                            : Column(
                                children: [
                                  GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 1.2,
                                    ),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 4, // Number of items in the grid
                                    itemBuilder: (context, index) {
                                      // Prepare data dynamically based on index
                                      String label = '';
                                      String value = '';
                                      IconData icon = Icons.help_outline;
                                      late Widget targetScreen;

                                      if (index == 0) {
                                        label = 'Total Students';
                                        value = adminAnyalyticsData["Students"]
                                            .toString();
                                        icon = Icons.people;
                                        targetScreen =
                                            const StudentManagement();
                                      } else if (index == 1) {
                                        label = 'Total Faculty';
                                        value = adminAnyalyticsData["Faculty"]
                                            .toString();
                                        icon = Icons.person;
                                        targetScreen =
                                            const FacultyManagement();
                                      } else if (index == 2) {
                                        label = 'Total Courses';
                                        value =
                                            adminAnyalyticsData["TotalCourses"]
                                                .toString();
                                        icon = Icons.book;
                                        targetScreen = CourseTaskChart();
                                      } else if (index == 3) {
                                        label = 'Department';
                                        value =
                                            adminAnyalyticsData["Departments"]
                                                .toString();
                                        icon = Icons.apartment;
                                        targetScreen =
                                            const Admindepartmenthomepage();
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          // Perform navigation
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => targetScreen),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(1),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 8,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(icon,
                                                  color: Colors.blue, size: 30),
                                              const SizedBox(height: 8),
                                              Text(
                                                label,
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                value,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color.fromARGB(
                                                      255, 57, 97, 255),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
