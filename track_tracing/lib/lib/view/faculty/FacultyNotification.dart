import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String studentName = "Ganesh Rawool";
  String course = "Course Name";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Notifications",
            style: GoogleFonts.jost(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(9, 97, 245, 1),
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: const LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Student: $studentName",
                      style: GoogleFonts.jost(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Submitted Assigment of $course",
                      style: GoogleFonts.jost(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                          // color: const Color.fromRGBO(9, 97, 245, 1),
                          ),
                    ),
                  ],
                ),
              );
            }));
  }
}
