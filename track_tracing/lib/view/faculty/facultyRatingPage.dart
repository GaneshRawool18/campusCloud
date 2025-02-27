import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:track_tracing/controller/faculty/courseController.dart';
import 'package:track_tracing/view/faculty/courseNavigationPage.dart';

class FacultyRatingPage extends StatefulWidget {
  const FacultyRatingPage({super.key});

  @override
  State<FacultyRatingPage> createState() => _FacultyRatingPageState();
}

class _FacultyRatingPageState extends State<FacultyRatingPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> studentReviews = [];

  @override
  void initState() {
    super.initState();
    _fetchStudentReviews();
  }

  Future<void> _fetchStudentReviews() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>> reviews =
          await FacultyCourseController().getStudentReviews(
        facultySelectedDept!,
        facultySelectedSem!,
        facultySelectedCourse!,
      );

      setState(() {
        studentReviews = reviews;
      });
    } catch (e) {
      // Handle errors gracefully
      log("Error fetching student reviews: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : studentReviews.isEmpty
              ? const Center(
                  child: Text(
                    'No reviews available.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: studentReviews.length,
                    itemBuilder: (context, index) {
                      final review = studentReviews[index];
                      final rating = review['rating'];
                      const maxRating = 5.0;
                      final percentage = (rating / maxRating);

                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Rating: ${rating.toStringAsFixed(1)} / $maxRating",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  LinearPercentIndicator(
                                    animation: true,
                                    animationDuration: 700,
                                    lineHeight: 12,
                                    percent: percentage,
                                    backgroundColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    progressColor:
                                        const Color.fromRGBO(9, 132, 227, 1),
                                    barRadius: const Radius.circular(8),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    review['description'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
