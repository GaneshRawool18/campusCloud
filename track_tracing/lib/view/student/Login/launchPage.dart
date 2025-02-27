import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:track_tracing/controller/faculty/facultyProfileController.dart';
import 'package:track_tracing/controller/student/authservice.dart';
import 'package:track_tracing/controller/student/sharedPreference.dart';
import 'package:track_tracing/view/admin/adminHome/adminDashBoard.dart';
import 'package:track_tracing/view/faculty/HomePage.dart';
import 'package:track_tracing/view/student/Course/homePage.dart';
import 'package:track_tracing/view/student/Login/introPage1.dart';

class Launchpage extends StatelessWidget {
  const Launchpage({super.key});

  void _checkLogin(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      await SharedPreferenceController.getData();
      log("isLogin => ${SharedPreferenceController.isLogin}");
      log("StudentId => ${SharedPreferenceController.id}");
      if (SharedPreferenceController.isLogin!) {
        log("StudentId => ${SharedPreferenceController.id}");
        if (SharedPreferenceController.id!.length == 2) {
          Authservice.adminID = SharedPreferenceController.id;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminDashBoard()));
        } else if (SharedPreferenceController.id!.length == 3) {
          Authservice.staffID = SharedPreferenceController.id;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FacultyHomePage()));
        } else {
          Authservice.studentID = SharedPreferenceController.id;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      } else {
        log("else => ${SharedPreferenceController.isLogin}");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Intropage1()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkLogin(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(9, 97, 245, 1),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(
            "assets/images/graduation.png",
            height: 350,
          ),
        ),
      ),
    );
  }
}
