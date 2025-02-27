import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/courseFIrestoreController.dart';
import 'package:track_tracing/view/student/Course/coursePage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> assignmentsNotifications = [];
  List<Map<String, dynamic>> otherNotifications = [];

  void _readNotificationStatus(int index) {
    log("Notification Read");
    setState(() {
      notifications[index]["isRead"] = true;
    });
    log(notifications[index]["title"].toString());
  }

  Widget _buildOtherNotificationCard(
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: (notifications[index]["isRead"] as bool)
            ? Colors.grey.shade100
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
            blurStyle: BlurStyle.normal,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Icon Container
          CircleAvatar(
            radius: 30,
            backgroundColor:
                (notifications[index]['title'] == 'Course Deleted' ||
                        notifications[index]['title'] == 'Assignment Deleted')
                    ? (notifications[index]["isRead"] as bool)
                        ? Colors.red.withOpacity(0.5)
                        : Colors.red
                    : const Color.fromRGBO(9, 97, 245, 1),
            child: (notifications[index]['title'] == 'Course Deleted' ||
                    notifications[index]['title'] == 'Assignment Deleted')
                ? const Icon(
                    Icons.delete,
                    color: Color.fromRGBO(255, 255, 255, 1),
                    size: 30,
                  )
                : const Icon(
                    Icons.notifications,
                    color: Color.fromRGBO(255, 255, 255, 1),
                    size: 30,
                  ),
          ),
          const SizedBox(width: 15),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notifications[index]['title'] ?? "",
                        style: GoogleFonts.jost(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: (notifications[index]["isRead"] as bool)
                              ? Colors.black.withOpacity(0.5)
                              : const Color.fromRGBO(9, 97, 245, 1),
                        ),
                      ),
                    ),
                    Text(
                      notifications[index]['time'] ?? "",
                      style: GoogleFonts.jost(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notifications[index]['body'] ?? "",
                  style: GoogleFonts.jost(
                    fontSize: 15,
                    color: (notifications[index]["isRead"] as bool)
                        ? Colors.black.withOpacity(0.5)
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentNotificationCard(int index) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.assignment,
              color: Color.fromRGBO(255, 255, 255, 1),
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notifications[index]['title'] ?? "",
                        style: GoogleFonts.jost(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(9, 97, 245, 1),
                        ),
                      ),
                    ),
                    Text(
                      notifications[index]['time'] ?? "",
                      style: GoogleFonts.jost(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  (notifications[index]['title'] == 'New Assignment')
                      ? notifications[index]['message'] ?? ""
                      : notifications[index]['body'] ?? "",
                  style: GoogleFonts.jost(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  (notifications[index]['title'] == 'New Assignment')
                      ? "Assignment Name : ${notifications[index]['assignment']}" ??
                          ""
                      : "Course code : ${notifications[index]['courseCode']}" ??
                          "",
                  style: GoogleFonts.jost(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Notifications",
          style: GoogleFonts.jost(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shadowColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: (notifications[index]['title'] == 'New Assignment' ||
                      notifications[index]['title'] == 'New Course Added')
                  ? GestureDetector(
                      onTap: () => _readNotificationStatus(index),
                      child: _buildAssignmentNotificationCard(index))
                  : GestureDetector(
                      onTap: () => _readNotificationStatus(index),
                      child: _buildOtherNotificationCard(index)));
        },
      ),
    );
  }
}
