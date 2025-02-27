import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/admin/firebaseAdminController.dart';
import 'package:track_tracing/view/admin/adminStudent/StudentInfoCard.dart';

List<Map<String, dynamic>> stdList = [];

class StudentManagement extends StatefulWidget {
  const StudentManagement({super.key});

  @override
  State<StudentManagement> createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchData();
    log(stdList.toString());
  }

  Future<void> _fetchData() async {
    stdList = [];
    try {
      setState(() {
        isLoading = true;
      });
      await AdminController().fetchStudentCard().then((value) {
        stdList.addAll(value);
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching stdList: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Management',
          style: GoogleFonts.mulish(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 84, 178, 254),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildStudentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    return Expanded(
      child: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: stdList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => _buildStudentCard(index),
            ),
    );
  }

  Widget _buildStudentCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.grey.withOpacity(0.5),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 172, 214, 251),
              Color.fromARGB(255, 230, 240, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    stdList[index]["profileUrl"],
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${stdList[index]["name"]}",
                        style: GoogleFonts.mulish(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildStudentInfo(
                          'Contact No', stdList[index]["contactNo"]),
                      _buildStudentInfo(
                          'Student ID', stdList[index]["StudentID"]),
                      _buildStudentInfo(
                          'Department', stdList[index]["department"]),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // const SizedBox(),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.visibility,
                    size: 24,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentInfoCard(
                          index: index,
                        ),
                      ),
                    );
                  },
                  label: Text(
                    'View',
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                // ElevatedButton.icon(
                //   icon: const Icon(
                //     Icons.block,
                //     size: 24,
                //     color: Colors.white,
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 20, vertical: 10),
                //     backgroundColor: Colors.red,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   onPressed: () {
                //     openDialogBox(index);
                //   },
                //   label: Text(
                //     'Suspend',
                //     style: GoogleFonts.mulish(
                //       fontSize: 16,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openDialogBox(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 15,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Press Confirm To Suspend !',
                    style: GoogleFonts.mulish(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(0.5)),
                        label: Text(
                          'Cancel',
                          style: GoogleFonts.mulish(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          stdList.removeAt(index);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.8)),
                        label: Text(
                          'Confirm',
                          style: GoogleFonts.mulish(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildStudentInfo(String label, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        '$label : $info',
        style: GoogleFonts.mulish(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
