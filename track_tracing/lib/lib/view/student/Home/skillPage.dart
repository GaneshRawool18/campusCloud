import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:track_tracing/controller/student/authservice.dart';
import 'package:track_tracing/controller/student/firebasebucket.dart';
import 'package:track_tracing/controller/student/studentController.dart';
import 'package:track_tracing/model/student/skiillModal.dart';
import 'package:track_tracing/view/student/Home/listofData.dart';
import 'package:url_launcher/url_launcher.dart';

class SkillPage extends StatefulWidget {
  const SkillPage({super.key});

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  String? selectedValue;
  bool isLink = true;
  String? gitLink;
  List<Map<String, dynamic>> skillsList = [];
  TextEditingController linkController = TextEditingController();
  TextEditingController pNameController = TextEditingController();
  List<File> pickedImages = [];
  List<String> pickedImagesname = [];
  List<String> linkOffiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSkillsFromFirebase();
  }

  void _fetchSkillsFromFirebase() async {
    skillsList = [];
    setState(() {
      isLoading = true;
    });
    await Studentcontroller()
        .fetchSkillsData(Authservice.studentID!)
        .then((value) {
      skillsList.addAll(value);
    });
    log("Skiils $skillsList");
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _launchUrl(String url) async {
    Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _pickImages() async {
    FilePickerResult? pickedFile = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    pickedImages = pickedFile!.paths.map((path) => File(path!)).toList();
    pickedImagesname = pickedFile.files.map((file) => file.name).toList();
    _getLinkUrl();

    setState(() {});
  }

  void _getLinkUrl() {
    for (int i = 0; i < pickedImages.length; i++) {
      FirebaseBucket()
          .uploadFile("skillMedia", pickedImagesname[i], pickedImages[i])
          .then((value) {
        linkOffiles.add(value);
      });
    }
  }

  void _addSkill() async {
    if (pNameController.text.trim().isNotEmpty &&
        selectedValue != null &&
        pickedImages.isNotEmpty &&
        gitLink!.isNotEmpty) {
      await Studentcontroller().addSkills(Skills(
              skillName: selectedValue,
              projectName: pNameController.text,
              gitLink: gitLink,
              images: linkOffiles)
          .toMap());
    }
    setState(() {
      _fetchSkillsFromFirebase();
      pNameController.clear();
      linkController.clear();
      pickedImages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Skills",
          style: GoogleFonts.jost(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 249, 255, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select your skill",
                    style: GoogleFonts.jost(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton2<String>(
                    underline: const SizedBox.shrink(),
                    isExpanded: true,
                    value: selectedValue,
                    alignment: AlignmentDirectional.center,
                    hint: Text(
                      "Select topic",
                      style: GoogleFonts.mulish(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromRGBO(32, 34, 68, 1),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      padding: const EdgeInsets.all(10),
                      maxHeight: 300,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(32, 34, 68, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    items: ListData()
                        .skills
                        .map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                          width: 100,
                          child: Text(
                            value,
                            style: GoogleFonts.mulish(
                              fontSize: 15,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (selectedValue == null)
                      ? Text(
                          "Project Name (If any):",
                          style: GoogleFonts.jost(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        )
                      : Text(
                          "Project Name on $selectedValue (If any):",
                          style: GoogleFonts.jost(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: pNameController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Project link and image",
                    style: GoogleFonts.jost(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() {
                                isLink = true;
                              }),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(15),
                                    color: isLink ? Colors.green : Colors.red),
                                child: const Icon(
                                  Icons.link,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                isLink = false;
                              }),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(15),
                                    color: isLink ? Colors.red : Colors.green),
                                child: const Icon(Icons.image,
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isLink) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: 20,
                                          right: 20,
                                          left: 20,
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            child: TextField(
                                              controller: linkController,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "Paste your link here!",
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0.0,
                                                          horizontal: 10.0),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10))),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (linkController.text
                                                    .trim()
                                                    .isNotEmpty) {
                                                  gitLink = linkController.text;
                                                }
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40,
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                color: const Color.fromRGBO(
                                                    9, 97, 245, 1),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                "Submit",
                                                style: GoogleFonts.mulish(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color.fromRGBO(
                                                        255, 255, 255, 1)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              _pickImages();
                            }
                          },
                          child: Container(
                            width: 240,
                            height: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(15)),
                            child: (isLink)
                                ? (gitLink != null)
                                    ? Text(gitLink!,
                                        style: GoogleFonts.mulish(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline))
                                    : Text("Upload git link",
                                        style: GoogleFonts.mulish(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline))
                                : (pickedImages.isNotEmpty)
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: pickedImages.length,
                                        itemBuilder: (context, imageIndex) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.file(
                                                pickedImages[imageIndex],
                                                height: 120,
                                                width: 120,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Text("Upload screenshots",
                                        style: GoogleFonts.mulish(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline)),
                          ),
                        ),
                      ],
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
                        onTap: () => _addSkill(),
                        child: Container(
                          width: 100,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(9, 97, 245, 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Add",
                            style: GoogleFonts.mulish(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    color: Colors.black,
                    child: const SizedBox(),
                  ),
                ],
              ),
            ),
            Text(
              "- Your Skills -",
              style: GoogleFonts.mulish(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(32, 34, 68, 1)),
            ),
            (isLoading)
                ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: const Color.fromRGBO(9, 97, 245, 1),
                      size: 50,
                    ),
                  )
                : SizedBox(
                    height: 170,
                    child: CarouselSlider.builder(
                        itemCount: skillsList.isEmpty ? 0 : skillsList.length,
                        itemBuilder: (context, index, realIndex) {
                          if (skillsList.isEmpty ||
                              index >= skillsList.length) {
                            return Center(
                              child: Text(
                                "No Data Available",
                                style: GoogleFonts.mulish(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          // Accessing the image URL
                          String imageUrl =
                              (skillsList[index]["images"] != null &&
                                      skillsList[index]["images"].isNotEmpty)
                                  ? skillsList[index]["images"][0]
                                  : 'https://via.placeholder.com/150';

                          return FittedBox(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${index + 1}) ",
                                    style: GoogleFonts.mulish(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          const Color.fromRGBO(32, 34, 68, 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Skill: ${skillsList[index]["skillName"] ?? "Unknown"}",
                                          style: GoogleFonts.mulish(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromRGBO(
                                                32, 34, 68, 1),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          skillsList[index]["projectName"] ??
                                              "No Project Name",
                                          style: GoogleFonts.mulish(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          imageUrl,
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.broken_image,
                                              size: 90,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          if (skillsList[index]["gitLink"] !=
                                              null) {
                                            _launchUrl(
                                                skillsList[index]["gitLink"]);
                                          } else {
                                            // Optional: Show a message or handle null GitHub links
                                            print("GitHub link not available");
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.link,
                                                color: Colors.blue, size: 18),
                                            const SizedBox(width: 5),
                                            Text(
                                              "GitHub",
                                              style: GoogleFonts.mulish(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 170,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        )),
                  ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
