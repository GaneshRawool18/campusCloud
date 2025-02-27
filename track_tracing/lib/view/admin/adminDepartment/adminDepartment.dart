import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/admin/firebaseAdminController.dart';
import 'package:track_tracing/model/admin/adminDepartmentModel.dart';

class Admindepartmenthomepage extends StatefulWidget {
  const Admindepartmenthomepage({super.key});

  @override
  State<Admindepartmenthomepage> createState() =>
      _AdmindepartmenthomepageState();
}

//SEMESTER COUNT ADD KR BHAU

class _AdmindepartmenthomepageState extends State<Admindepartmenthomepage> {
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _enrolledStudentsController =
      TextEditingController();
  final TextEditingController _totalCapacityController =
      TextEditingController();
  final TextEditingController _semesterController = TextEditingController();

  List<Map<String, dynamic>> departmentdata = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchDept();
  }

  void _fetchDept() async {
    try {
      setState(() {
        isLoading = true;
      });
      departmentdata = [];
      await AdminController().fetchDept().then((value) {
        departmentdata.addAll(value);
      });
      //log("message => $departmentdata");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log("Error while fetching data: $e");
    }
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
                    'Press Confirm To Delete !',
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
                            backgroundColor: Colors.grey.withOpacity(0.8)),
                        label: Text(
                          'Cancel',
                          style: GoogleFonts.mulish(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await AdminController()
                              .removeDept(departmentdata[index]['department']);
                          departmentdata.removeAt(index);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Department Managment Updated!!')),
                          );
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

  Widget callTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.mulish(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 73, 119, 225), width: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.deepPurple, width: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Future DepartmentModalSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Color.fromARGB(255, 87, 87, 87),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Department Management ',
                      style: GoogleFonts.mulish(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                callTextField('Department Name ', _departmentController),
                const SizedBox(height: 20),
                callTextField('Total Semester', _semesterController),
                const SizedBox(height: 20),
                callTextField('Enrolled Student ', _enrolledStudentsController),
                const SizedBox(height: 20),
                callTextField('Total Capacity', _totalCapacityController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveChanges(context);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveChanges(BuildContext context) async {
    try {
      if (_departmentController.text.trim().isNotEmpty &&
          _enrolledStudentsController.text.trim().isNotEmpty &&
          _totalCapacityController.text.trim().isNotEmpty &&
          _semesterController.text.trim().isNotEmpty) {
        await AdminController().changeDept(AdminDepartmentModel(
          department: _departmentController.text,
          enrolledStudents: _enrolledStudentsController.text,
          totalCapacity: _totalCapacityController.text,
          totalSem: _semesterController.text,
        ).toMap());

        log("message => $departmentdata");
        _fetchDept();
        clearController();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data Updated"),
          ),
        );

        Navigator.pop(context);

        setState(() {});
      }
    } catch (e) {
      log("Error while saving data: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error while updating data. Please try again."),
        ),
      );
    }
  }

  void clearController() {
    _departmentController.clear();
    _enrolledStudentsController.clear();
    _totalCapacityController.clear();
    _semesterController.clear();
  }

  Widget _infoRow({
    required String title,
    required dynamic value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Text(
          '$title: ',
          style: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        Expanded(
          child: Text(
            value.toString(),
            style: GoogleFonts.mulish(
              fontSize: 15,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Department Management',
          style: GoogleFonts.mulish(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 84, 178, 254),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: departmentdata.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 8,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient:const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 173, 205, 245),
                            Color.fromARGB(255, 214, 234, 248),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // ignore: prefer_const_constructors
                                Icon(
                                  Icons.school,
                                  color: Colors.blueAccent,
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    departmentdata[index]['department'] ??
                                        'Unknown',
                                    style: GoogleFonts.mulish(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    openDialogBox(index);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete_outlined,
                                    color: Color.fromARGB(255, 223, 27, 12),
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1.5,
                              color: Colors.grey,
                              endIndent: 5,
                            ),
                            const SizedBox(height: 8),
                            _infoRow(
                              title: 'Total Semester',
                              value: departmentdata[index]['totalSem'] ?? 'N/A',
                              icon: Icons.calendar_month,
                              iconColor: Colors.orange,
                            ),
                            const SizedBox(height: 8),
                            _infoRow(
                              title: 'Enrolled Students',
                              value: departmentdata[index]
                                      ['EnrolledStudents'] ??
                                  'N/A',
                              icon: Icons.group,
                              iconColor: Colors.green,
                            ),
                            const SizedBox(height: 8),
                            _infoRow(
                              title: 'Total Capacity',
                              value: departmentdata[index]['TotalCapacity'] ??
                                  'N/A',
                              icon: Icons.meeting_room,
                              iconColor: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DepartmentModalSheet(context);
        },
        backgroundColor: const Color.fromARGB(255, 84, 178, 254),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
