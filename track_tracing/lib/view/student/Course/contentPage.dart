import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:track_tracing/controller/faculty/courseContentControlller.dart';
import 'package:track_tracing/controller/faculty/courseController.dart';
import 'package:track_tracing/controller/student/courseFIrestoreController.dart';
import 'package:track_tracing/view/student/Course/uploadPage.dart';

List<dynamic> topics = [];
List<String> subTopics = [];

class Contentpage extends StatefulWidget {
  const Contentpage({
    super.key,
  });

  @override
  State<Contentpage> createState() => _ContentpageState();
}

class _ContentpageState extends State<Contentpage> {
  final List<bool> _isExpandedList = List.generate(20, (index) => false);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopicNames();
  }

  void _fetchTopicNames() async {
    setState(() {
      isLoading = true;
    });
    topics = await CourseContentController().fetchTopicsList(
        CourseController.selectedDeptName!,
        CourseController.selectedSemister!,
        CourseController.selectedCurseName!);
    setState(() {
      isLoading = false;
    });
  }

  void _toggleExpansion(int index) async {
    setState(() {
      if (_isExpandedList[index]) {
        _isExpandedList[index] = false;
      } else {
        for (int i = 0; i < _isExpandedList.length; i++) {
          _isExpandedList[i] = i == index;
        }
      }
    });

    if (_isExpandedList[index]) {
      subTopics = [];
      subTopics = await CourseController().fetchSubTopics(
          CourseController.selectedDeptName!,
          CourseController.selectedSemister!,
          CourseController.selectedCurseName!,
          topics[index]);
      setState(() {});
    }
  }

  void _uploadPage(int index, int subIndex) async {
    log("topic: ${topics[index]}");
    log("subTopic: ${subTopics[subIndex]}");
    await CourseController().fetchSubtopicDescription(
        CourseController.selectedDeptName!,
        CourseController.selectedSemister!,
        CourseController.selectedCurseName!,
        topics[index],
        subTopics[subIndex]);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Uploadpage(
                  topic: topics[index],
                  subTopic: subTopics[subIndex],
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total topics: ${topics.length.toString()}",
              style: GoogleFonts.mulish(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: (isLoading)
                  ? Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: Color.fromRGBO(9, 97, 245, 1),
                        size: 50,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _toggleExpansion(index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(245, 249, 255, 1),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                        (_isExpandedList[index])
                                            ? Icons.remove
                                            : Icons.add,
                                        color: (_isExpandedList[index])
                                            ? const Color.fromRGBO(
                                                9, 97, 254, 1)
                                            : const Color.fromRGBO(
                                                32, 34, 68, 1)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        topics[index],
                                        style: GoogleFonts.mulish(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: (_isExpandedList[index])
                                                ? const Color.fromRGBO(
                                                    9, 97, 254, 1)
                                                : const Color.fromRGBO(
                                                    32, 34, 68, 1)),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      subTopics.length.toString(),
                                      style: GoogleFonts.mulish(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: (_isExpandedList[index])
                                            ? const Color.fromRGBO(
                                                9, 97, 254, 1)
                                            : const Color.fromRGBO(
                                                32, 34, 68, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_isExpandedList[index])
                                  (isLoading)
                                      ? Center(
                                          child: LoadingAnimationWidget.inkDrop(
                                            color:
                                                Color.fromRGBO(9, 97, 245, 1),
                                            size: 50,
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: subTopics.length,
                                            itemBuilder: (context, subIndex) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color:
                                                          const Color.fromARGB(
                                                              159,
                                                              200,
                                                              215,
                                                              233)),
                                                  child: GestureDetector(
                                                    onTap: () => _uploadPage(
                                                        index, subIndex),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            "${subIndex + 1} ]",
                                                            style: GoogleFonts.mulish(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    22,
                                                                    127,
                                                                    113,
                                                                    1))),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: Text(
                                                            subTopics[subIndex],
                                                            style: GoogleFonts.mulish(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    22,
                                                                    127,
                                                                    113,
                                                                    1)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
