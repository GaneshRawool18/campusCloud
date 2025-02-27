import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:track_tracing/controller/student/firebasebucket.dart';
import 'package:track_tracing/controller/student/firestoreAdminController.dart';
import 'package:track_tracing/controller/student/studentController.dart';
import 'package:track_tracing/model/student/registrationModal.dart';
import 'package:track_tracing/view/student/Login/launchPage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController emergencyNumController = TextEditingController();
  TextEditingController emergencyNameController = TextEditingController();
  String? selectedDepartment;
  File? _pickedProfileImage;
  String? profileFileName;
  File? _selectedSignatureImage;
  String? signatureFileName;
  RegistrationModel? registerStudent;
  final FirebaseBucket _bucket = FirebaseBucket();
  final FirebaseAdminController _database = FirebaseAdminController();
  List<String> departments = [];

  void _register() async {
    if (_pickedProfileImage != null &&
        profileFileName != null &&
        nameController.text.trim().isNotEmpty &&
        contactController.text.trim().isNotEmpty &&
        dobController.text.trim().isNotEmpty &&
        bloodGroupController.text.trim().isNotEmpty &&
        emergencyNameController.text.trim().isNotEmpty &&
        emergencyNumController.text.trim().isNotEmpty &&
        _selectedSignatureImage != null &&
        signatureFileName != null) {
      _sendRequestToAdmin();
    } else {
      _showMessage("All fields are recquired");
    }
  }

  void _sendRequestToAdmin() async {
    String who = "AdminNotifications";
    String formatedDateTime = DateFormat.yMMMEd().format(DateTime.now());
    String time = DateFormat('HH:mm a').format(DateTime.now());
    bool isDone = await _database.sendRequestToAdminForRegistration(
        formatedDateTime,
        time,
        who,
        RegistrationModel(
                profileUrl: await _bucket.uploadFile(
                    "profileImage", profileFileName!, _pickedProfileImage!),
                name: nameController.text,
                contact: contactController.text,
                dob: dobController.text,
                bloodGroup: bloodGroupController.text,
                department: selectedDepartment!,
                emergencyContactName: emergencyNameController.text,
                emergencyContactNo: emergencyNumController.text,
                signatureUrl: await _bucket.uploadFile("signatureImage",
                    signatureFileName!, _selectedSignatureImage!))
            .toMap());
    if (isDone) {
      _registerSucessfully();
    } else {
      _showMessage("Registration failed");
    }
  }

  void _registerSucessfully() {
    nameController.clear();
    contactController.clear();
    bloodGroupController.clear();
    dobController.clear();
    emergencyNameController.clear();
    emergencyNumController.clear();
    selectedDepartment = "";
    _pickedProfileImage = null;
    _selectedSignatureImage = null;

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Launchpage()));
  }

  Widget _fetchDropdownButton(
      {required BuildContext context,
      required String title,
      String? selectedValue,
      required List<String> items,
      required Function(String?) onChanged}) {
    return DropdownButton2<String>(
      underline: const SizedBox.shrink(),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
          size: 24,
        ),
      ),
      buttonStyleData: ButtonStyleData(
        height: 48,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(18, 31, 189, 241),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
      value: selectedValue,
      items: items.map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem(
          value: value,
          child: Text(
            value,
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      hint: Text(
        "Select $title",
        style: GoogleFonts.mulish(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
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
        context: context, firstDate: DateTime(1970), lastDate: DateTime(2080));
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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onTap: onTap,
        readOnly: readOnly,
        style: GoogleFonts.mulish(
            fontWeight: FontWeight.w700, fontSize: 17, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.mulish(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
          prefixIcon: Icon(icon, color: Colors.grey.shade700),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchDepartment();
  }

  void _fetchDepartment() async {
    await Studentcontroller().fetchDept().then((value) {
      setState(() {
        departments = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Fill your profile",
                style: GoogleFonts.jost(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(32, 34, 68, 1),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
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
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(232, 241, 255, 1)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: (_pickedProfileImage == null)
                              ? Image.network(
                                  "https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg",
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  _pickedProfileImage!,
                                  fit: BoxFit.fill,
                                )),
                    ),
                    GestureDetector(
                      onTap: _selectImage,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(22, 127, 113, 1)),
                        child: const Icon(
                          Icons.edit_note_rounded,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
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
                _fetchDropdownButton(
                    context: context,
                    title: "Department",
                    selectedValue: selectedDepartment,
                    items: departments,
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value;
                      });
                    }),
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
                const SizedBox(
                  height: 25,
                ),
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
                          color: const Color.fromRGBO(
                              180, 200, 255, 1), // Light border color
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
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  color:  Color.fromRGBO(32, 34, 68, 0.6),
                                  size: 24,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Image must have 1:2 ratio",
                                  style: GoogleFonts.jost(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(32, 34, 68, 1),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _selectedSignatureImage!,
                                fit: BoxFit.cover,
                                width: double
                                    .infinity, // Ensure the image fills the container
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
                            color: Color.fromRGBO(22, 127, 113, 1)),
                        child: const Icon(
                          Icons.edit_note_rounded,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
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
          onSwipe: _register,
          child: Text(
            "Register",
            style: GoogleFonts.mulish(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Colors.white,
            ),
          ), // Calls your registration function on swipe
        ));
  }
} 