import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/courseFIrestoreController.dart';
import 'package:track_tracing/model/student/ratingModal.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainRatingPage();
}

class _MainRatingPage extends State<RatingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<bool> rating = [false, false, false, false, false];
  int? selectedStar;
  String message = "";
  bool? isRated = false;
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    _checkAlreadyRated();
  }

  Future<void> _checkAlreadyRated() async {
    try {
      final value = await CourseController().isAlreadyRated();
      log("Value: $value");
      setState(() {
        isRated = true;
        data = value;
        message =
            "You have already rated this course!\nThanks for your review.";
      });
    } catch (e) {
      log("Error in _checkAlreadyRated: $e");
    }
  }

  void _rated(int num) {
    selectedStar = num + 1;
    setState(() {
      for (int i = 0; i < rating.length; i++) {
        rating[i] = i <= num;
      }
    });
  }

  void _submitRating() {
    if (_descriptionController.text.trim().isNotEmpty &&
        _titleController.text.trim().isNotEmpty &&
        selectedStar != null) {
      CourseController()
          .reviewCourseThroughRating(Rating(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  rating: selectedStar)
              .toMap())
          .then((value) {
        if (value == true) {
          setState(() {
            _titleController.clear();
            _descriptionController.clear();
            message = "Thank you for your feedback!";
            selectedStar = null; // Reset selected star after submit
            rating = [false, false, false, false, false]; // Reset rating
          });
        }
      });
    } else {
      setState(() {
        message = "All fields are required";
      });
    }
  }

  Widget starCreation(int index) {
    return IconButton(
        onPressed: () => _rated(index),
        icon: (rating[index])
            ? const Icon(
                Icons.star,
                size: 35,
                color: Colors.amber,
              )
            : const Icon(
                Icons.star_border,
                size: 35,
                color: Colors.amber,
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                        blurStyle: BlurStyle.outer),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          starCreation(0),
                          starCreation(1),
                          starCreation(2),
                          starCreation(3),
                          starCreation(4),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _titleController,
                      style: GoogleFonts.mulish(
                          fontWeight: FontWeight.w700, fontSize: 17),
                      mouseCursor: SystemMouseCursors.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                          hintStyle: GoogleFonts.mulish(
                              fontWeight: FontWeight.w700, fontSize: 17),
                          prefixIcon: const Icon(Icons.title),
                          filled: true,
                          fillColor: const Color.fromRGBO(255, 255, 255, 1),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 0.025,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0.025),
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      minLines: 1,
                      style: GoogleFonts.mulish(
                          fontWeight: FontWeight.w700, fontSize: 17),
                      mouseCursor: SystemMouseCursors.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Description",
                          hintStyle: GoogleFonts.mulish(
                              fontWeight: FontWeight.w700, fontSize: 17),
                          prefixIcon: const Icon(Icons.comment),
                          filled: true,
                          fillColor: const Color.fromRGBO(255, 255, 255, 1),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 0.025,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0.025),
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!isRated!) _submitRating();
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (isRated!)
                              ? const Color.fromARGB(164, 18, 30, 49)
                              : const Color.fromRGBO(9, 97, 254, 1),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: GoogleFonts.jost(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 94, 91, 91),
                ),
              ),
              const SizedBox(height: 30),
              (isRated!)
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _titleController.text = data["title"];
                          _descriptionController.text = data["description"];
                          _rated(data["rating"] - 1);
                          message = "";
                          isRated = false;
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromRGBO(9, 97, 254, 1),
                        ),
                        child: Center(
                          child: Text(
                            "Update review",
                            style: GoogleFonts.jost(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
