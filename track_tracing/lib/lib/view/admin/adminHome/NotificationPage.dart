import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/admin/firebaseAdminNotifications.dart';

class NotificationAdmin extends StatefulWidget {
  const NotificationAdmin({super.key});

  @override
  State<NotificationAdmin> createState() => _NotificationAdminState();
}

class _NotificationAdminState extends State<NotificationAdmin> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isPersonSelected = false;

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _sendNotification() {
    final title = titleController.text.trim();
    final message = messageController.text.trim();

    if (title.isNotEmpty && message.isNotEmpty) {
      final target =
          isPersonSelected ? "StudentNotification" : "FacultyNotification";
      FirebaseAdminNotificationsController().setNotificationAdmin(
        target,
        {"title": title, "message": message},
      );
      titleController.clear();
      messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notification sent successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and message cannot be empty!")),
      );
    }
  }

  Widget _titleInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: titleController,
          style: GoogleFonts.poppins(fontSize: 16),
          decoration: InputDecoration(
            hintText: "Enter notification title",
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _messageInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: messageController,
          maxLines: 3,
          style: GoogleFonts.poppins(fontSize: 16),
          decoration: InputDecoration(
            hintText: "Enter notification message",
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  // Widget _targetSwitch() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           Text(
  //             "Faculty",
  //             style: GoogleFonts.poppins(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black87,
  //             ),
  //           ),
  //           Switch(
  //             value: isPersonSelected,
  //             onChanged: (value) {
  //               setState(() {
  //                 isPersonSelected = value;
  //               });
  //             },
  //             activeColor: Colors.blueAccent,
  //           ),
  //           Text(
  //             "Students",
  //             style: GoogleFonts.poppins(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black87,
  //             ),
  //           ),
  //         ],
  //       ),
  //       ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: const Color.fromARGB(255, 84, 178, 254),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         ),
  //         onPressed: _sendNotification,
  //         child: Text(
  //           "Send Notification",
  //           style: GoogleFonts.poppins(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _targetSwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Target Audience:",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ToggleButtons(
              isSelected: [!isPersonSelected, isPersonSelected],
              onPressed: (index) {
                setState(() {
                  isPersonSelected = index == 1;
                });
              },
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.white,
              color: Colors.black54,
              fillColor: Colors.blueAccent,
              constraints: const BoxConstraints(
                minWidth: 100,
                minHeight: 40,
              ),
              children: [
                Text(
                  "Faculty",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Students",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 84, 178, 254),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: _sendNotification,
              icon: const Icon(Icons.notifications_active, color: Colors.white),
              label: Text(
                "Notify",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      appBar: AppBar(
        title: Text(
          "Admin Notifications",
          style: GoogleFonts.jost(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 84, 178, 254),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleInputField(),
            const SizedBox(height: 20),
            _messageInputField(),
            const SizedBox(height: 20),
            _targetSwitch(),
          ],
        ),
      ),
    );
  }
}
