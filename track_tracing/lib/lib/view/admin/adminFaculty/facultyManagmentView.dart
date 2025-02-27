import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:track_tracing/controller/admin/firebaseAdminController.dart';

class FacultyManagement extends StatefulWidget {
  const FacultyManagement({super.key});

  @override
  State<FacultyManagement> createState() => _FacultyManagementState();
}

class _FacultyManagementState extends State<FacultyManagement> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _bioGraphyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();

  bool isLoading = false;

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

  Future _facultyInfoEditing(BuildContext context, int index) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              top: 50,
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
                      'Faculty Profile Edit ',
                      style: GoogleFonts.mulish(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                callTextField('Name ', _nameController),
                const SizedBox(height: 20),
                callTextField('Education ', _educationController),
                const SizedBox(height: 20),
                callTextField('BioGraphy ', _bioGraphyController),
                const SizedBox(height: 20),
                callTextField('E-mail ', _emailController),
                const SizedBox(height: 20),
                callTextField('Contact No. ', _contactNoController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isNotEmpty &&
                        _bioGraphyController.text.trim().isNotEmpty &&
                        _emailController.text.trim().isNotEmpty &&
                        _contactNoController.text.trim().isNotEmpty &&
                        _educationController.text.trim().isNotEmpty) {
                      // Changes Applied
                      facultyData[index]["facultyName"] = _nameController.text;
                      facultyData[index]["education"] =
                          _educationController.text;
                      facultyData[index]["bioGraphy"] =
                          _bioGraphyController.text;
                      facultyData[index]["FacultyEmailId"] =
                          _emailController.text;
                      facultyData[index]["contact"] = _contactNoController.text;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Data Updated"),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed : All fields are required"),
                        ),
                      );
                      Navigator.pop(context);
                    }
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
                        onPressed: () {
                          facultyData.removeAt(index);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Faculty member deleted')),
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

  @override
  void initState() {
    super.initState();
    _fetchFacultyData();
  }

  List<Map<String, dynamic>> facultyData = [];

  _fetchFacultyData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await AdminController().fetchFacultyData().then((value) {
        facultyData.addAll(value);
      });
      log(facultyData.toString());
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
            backgroundColor: const Color.fromRGBO(245, 249, 255, 1),

      appBar: AppBar(
        title: Text(
          'Faculty Management',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (isLoading)
            ?  Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.blueAccent,size: 40
                ),
              )
            : ListView.builder(
                itemCount: facultyData.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.3),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.blue.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                facultyData[index]['facultyName'] ?? 'Unknown',
                                style: GoogleFonts.mulish(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              ClipOval(
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  facultyData[index]['profileImgUrl'] ?? '',
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            facultyData[index]['education'] ??
                                'Position Unavailable',
                            style: GoogleFonts.mulish(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Subjects: ${facultyData[index]['subjectsTaughts'] ?? 'N/A'}',
                            style: GoogleFonts.mulish(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Biography: ${facultyData[index]['bioGraphy'] ?? 'N/A'}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.mulish(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.blueAccent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  facultyData[index]['emailId'] ?? 'No Email',
                                  style: GoogleFonts.mulish(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                facultyData[index]['contact'] ?? 'No Phone',
                                style: GoogleFonts.mulish(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                              height: 20, thickness: 1, color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () => openDialogBox(index),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'Delete',
                                  style: GoogleFonts.mulish(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
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
                },
              ),
      ),
    );
  }
}
