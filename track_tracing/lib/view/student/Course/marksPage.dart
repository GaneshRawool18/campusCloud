import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/courseFIrestoreController.dart';
import 'package:track_tracing/view/student/Course/contentPage.dart';

class MarksPage extends StatefulWidget {
  const MarksPage({super.key});

  @override
  _MarksPageState createState() => _MarksPageState();
}

class _MarksPageState extends State<MarksPage> {
  String? selectedValue;
  bool isLoading = true;
  int? marks;
  String message = "";
  List<Map<String, dynamic>> topicsWithMarks = [];

  void _fetchSubTopicsWithMarks(String? value) async {
    try {
      setState(() {
        isLoading = true;
      });
      topicsWithMarks = [];
      await CourseController().fetchSubTopicswithMarks(value).then((value) {
        topicsWithMarks.addAll(value);
      });
      log("marks $topicsWithMarks");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        message = "Your marks not updated yet!!!";
        isLoading = false;
      });
      log("failed to fetch marks $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    CourseController.selectedCurseName!,
                    style: GoogleFonts.mulish(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(
                          32, 34, 68, 1), // Text color for course name
                    ),
                  ),
                  const Icon(Icons.my_library_books_outlined)
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              DropdownButton2<String>(
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
                    _fetchSubTopicsWithMarks(newValue);
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
                  maxHeight: 800,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(32, 34, 68, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                items: topics.map<DropdownMenuItem<String>>((dynamic value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.mulish(
                          fontSize: 16,
                          color: const Color.fromRGBO(255, 255, 255, 1)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              if (selectedValue != null)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedValue!,
                          style: GoogleFonts.mulish(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color.fromRGBO(32, 34, 68, 1),
                          ),
                        ),
                        Text(
                          "Marks",
                          style: GoogleFonts.mulish(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color.fromRGBO(32, 34, 68, 1),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 3,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    (isLoading)
                        ? const CircularProgressIndicator()
                        : (message.isNotEmpty)
                            ? Center(
                                child: Text(
                                message,
                                style: GoogleFonts.mulish(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              ))
                            : ListView.builder(
                                itemCount: topicsWithMarks.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            topicsWithMarks[index]["subTopic"],
                                            style: GoogleFonts.mulish(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: (int.parse(
                                                          topicsWithMarks[index]
                                                              ["marks"]) >
                                                      5)
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "${topicsWithMarks[index]["marks"]}/10",
                                            style: GoogleFonts.mulish(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: (int.parse(
                                                            topicsWithMarks[
                                                                    index]
                                                                ["marks"]) >
                                                        5)
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
