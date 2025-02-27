import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'StudentManagement.dart';
import 'StudentModel.dart';

class StudentInfoCard extends StatefulWidget {
  int index;
  StudentInfoCard({super.key, required this.index});

  @override
  State<StudentInfoCard> createState() => _StudentInfoCardState();
}

class _StudentInfoCardState extends State<StudentInfoCard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _graduateController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _studentIDController = TextEditingController();
  final TextEditingController _registrationDateController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bloodGrpController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emgContactController = TextEditingController();
  final TextEditingController _emgContactNameController =
      TextEditingController();

  int? _index;

  Widget richText(String title, String value) {
    return RichText(
      text: TextSpan(
        text: title,
        style: GoogleFonts.mulish(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.mulish(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: RichText(
        text: TextSpan(
          text: "$label : ",
          style: GoogleFonts.mulish(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
          children: [
            TextSpan(
              text: value,
              style: GoogleFonts.mulish(
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

  Future<void> callStudent(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    await launchUrl(url);
  }

  Future<void> whatsAppStudent(String phoneNumber) async {
    final Uri url = Uri.parse("whatsapp://send?phone=$phoneNumber");
    await launchUrl(url);
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

  List data = [];

  void clearTextFields() {
    _nameController.clear();
    _graduateController.clear();
    _roleController.clear();
    _studentIDController.clear();
    _registrationDateController.clear();
    _dobController.clear();
    _bloodGrpController.clear();
    _specializationController.clear();
    _emailController.clear();
    _emgContactController.clear();
    _emgContactNameController.clear();
  }

  void submit() {
    if (_nameController.text.trim().isNotEmpty &&
        _graduateController.text.trim().isNotEmpty &&
        _roleController.text.trim().isNotEmpty &&
        _studentIDController.text.trim().isNotEmpty &&
        _registrationDateController.text.trim().isNotEmpty &&
        _dobController.text.trim().isNotEmpty &&
        _bloodGrpController.text.trim().isNotEmpty &&
        _specializationController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _emgContactController.text.trim().isNotEmpty &&
        _emgContactNameController.text.trim().isNotEmpty) {
      StudentInfo studentInfo = StudentInfo(
          name: _nameController.text,
          graduate: _graduateController.text,
          role: _roleController.text,
          studentID: _studentIDController.text,
          registrationDate: _registrationDateController.text,
          dateOfBirth: _dobController.text,
          bloodGroup: _bloodGrpController.text,
          specialization: _specializationController.text,
          email: _emailController.text,
          emergencyContactName: _emgContactController.text,
          emergencyContact: _emgContactNameController.text);

      data.add(studentInfo);
      clearTextFields();
      log("${data.length}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student Profile Updated !!"),
          backgroundColor: Colors.black,
        ),
      );

      Navigator.of(context).pop();
      setState(() {});
    }
  }

  Future _studentInfoEditing(BuildContext context) {
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
                      'Student Profile Edit ',
                      style: GoogleFonts.mulish(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                callTextField('Name : ', _nameController),
                const SizedBox(height: 20),
                callTextField('Graduate : ', _graduateController),
                const SizedBox(height: 20),
                callTextField('Role : ', _roleController),
                const SizedBox(height: 20),
                callTextField('Student ID :', _studentIDController),
                const SizedBox(height: 20),
                callTextField(
                    'Registration Date :', _registrationDateController),
                const SizedBox(height: 20),
                callTextField('Date of Birth :', _dobController),
                const SizedBox(height: 20),
                callTextField('Blood Group :', _bloodGrpController),
                const SizedBox(height: 20),
                callTextField('Specialization :', _specializationController),
                const SizedBox(height: 20),
                callTextField('Email :', _emailController),
                const SizedBox(height: 20),
                callTextField(
                    'Emergency Contact Name :', _emgContactNameController),
                const SizedBox(height: 20),
                callTextField('Emergency Contact :', _emgContactController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    submit();
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

  @override
  void initState() {
    super.initState();
    _index = widget.index;
    log(_index.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Profile',
          style: GoogleFonts.mulish(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 84, 178, 254),
        leading: Builder(
          builder: (_) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 35,
            margin: const EdgeInsets.all(10),
            color: const Color.fromARGB(255, 238, 243, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ProfilePhoto
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              NetworkImage(stdList[_index!]["profileUrl"]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          richText('Name: ', stdList[_index!]["name"]),
                          const SizedBox(height: 10),
                          richText('Graduate: ', 'UnderGraduation'),
                          const SizedBox(height: 10),
                          richText('Role: ', 'Student'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Divider
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),

                  // Information Section
                  infoRow("Student ID", stdList[_index!]["StudentID"]),
                  //  infoRow("Registration Date", "08/25/2020"),
                  infoRow("Date of Birth", stdList[_index!]["dob"]),
                  infoRow("Blood Group", stdList[_index!]["bloodGroup"]),
                  infoRow("Specialization", stdList[_index!]["department"]),
                  infoRow("E-mail", stdList[_index!]["email"]),
                  infoRow("Emergency Contact",
                      stdList[_index!]["emergencyContactNo"]),
                  infoRow("Emergency Contact Name",
                      stdList[_index!]["emergencyContactName"]),

                  const SizedBox(height: 20),

                  // Action Buttons (Call, WhatsApp)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.call_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 10,
                        ),
                        onPressed: () {
                          callStudent(stdList[_index!]["contactNo"]);
                        },
                        label: Text(
                          'Call',
                          style: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          size: 20,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 10,
                        ),
                        onPressed: () {
                          whatsAppStudent(stdList[_index!]["contactNo"]);
                        },
                        label: Text(
                          'WhatsApp',
                          style: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Divider
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  //Footer Text
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Terms of Service | Privacy Policy',
                        style: GoogleFonts.mulish(
                            fontSize: 14, color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
