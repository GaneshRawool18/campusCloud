import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:track_tracing/controller/student/courseFIrestoreController.dart';
import 'package:track_tracing/controller/student/firebasebucket.dart';
import 'package:track_tracing/controller/student/studentController.dart';
import 'package:url_launcher/url_launcher.dart';

class Uploadpage extends StatefulWidget {
  final String? topic;
  final String? subTopic;
  const Uploadpage({super.key, this.topic, this.subTopic});

  @override
  State<Uploadpage> createState() => _UploadpageState();
}

class _UploadpageState extends State<Uploadpage> {
  final TextEditingController _fileController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  FilePickerResult? pickedFile;
  bool isLoding = false;
  String? fileName;
  File? file;
  String? downloadLink = "";
  String? uniqueName;
  Map<String, dynamic> description = {};
  Map<String, dynamic> submittedLinkInfo = {};
  @override
  void initState() {
    super.initState();
    _checkAlreadySubmittedOrNot();
  }

  void _checkAlreadySubmittedOrNot() async {
    submittedLinkInfo.clear();
    await CourseController()
        .checkAlreadySubmittedOrNot(widget.topic!, widget.subTopic!)
        .then((value) {
      submittedLinkInfo.addAll(value);
    });
    log("SubmittedLinkInfo: $submittedLinkInfo");
    setState(() {});
  }

  void _viewFile(String? url) async {
    if (url != null) {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'zip', 'doc', 'docx', 'ppt', 'pptx'],
      );
    } catch (e) {
      print(e);
    }

    if (pickedFile != null) {
      fileName = pickedFile!.files.first.name;
      file = File(pickedFile!.files.first.path!);
      _fileController.text = fileName!;
    }
    setState(() {});
  }

  String? _createUniqueFileName() {
    log("---------${uniqueName}");
    if (pickedFile != null) {
      String extension = fileName!.split('.').last;
      String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
      uniqueName = '${fileName!.split('.').first}_$uniqueId.$extension';
      return uniqueName!;
    }
    return null;
  }

  void _downloadFile() async {
    Uri _url = Uri.parse((submittedLinkInfo.isEmpty)
        ? downloadLink!
        : submittedLinkInfo["submittedLink"]);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _submit() async {
    try {
      setState(() {
        isLoding = true;
      });

      // Ensure that file and fileName are provided
      if (file == null || fileName!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "File or filename cannot be empty",
            style: GoogleFonts.mulish(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        setState(() {
          isLoding = false;
        });
        return;
      }

      // Get current date and deadline from CourseController
      DateTime currentDate = DateTime.now();
      log("Current Date: $currentDate");
      String? deadline = CourseController.subTopicInfo["deadline"];

      if (deadline == null || deadline.isEmpty) {
        // Handle case where deadline is not provided
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Deadline not provided",
            style: GoogleFonts.mulish(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        setState(() {
          isLoding = false;
        });
        return;
      }

      // Parse the deadline string to DateTime
      DateTime deadlineDate;
      try {
        deadlineDate = DateFormat("EEE, MMM d, yyyy").parse(deadline);
        log("Deadline Date: $deadlineDate");
      } catch (e) {
        // Invalid deadline format handling
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Invalid deadline format",
            style: GoogleFonts.mulish(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        setState(() {
          isLoding = false;
        });
        return;
      }

      // Check if current date is after the deadline
      if (currentDate.isAfter(deadlineDate)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Assignment submission time is over",
            style: GoogleFonts.mulish(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
        ));
        setState(() {
          isLoding = false;
        });
        return;
      }

      await FirebaseBucket()
          .uploadFile("Assignments", fileName!, file!)
          .then((value) {
        downloadLink = value;
        log("Download link: $downloadLink");
      });

      // Submit the assignment
      CourseController().submitAssignment(widget.topic!, widget.subTopic!, {
        "answerText":
            answerController.text.isNotEmpty ? answerController.text : "",
        "submittedLink": downloadLink,
        "name": fileName,
        "marks": "0",
      });

      setState(() {
        _createUniqueFileName();
        log("---------${uniqueName}");

        isLoding = false;
      });

      // Clear the file controller
      _fileController.clear();
    } catch (e) {
      log("Failed to submit assignment: $e");
      setState(() {
        isLoding = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed to submit assignment. Please try again.",
          style: GoogleFonts.mulish(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
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
              width: 10,
            ),
            Text(
              "Upload your pickedFile",
              style:
                  GoogleFonts.mulish(fontSize: 18, fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text(
                    "DueDate :${CourseController.subTopicInfo["deadline"]}",
                    style: GoogleFonts.mulish(
                        color: const Color.fromRGBO(9, 97, 245, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Que: ${CourseController.subTopicInfo["subTopicName"]}",
                style: GoogleFonts.mulish(
                    fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(CourseController.subTopicInfo["description"],
                  style: GoogleFonts.mulish(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                          CourseController.subTopicInfo["attachedFileName"])),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _viewFile(
                          CourseController.subTopicInfo["attachedFileUrl"]);
                    },
                    child: const Icon(
                      Icons.visibility,
                      color: Color.fromRGBO(9, 97, 245, 1),
                    ),
                  )
                ],
              ),
              TextField(
                onTap: () async {
                  await _pickFile();
                },
                controller: _fileController,
                style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w700, fontSize: 17),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Choose your file",
                    hintStyle: GoogleFonts.mulish(
                        fontWeight: FontWeight.w700, fontSize: 17),
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 1),
                    suffixIcon: const Icon(Icons.cloud_upload_outlined),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 0.025,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.025),
                        borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLength: 1000,
                maxLines: 8,
                minLines: 1,
                controller: answerController,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: "Answer",
                  hintStyle: GoogleFonts.mulish(
                      fontWeight: FontWeight.w700, fontSize: 17),
                ),
              ),
              GestureDetector(
                onTap: _downloadFile,
                child: Text(
                  (submittedLinkInfo.isEmpty)
                      ? (uniqueName ?? "")
                      : submittedLinkInfo['name'],
                  style: GoogleFonts.mulish(
                      color: const Color.fromRGBO(9, 97, 245, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  GestureDetector(
                    onTap: () async {
                      await _submit();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(9, 97, 245, 1),
                          borderRadius: BorderRadius.circular(30)),
                      child: isLoding
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Submit",
                              style: GoogleFonts.jost(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
