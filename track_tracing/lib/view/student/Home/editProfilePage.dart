import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:track_tracing/controller/student/firebasebucket.dart';
import 'package:track_tracing/controller/student/sqfliteController.dart';
import 'package:track_tracing/controller/student/studentController.dart';
import 'package:track_tracing/model/student/registrationModal.dart';
import 'package:track_tracing/view/student/Login/launchPage.dart';

class Editprofilepage extends StatefulWidget {
  const Editprofilepage({super.key});

  @override
  State<Editprofilepage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Editprofilepage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController deptartmentController = TextEditingController();
  TextEditingController emergencyNumController = TextEditingController();
  TextEditingController emergencyNameController = TextEditingController();
  File? _pickedProfileImage;
  String? profileFileName;
  File? _selectedSignatureImage;
  String? signatureFileName;
  String? netSignImg;
  String? netProfileImg;
  RegistrationModel? registerStudent;
  bool _isLoding = false;

  void _register() async {
    try {
      if (nameController.text.trim().isNotEmpty &&
          contactController.text.trim().isNotEmpty &&
          dobController.text.trim().isNotEmpty &&
          bloodGroupController.text.trim().isNotEmpty &&
          deptartmentController.text.trim().isNotEmpty &&
          emergencyNameController.text.trim().isNotEmpty &&
          emergencyNumController.text.trim().isNotEmpty) {
        RegistrationModel registrationData = RegistrationModel(
          name: nameController.text,
          contact: contactController.text,
          dob: dobController.text,
          bloodGroup: bloodGroupController.text,
          department: deptartmentController.text,
          emergencyContactName: emergencyNameController.text,
          emergencyContactNo: emergencyNumController.text,
          profileUrl: profileData["profileUrl"],
          signatureUrl: profileData["signatureUrl"],
        );

        if (_selectedSignatureImage != null &&
            netSignImg!.isNotEmpty &&
            _pickedProfileImage != null &&
            netProfileImg!.isNotEmpty) {
          registrationData.profileUrl = await FirebaseBucket().uploadFile(
              "profileImage", profileFileName!, _pickedProfileImage!);
          registrationData.signatureUrl = await FirebaseBucket().uploadFile(
              "signatureImage", signatureFileName!, _selectedSignatureImage!);
          log("both images are selected");
        } else if (_pickedProfileImage != null && netProfileImg!.isNotEmpty) {
          registrationData.profileUrl = await FirebaseBucket().uploadFile(
              "profileImage", profileFileName!, _pickedProfileImage!);
          log("only profile image is selected");
        } else if (_selectedSignatureImage != null && netSignImg!.isNotEmpty) {
          registrationData.signatureUrl = await FirebaseBucket().uploadFile(
              "signatureImage", signatureFileName!, _selectedSignatureImage!);
          log("only signature image is selected");
        }

        setState(() {
          _isLoding = true;
        });
        await Studentcontroller().updateStudentData(registrationData.toMap());
        // await SqfliteController().insertData();
        // SqfliteController().readData();
        setState(() {
          _isLoding = false;
        });
        initState();
        log("Data updated successfully");
      } else {
        _showMessage("All fields are required");
      }
    } catch (e) {
      log("Failed to edit profile: $e");
    }
  }

  void _registerSucessfully() {
    nameController.clear();
    contactController.clear();
    bloodGroupController.clear();
    dobController.clear();
    emergencyNameController.clear();
    emergencyNumController.clear();
    deptartmentController.clear();
    _pickedProfileImage = null;
    _selectedSignatureImage = null;

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Launchpage()));
  }

  void _showMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Error',
                style: GoogleFonts.mulish(
                    fontSize: 25, fontWeight: FontWeight.bold)),
            content: Text(message,
                style: GoogleFonts.mulish(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.mulish(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  void _selectImage([bool isprofile = true]) async {
    if (isprofile) {
      FilePickerResult? selectedProfileImage =
          await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      setState(() {
        profileFileName = selectedProfileImage!.files.first.name;
        _pickedProfileImage = File(selectedProfileImage.files.first.path!);
      });
    } else {
      FilePickerResult? selectedSignImage = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      setState(() {
        signatureFileName = selectedSignImage!.files.first.name;
        _selectedSignatureImage = File(selectedSignImage.files.first.path!);
      });
    }
  }

  void selectDate() async {
    DateTime? date = await showDatePicker(
        context: context, firstDate: DateTime(1930), lastDate: DateTime(2010));
    String formatedDate = DateFormat.yMMMEd().format(date!);
    setState(() {
      dobController.text = formatedDate;
    });
  }

  void selectBloodGroup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 150,
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Select Blood Group",
                    style: GoogleFonts.mulish(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _createBloodGroupContainer("A+"),
                    _createBloodGroupContainer("A-"),
                    _createBloodGroupContainer("B+"),
                    _createBloodGroupContainer("B-"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _createBloodGroupContainer("AB+"),
                    _createBloodGroupContainer("AB-"),
                    _createBloodGroupContainer("O+"),
                    _createBloodGroupContainer("O-"),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _createBloodGroupContainer(String bloodGroup) {
    return GestureDetector(
      onTap: () => setState(() {
        bloodGroupController.text = bloodGroup;
        Navigator.pop(context);
      }),
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromRGBO(9, 97, 245, 1)),
        child: Text(
          bloodGroup,
          style: GoogleFonts.mulish(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(255, 255, 255, 1)),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    void Function()? onTap,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,
      style: GoogleFonts.mulish(fontWeight: FontWeight.w700, fontSize: 17),
      decoration: InputDecoration(
        labelText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: InputBorder.none,
        hintStyle: GoogleFonts.mulish(
            fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey[600]),
        prefixIcon: Icon(
          icon,
          color: Colors.blueAccent, // Set icon color to match theme
          size: 24,
        ),
        filled: true,
        fillColor: const Color.fromRGBO(
            232, 241, 255, 1), // Light gray fill color for a soft look
        contentPadding: const EdgeInsets.symmetric(
            vertical: 18.0, horizontal: 16.0), // Padding around text
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1.5), // Thicker and colored border
          borderRadius:
              BorderRadius.circular(15), // Slightly more rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.blueAccent, width: 2.0), // Accent color on focus
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: const Icon(Icons.check_circle,
            color: Colors.greenAccent), // Add an optional suffix icon
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fillAllfields();
  }

  void _fillAllfields() {
    netSignImg = profileData["signatureUrl"];
    netProfileImg = profileData["profileUrl"];
    nameController.text = profileData["name"];
    contactController.text = profileData["contactNo"];
    dobController.text = profileData["dob"];
    bloodGroupController.text = profileData["bloodGroup"];
    deptartmentController.text = profileData["department"];
    emergencyNameController.text = profileData["emergencyContactName"];
    emergencyNumController.text = profileData["emergencyContactNo"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,color: Colors.white,)),
            const SizedBox(
              width: 20,
            ),
            Text(
              "Edit your profile",
              style: GoogleFonts.jost(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromRGBO(232, 241, 255, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: (_pickedProfileImage == null)
                              ? Image.network(
                                  netProfileImg!,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  _pickedProfileImage!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _selectImage,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromRGBO(22, 127, 113, 1),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit_note_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  buildTextField(
                      controller: nameController,
                      hintText: "Full Name",
                      icon: Icons.person),
                  const SizedBox(height: 15),
                  buildTextField(
                      controller: contactController,
                      hintText: "Contact",
                      icon: Icons.phone),
                  const SizedBox(height: 15),
                  buildTextField(
                      controller: dobController,
                      hintText: "Date of Birth",
                      icon: Icons.calendar_today,
                      onTap: selectDate,
                      readOnly: true),
                  const SizedBox(height: 15),
                  buildTextField(
                      controller: bloodGroupController,
                      hintText: "Blood Group",
                      icon: Icons.bloodtype,
                      onTap: selectBloodGroup,
                      readOnly: true),
                  const SizedBox(height: 15),
                  buildTextField(
                      controller: deptartmentController,
                      hintText: "Department",
                      icon: Icons.apartment),
                  const SizedBox(height: 15),
                  buildTextField(
                      controller: emergencyNumController,
                      hintText: "Emergency Contact",
                      icon: Icons.phone),
                  const SizedBox(height: 15),
                  buildTextField(
                      controller: emergencyNameController,
                      hintText: "Emergency Contact Name",
                      icon: Icons.person),
                  const SizedBox(height: 25),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 200,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromRGBO(232, 241, 255, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(180, 200, 255, 1),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: (_selectedSignatureImage == null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  netSignImg!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  _selectedSignatureImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                      ),
                      GestureDetector(
                        onTap: () => _selectImage(false),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(22, 127, 113, 1),
                          ),
                          child: const Icon(
                            Icons.edit_note_rounded,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          // The loading blur effect
          if (_isLoding)
            Positioned.fill(
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: SwipeButton(
        thumb: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.black,
        ),
        activeThumbColor: Colors.white,
        activeTrackColor: const Color.fromRGBO(9, 97, 245, 1),
        height: 60,
        width: 350,
        onSwipe: _register, // Call the register function to start loading
        child: Text(
          "Update",
          style: GoogleFonts.mulish(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
