import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:track_tracing/controller/faculty/courseContentControlller.dart';
import 'package:track_tracing/controller/student/firebasebucket.dart';
import 'package:track_tracing/model/faculty/newAssignmentModel.dart';
import 'package:track_tracing/view/faculty/courseNavigationPage.dart';
import 'package:track_tracing/view/faculty/evaluationPage.dart';

class CourseContentPage extends StatefulWidget {
  const CourseContentPage({super.key});

  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  String? selectedTopicForSort;
  String? selectedValue;
  List<dynamic> topics = [];
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _assignmentNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  File? _pickedAttachment;
  String? _pickedAttachmentName;
  List<Map<String, dynamic>> assignments = [];
  bool isLoading = false;

  void _updateDate(String date, int index) {
    CourseContentController()
        .updateDueDate(
            facultySelectedDept,
            facultySelectedSem,
            facultySelectedCourse,
            assignments[index]["topicName"],
            assignments[index]["assignmentName"],
            date)
        .then((isSucess) {
      if (isSucess) {
        if (date != assignments[index]["deadline"]) {
          setState(() {
            assignments[index]["deadline"] = date;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Deadline Updated Successfully",
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Failed to update deadline",
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  void _updateAttachment(int index) async {
    FilePickerResult? selectedProfileImage =
        await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    setState(() {
      _pickedAttachment = File(selectedProfileImage!.files.first.path!);
      _pickedAttachmentName = selectedProfileImage.files.first.name;
    });
    CourseContentController()
        .updateAttachmentAndName(
            facultySelectedDept,
            facultySelectedSem,
            facultySelectedCourse,
            assignments[index]["topicName"],
            assignments[index]["assignmentName"],
            _pickedAttachmentName,
            await FirebaseBucket().uploadFile(
                "AttachedFiles", _pickedAttachmentName!, _pickedAttachment!))
        .then((isSucess) {
      if (isSucess) {
        if (_pickedAttachmentName != assignments[index]["attachedFileName"]) {
          setState(() {
            assignments[index]["attachedFileName"] = _pickedAttachmentName;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Attachment Updated Successfully",
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Failed to update attachment",
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ));
      }
      Navigator.of(context).pop();
    });
  }

  void _createAssignment() async {
    try {
      if ((_topicController.text.isNotEmpty || selectedValue != null) &&
          _assignmentNameController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          _dueDateController.text.isNotEmpty &&
          _pickedAttachment != null) {
        await CourseContentController()
            .addNewAssignment(
          facultySelectedDept,
          facultySelectedSem,
          facultySelectedCourse,
          NewAssignemntModel(
            topicName: (_topicController.text.isNotEmpty)
                ? _topicController.text
                : selectedValue,
            assignmentName: _assignmentNameController.text,
            description: _descriptionController.text,
            deadline: _dueDateController.text,
            attachedFileName: _pickedAttachmentName,
            attachedFileUrl: await FirebaseBucket().uploadFile(
                "AttachedFiles", _pickedAttachmentName!, _pickedAttachment!),
          ).toMap(),
        )
            .then((isSucss) {
          if (isSucss) {
            _fetchAllAssignemnts();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Assignment Created Successfully",
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Failed to create assignment",
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red,
            ));
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Please fill all the fields",
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
        ));
      }
      setState(() {
        _topicController.clear();
        _assignmentNameController.clear();
        _descriptionController.clear();
        _dueDateController.clear();
        _pickedAttachment = null;
        _pickedAttachmentName = null;
      });
    } catch (e) {
      log("Error in _createAssignment: $e");
    }
    Navigator.of(context).pop();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Ensures the bottom sheet adjusts for the keyboard
      builder: (BuildContext context) {
        // Local variables for state
        String? localSelectedValue = selectedValue;
        String? localPickedAttachmentName = _pickedAttachmentName;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Add New Assignment",
                        style: GoogleFonts.jost(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(9, 97, 245, 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Select Topic:",
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    getDropDownBox(
                      selectedVal: localSelectedValue,
                      onChanged: (String? value) {
                        setModalState(() {
                          localSelectedValue = value; // Update local state
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Enter New Topic:",
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _topicController,
                        decoration: const InputDecoration(
                          hintText: "Enter topic name (optional)",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Assignment Name:",
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _assignmentNameController,
                        decoration: const InputDecoration(
                          hintText: "Enter assignment name",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Description:",
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: "Provide a brief description",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Due Date:",
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1930),
                            lastDate: DateTime(2028),
                          );
                          String formatedDate =
                              DateFormat.yMMMEd().format(date!);
                          setState(() {
                            _dueDateController.text = formatedDate;
                          });
                        },
                        controller: _dueDateController,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today_rounded),
                          hintText: "Select due date",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      (_pickedAttachmentName != null)
                          ? "Selected Attachment: $_pickedAttachmentName"
                          : "Attach Files (Optional):",
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? selectedProfileImage =
                            await FilePicker.platform.pickFiles(
                          type: FileType.any,
                        );

                        if (selectedProfileImage != null) {
                          setModalState(() {
                            localPickedAttachmentName =
                                selectedProfileImage.files.first.name;
                          });
                          setState(() {
                            _pickedAttachmentName =
                                selectedProfileImage.files.first.name;
                            _pickedAttachment =
                                File(selectedProfileImage.files.first.path!);
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(9, 97, 245, 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.attach_file, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              "Choose File",
                              style: GoogleFonts.mulish(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedValue = localSelectedValue;
                            _pickedAttachmentName = localPickedAttachmentName;
                            _createAssignment();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Create Assignment",
                          style: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
      },
    );
  }

  Widget getDropDownBox({
    required String? selectedVal,
    required ValueChanged<String?> onChanged,
  }) {
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
        width: MediaQuery.of(context).size.width - 190,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
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
      value: selectedVal,
      items: topics.map<DropdownMenuItem<String>>((dynamic value) {
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
        "Select Topic",
        style: GoogleFonts.mulish(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  void _showCustomDialogBox(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        log("Index: ${assignments[index]["attachedFileName"]}");
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text('Upload Attachment',
              style:
                  GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.w500)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          "Selectd File:${(assignments[index]["attachedFileName"] != null) ? assignments[index]["attachedFileName"] : "Select File"}",
                          style: GoogleFonts.jost(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _updateAttachment(index),
                icon: const Icon(Icons.attach_file, color: Colors.white),
                label: Text(
                  (assignments[index]["attachedFileName"] != null)
                      ? "Update"
                      : "Upload",
                  style: GoogleFonts.jost(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    const Color.fromRGBO(9, 97, 245, 1)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: GoogleFonts.jost(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDescriptionDialogBox(BuildContext context, int index) {
    TextEditingController descController = TextEditingController();
    descController.text = assignments[index]["description"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text('Edit Description',
              style:
                  GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.w500)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Enter description here...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    const Color.fromRGBO(9, 97, 245, 1)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: () {
                CourseContentController()
                    .updateDescription(
                        facultySelectedDept,
                        facultySelectedSem,
                        facultySelectedCourse,
                        assignments[index]["topicName"],
                        assignments[index]["assignmentName"],
                        descController.text)
                    .then((isSucess) {
                  if (isSucess) {
                    if (descController.text !=
                        assignments[index]["description"]) {
                      setState(() {
                        assignments[index]["description"] = descController.text;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Description Updated Successfully",
                        style: GoogleFonts.mulish(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Failed to update description",
                        style: GoogleFonts.mulish(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                  Navigator.of(context).pop();
                });
              },
              child: Text(
                "Update",
                style: GoogleFonts.jost(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    const Color.fromRGBO(9, 97, 245, 1)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: GoogleFonts.jost(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAllAssignemnts();
  }

  void _fetchAllAssignemnts() async {
    setState(() {
      isLoading = true;
    });
    assignments.clear();
    topics.clear();
    await CourseContentController()
        .fetchTopicsList(
            facultySelectedDept, facultySelectedSem, facultySelectedCourse)
        .then((value) {
      topics.addAll(value);
    });
    await CourseContentController()
        .fetchAllAssignments(
            facultySelectedDept, facultySelectedSem, facultySelectedCourse)
        .then((value) {
      assignments.addAll(value);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _fetchAllAssignemnts,
                  child: Text(
                    "Sort By",
                    style: GoogleFonts.jost(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                FittedBox(
                  child: getDropDownBox(
                    selectedVal: selectedTopicForSort,
                    onChanged: (String? value) {
                      setState(() {
                        selectedTopicForSort = value;
                        assignments.sort((a, b) {
                          if (a["topicName"] == value) {
                            return -1;
                          } else {
                            return 1;
                          }
                        });
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            indent: 100,
            endIndent: 100,
            thickness: 2,
          ),
          Expanded(
            child: (isLoading)
                ? Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                        color: Colors.blueAccent, size: 50),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width - 40,
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(9, 97, 245, 1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () =>
                                              _showConfirmationDialog(
                                                  context, index),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                                255, 244, 120, 54),
                                          )),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.blueAccent,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                        ),
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            right: 10,
                                            left: 10),
                                        child: Text(
                                          assignments[index]["topicName"],
                                          style: GoogleFonts.mulish(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Que : ${assignments[index]["assignmentName"]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.attachment_rounded,
                                          color: Color.fromRGBO(9, 97, 245, 1)),
                                      onPressed: () {
                                        _showCustomDialogBox(context, index);
                                      },
                                    ),
                                    Text(
                                      "Attachments",
                                      style: GoogleFonts.mulish(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.description,
                                          color: Color.fromRGBO(9, 97, 245, 1)),
                                      onPressed: () {
                                        _showDescriptionDialogBox(
                                            context, index);
                                      },
                                    ),
                                    Text(
                                      "Description",
                                      style: GoogleFonts.mulish(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.date_range,
                                          color: Color.fromRGBO(9, 97, 245, 1)),
                                      onPressed: () async {
                                        DateTime? date = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1930),
                                            lastDate: DateTime(2028));
                                        String formatedDate =
                                            DateFormat.yMMMEd().format(date!);

                                        _updateDate(formatedDate, index);
                                      },
                                    ),
                                    Text(
                                      assignments[index]["deadline"],
                                      style: GoogleFonts.mulish(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.person_3,
                                          color: Color.fromRGBO(9, 97, 245, 1)),
                                      onPressed: () {
                                        log(assignments[index]
                                            ["assignmentName"]);
                                        log(assignments[index]["topicName"]);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EvaluationPage(
                                                      facultySelectedAssignment:
                                                          assignments[index][
                                                                  "assignmentName"]
                                                              .toString(),
                                                      facultySelectedTopic:
                                                          assignments[index]
                                                                  ["topicName"]
                                                              .toString(),
                                                    )));
                                      },
                                    ),
                                    Text(
                                      "Evalaute",
                                      style: GoogleFonts.mulish(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[50], // Background color of the dialog
          title: Text(
            'Confirm Deletion',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900], // Title text color
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this assignment? This action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87, // Content text color
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
                print('Assignment not deleted.');
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue, // Cancel button text color
                  fontSize: 16,
                ),
              ),
            ),
            // Confirm Button
            TextButton(
              onPressed: () {
                CourseContentController()
                    .deleteAssignment(
                        facultySelectedDept,
                        facultySelectedSem,
                        facultySelectedCourse,
                        assignments[index]["topicName"],
                        assignments[index]["assignmentName"])
                    .then((isSucess) {
                  if (isSucess) {
                    setState(() {
                      _fetchAllAssignemnts();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Assignment Deleted Successfully",
                        style: GoogleFonts.mulish(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Failed to delete assignment",
                        style: GoogleFonts.mulish(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                });

                Navigator.of(context).pop(); // Close the dialog with action
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red, // Confirm button text color
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
