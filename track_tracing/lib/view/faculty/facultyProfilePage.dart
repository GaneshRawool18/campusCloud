import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/authservice.dart';
import 'package:track_tracing/controller/student/sharedPreference.dart';
import 'package:track_tracing/view/faculty/CoursePage.dart';
import 'package:track_tracing/view/student/Login/signinPage.dart';

class FacultyProfilePage extends StatefulWidget {
  const FacultyProfilePage({super.key});

  @override
  _FacultyProfilePageState createState() => _FacultyProfilePageState();
}

class _FacultyProfilePageState extends State<FacultyProfilePage> {
  bool _isEditing = false;
  final TextEditingController _nameController =
      TextEditingController(text: facutlyProfileData["facultyName"]);
  final TextEditingController _bioController =
      TextEditingController(text: facutlyProfileData["bioGraphy"]);
  final TextEditingController _phoneController =
      TextEditingController(text: facutlyProfileData["contact"]);
  final TextEditingController _linkedInController =
      TextEditingController(text: facutlyProfileData["socialLinks"][1]);
  final TextEditingController _facebookCotroller =
      TextEditingController(text: facutlyProfileData["socialLinks"][0]);
  final TextEditingController _twitterController =
      TextEditingController(text: facutlyProfileData["socialLinks"][2]);
  final TextEditingController _educationController =
      TextEditingController(text: facutlyProfileData["education"]);
  final TextEditingController _subjectsTaughtController =
      TextEditingController(text: "Data Structures, Algorithms, AI");

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _linkedInController.dispose();
    _twitterController.dispose();
    _educationController.dispose();
    _subjectsTaughtController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.jost(fontSize: 16, color: Colors.grey[700]),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _logoutFaculty() {
    SharedPreferenceController.setData(isLogin: false, studentID: "");
    Authservice().signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Signinpage()),
      (route) => false,
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: _logoutFaculty,
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Faculty Profile",
          style: GoogleFonts.jost(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutConfirmationDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Profile Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        facutlyProfileData["profileImgUrl"],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name and Phone
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isEditing
                              ? _buildTextField(
                                  label: "Faculty name",
                                  controller: _nameController)
                              : Text(
                                  _nameController.text,
                                  style: GoogleFonts.jost(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                          const SizedBox(height: 8),
                          _isEditing
                              ? _buildTextField(
                                  label: "Contact",
                                  controller: _phoneController)
                              : Text(
                                  _phoneController.text,
                                  style: GoogleFonts.jost(
                                      fontSize: 16, color: Colors.grey[600]),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Biography Section
            Text("Biography",
                style: GoogleFonts.jost(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _isEditing
                ? _buildTextField(
                    label: "Biography", controller: _bioController, maxLines: 4)
                : Text(
                    _bioController.text,
                    style:
                        GoogleFonts.jost(fontSize: 16, color: Colors.grey[700]),
                  ),
            const SizedBox(height: 20),

            // Education Section
            Text("Education",
                style: GoogleFonts.jost(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _isEditing
                ? _buildTextField(
                    label: "Education", controller: _educationController)
                : Text(
                    _educationController.text,
                    style:
                        GoogleFonts.jost(fontSize: 16, color: Colors.grey[700]),
                  ),
            const SizedBox(height: 20),

            // Subjects Taught Section
            Text("Subjects Taught",
                style: GoogleFonts.jost(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _isEditing
                ? _buildTextField(
                    label: "Subjects Taught",
                    controller: _subjectsTaughtController)
                : Text(
                    _subjectsTaughtController.text,
                    style:
                        GoogleFonts.jost(fontSize: 16, color: Colors.grey[700]),
                  ),
            const SizedBox(height: 20),

            // Social Links Section
            if (_isEditing) ...[
              Text("Social Links",
                  style: GoogleFonts.jost(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(
                  label: "Instagram", controller: _facebookCotroller),
              const SizedBox(height: 10),
              _buildTextField(
                  label: "LinkedIn", controller: _linkedInController),
              const SizedBox(height: 10),
              _buildTextField(label: "Twitter", controller: _twitterController),
            ] else ...[
              // Display icons and links when not editing
              Text("Social Links",
                  style: GoogleFonts.jost(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: () {
                      // Open LinkedIn
                      launchURL(_linkedInController.text);
                    },
                  ),
                  Text(
                    "LinkedIn",
                    style: GoogleFonts.jost(fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: () {
                      // Open Twitter
                      launchURL(_twitterController.text);
                    },
                  ),
                  Text(
                    "Twitter",
                    style: GoogleFonts.jost(fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: () {
                      // Open Twitter
                      launchURL(_facebookCotroller.text);
                    },
                  ),
                  Text(
                    "Instagram",
                    style: GoogleFonts.jost(fontSize: 16),
                  ),
                ],
              ),
            ],

            // Edit Button
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: Text(_isEditing ? "Save Changes" : "Edit Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch URL
  void launchURL(String url) {
    // Here you can use any method to launch the URL, e.g., using url_launcher package
    // e.g., launch(url);
    print("Launching URL: $url"); // Placeholder for actual URL launching logic
  }
}
