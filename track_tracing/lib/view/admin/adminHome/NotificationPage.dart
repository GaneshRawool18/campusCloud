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
          style: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: "Enter notification title",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          style: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: messageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Enter notification message",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _targetSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text("Faculty"),
            Switch(
              value: isPersonSelected,
              onChanged: (value) {
                setState(() {
                  isPersonSelected = value;
                });
              },
              activeColor: Colors.blue,
            ),
            const Text("Students"),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _sendNotification,
          child: const Text("Send Notification"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Notifications"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
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
