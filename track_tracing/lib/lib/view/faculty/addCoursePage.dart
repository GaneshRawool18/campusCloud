import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:track_tracing/controller/faculty/courseController.dart';
import 'package:track_tracing/controller/student/firebasebucket.dart';
import 'package:track_tracing/controller/student/sqfliteController.dart';
import 'package:track_tracing/model/faculty/addCourseModal.dart';
import 'package:track_tracing/view/faculty/CoursePage.dart';
import 'package:track_tracing/view/faculty/HomePage.dart';
import 'package:track_tracing/view/faculty/manageCourses.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  TextEditingController courseNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController courseCodeController = TextEditingController();
  String? selectedSemester;
  String? selectedDepartment;
  File? _pickedProfileImage;

  List<String> semesters = [];
  List<String> department = [];
  List<Map<String, dynamic>> fetchedData = [];

  @override
  void initState() {
    super.initState();
    if (editableCourseData.isNotEmpty) {
      courseNameController.text = editableCourseData['courseName'];
      descriptionController.text = editableCourseData['courseDescription'];
      dataController.text = editableCourseData['courseDate'];
      courseCodeController.text = editableCourseData['courseCode'];
      selectedDepartment = editableCourseData['department'];
      selectedSemester = editableCourseData['semester'];
      setState(() {});
    }
    _fetchDocs();
  }

  _fetchDocs() async {
    await FacultyCourseController().fetchDeptWithSem().then((dept) {
      fetchedData.addAll(dept);
    });
    for (var i in fetchedData) {
      department.add(i['departmentName']);
    }
  }

  void _setCourseCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random rnd = Random();
    String code =
        List.generate(6, (index) => chars[rnd.nextInt(chars.length)]).join();
    setState(() {
      courseCodeController.text = code;
    });
  }

  void _updateCourse() async {
    try {
      if (courseNameController.text.trim().isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          dataController.text.trim().isNotEmpty &&
          courseCodeController.text.trim().isNotEmpty &&
          selectedDepartment!.isNotEmpty &&
          selectedDepartment!.isNotEmpty) {}
      FacultyCourseController()
          .updateCourse(AddCourse(
                  courseName: courseNameController.text,
                  courseCode: courseCodeController.text,
                  courseDescription: descriptionController.text,
                  courseDate: dataController.text,
                  department: selectedDepartment,
                  semester: selectedSemester,
                  facultyName: facutlyProfileData['facultyName'],
                  image: (_pickedProfileImage != null)
                      ? await FirebaseBucket().uploadFile("CourseImage",
                          courseNameController.text, _pickedProfileImage!)
                      : editableCourseData['images'])
              .toMap())
          .then((isSuccss) {
        if (isSuccss) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Course Updated Successfully",
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to update course",
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      courseCodeController.clear();
      courseNameController.clear();
      descriptionController.clear();
      dataController.clear();
      setState(() {
        _pickedProfileImage = null;
        selectedDepartment = null;
        selectedSemester = null;
      });

      editableCourseData.clear();
    } catch (e) {
      print("Error while updating course: $e");
    }
  }

  void _createCourse() async {
    try {
      if (courseNameController.text.trim().isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          dataController.text.trim().isNotEmpty &&
          courseCodeController.text.trim().isNotEmpty &&
          selectedDepartment!.isNotEmpty &&
          selectedDepartment!.isNotEmpty &&
          _pickedProfileImage != null) {}
      FacultyCourseController().addCourseByFaculty(AddCourse(
              courseName: courseNameController.text,
              courseCode: courseCodeController.text,
              courseDescription: descriptionController.text,
              courseDate: dataController.text,
              department: selectedDepartment,
              semester: selectedSemester,
              facultyName: facutlyProfileData['facultyName'],
              image: await FirebaseBucket().uploadFile("CourseImage",
                  courseNameController.text, _pickedProfileImage!))
          .toMap());

      courseCodeController.clear();
      courseNameController.clear();
      descriptionController.clear();
      dataController.clear();
      setState(() {
        _pickedProfileImage = null;
        selectedDepartment = null;
        selectedSemester = null;
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const FacultyHomePage()));
    } catch (e) {
      print("Error while adding course: $e");
    }
  }

  void showMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Error',
                style: GoogleFonts.mulish(
                    fontSize: 25, fontWeight: FontWeight.bold)),
            content: Text('All fields are required to proceed.',
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
    FilePickerResult? selectedProfileImage =
        await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    setState(() {
      _pickedProfileImage = File(selectedProfileImage!.files.first.path!);
    });
  }

  void selectDate() async {
    DateTime? date = await showDatePicker(
        context: context, firstDate: DateTime(1930), lastDate: DateTime(2028));
    String formatedDate = DateFormat.yMMMEd().format(date!);
    setState(() {
      dataController.text = formatedDate;
    });
  }

  Widget _dropDownBox({
    required BuildContext context,
    required String forWhat,
    required List<String> list,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton2<String>(
            underline: const SizedBox.shrink(),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Color.fromRGBO(255, 255, 255, 1),
                size: 24,
              ),
            ),
            buttonStyleData: ButtonStyleData(
              height: 48,
              width: MediaQuery.of(context).size.width - 250,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(32, 34, 68, 1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(32, 34, 68, 1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            value: selectedValue,
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.mulish(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            hint: Text(
              forWhat,
              style: GoogleFonts.mulish(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          title: Text(
            "Create Course",
            style: GoogleFonts.jost(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    facutlyProfileData['facultyName'] ?? "Faculty Name",
                    style: GoogleFonts.jost(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: const Color.fromRGBO(22, 127, 113, 1),
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: (editableCourseData.isNotEmpty)
                                  ? Image.network(
                                      editableCourseData['images'],
                                      fit: BoxFit.cover,
                                    )
                                  : (_pickedProfileImage == null)
                                      ? Image.network(
                                          "https://images.squarespace-cdn.com/content/v1/5f57c8da5b4e905978984460/5bf55f3d-42ad-466b-b279-8b406d512cd9/Exams.jpeg",
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
                    const SizedBox(width: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 250,
                      child: Column(
                        children: [
                          _dropDownBox(
                            context: context,
                            forWhat: 'Department',
                            list: department,
                            selectedValue: (editableCourseData.isNotEmpty &&
                                    editableCourseData['department'] != null)
                                ? editableCourseData['department']
                                : selectedDepartment,
                            onChanged: (String? newDepartment) {
                              setState(() {
                                selectedDepartment = newDepartment;
                                for (var i in fetchedData) {
                                  if (i['departmentName'] == newDepartment) {
                                    semesters.clear();
                                    semesters.addAll(i['semesters']);
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 50),
                          _dropDownBox(
                            context: context,
                            forWhat: 'Semester',
                            list: semesters,
                            selectedValue: (editableCourseData.isNotEmpty &&
                                    editableCourseData['semester'] != null)
                                ? editableCourseData['semester']
                                : selectedSemester,
                            onChanged: (String? newSemester) {
                              setState(() {
                                selectedSemester = newSemester;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                _buildTextField(
                    controller: courseNameController,
                    hintText: 'Course Name',
                    icon: Icons.insert_drive_file_sharp),
                const SizedBox(height: 25),
                _buildTextField(
                    controller: descriptionController,
                    hintText: 'Course Description',
                    icon: Icons.library_books),
                const SizedBox(height: 25),
                _buildTextField(
                    controller: dataController,
                    hintText: 'Course Start Date',
                    fun: selectDate,
                    icon: Icons.date_range),
                const SizedBox(height: 25),
                _buildTextField(
                    controller: courseCodeController,
                    hintText: 'Course Code',
                    icon: Icons.code,
                    fun: _setCourseCode,
                    suffixIcon: const Icon(Icons.autorenew)),
                const SizedBox(height: 35),
                SwipeButton(
                  width: 230,
                  thumbPadding: const EdgeInsets.all(8),
                  thumb: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.black,
                  ),
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color.fromRGBO(9, 97, 245, 1),
                  height: 60,
                  onSwipe: (editableCourseData.isNotEmpty)
                      ? _updateCourse
                      : _createCourse,
                  child: Text(
                    (editableCourseData.isNotEmpty) ? "Update " : "Create ",
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    Function? fun,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      onTap: () {
        if (fun != null) {
          fun();
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        suffixIcon: IconButton(
          icon: (suffixIcon != null)
              ? suffixIcon
              : const Icon(
                  Icons.clear,
                  color: Colors.transparent,
                ),
          onPressed: () {
            fun!();
          },
        ),
        prefixIcon: Icon(
          icon,
          color: const Color.fromRGBO(9, 97, 245, 1),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: GoogleFonts.mulish(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
