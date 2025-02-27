// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/authservice.dart';
import 'package:track_tracing/controller/student/sqfliteController.dart';
import 'package:track_tracing/view/admin/adminHome/adminDashBoard.dart';
import 'package:track_tracing/view/admin/adminHome/adminNotification.dart';
import 'package:track_tracing/view/faculty/HomePage.dart';
import 'package:track_tracing/view/student/Course/homePage.dart';
import 'package:track_tracing/view/student/Login/registerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class Signinpage extends StatefulWidget {
  const Signinpage({super.key});

  @override
  State<Signinpage> createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isVisible = false;
  String notification = "";
  final _auth = Authservice();

  void _signin() async {
    if (_usernameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty) {
      try {
        await _auth
            .signingWithEmailAndPassword(
                _usernameController.text, _passwordController.text)
            .then((value) {
          if (value) {
            if (checkWho() == "admin") {
              _auth.setAdminID(_usernameController.text);

              log("In method");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminDashBoard()));
            } else if (checkWho() == "faculty") {
              _auth.setFacultyId(_usernameController.text);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FacultyHomePage()));
            } else if (checkWho() == "student") {
              _auth.setStudentId(_usernameController.text);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            } else {
              _showMessage("Invalid credentials");
            }
          } else {
            _showMessage("Invalid credentials");
          }
        });

        // setState(() {
        //   _usernameController.clear();
        //   _passwordController.clear();
        // });
      } catch (e) {
        log("Failed to login admin $e");
        _showMessage("Invalid credentials");
      }
    } else {
      _showMessage("All fields are compulsory");
    }
  }

  String checkWho() {
    String str = _usernameController.text;

    List<String> parts = str.split('@');

    String domainPart = parts[1];
    List<String> domainParts = domainPart.split('.');
    print("Who ${domainParts[0]}");
    return domainParts[0];
  }

  void _showMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Error',
                style: GoogleFonts.mulish(
                    fontSize: 25, fontWeight: FontWeight.bold)),
            content: Text(message,
                style: GoogleFonts.mulish(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.mulish(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(50),
                child: Image.asset(
                  "assets/images/graduation.png",
                  height: 150,
                ),
              ),
              Text(
                "Let’s Sign In.!",
                style:
                    GoogleFonts.jost(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Text(
                "Login to Your Account to Continue your Courses",
                style:
                    GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 50,
              ),

              /// USERNAME TEXTFILED
              TextField(
                controller: _usernameController,
                style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w700, fontSize: 17),
                mouseCursor: SystemMouseCursors.text,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                    hintStyle: GoogleFonts.mulish(
                        fontWeight: FontWeight.w700, fontSize: 17),
                    prefixIcon: const Icon(Icons.email_outlined),
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

              /// PASSWORD TEXTFILED
              TextField(
                controller: _passwordController,
                mouseCursor: SystemMouseCursors.text,
                obscureText: _isVisible ? false : true,
                style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w700, fontSize: 17),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    hintStyle: GoogleFonts.mulish(
                        fontWeight: FontWeight.w700, fontSize: 17),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: _isVisible
                        ? IconButton(
                            icon: const Icon(Icons.visibility_outlined),
                            onPressed: () => setState(() {
                              _isVisible = false;
                            }),
                          )
                        : IconButton(
                            onPressed: () => setState(() {
                                  _isVisible = true;
                                }),
                            icon: const Icon(Icons.visibility_off_outlined)),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const SizedBox(),
              //     Text(
              //       "Forgot Password?",
              //       style: GoogleFonts.mulish(
              //           fontWeight: FontWeight.w800, fontSize: 14),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              // height: 20,
              // ),
              Center(
                  child: SwipeButton(
                thumb: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.black,
                ),
                thumbPadding: const EdgeInsets.all(10),
                activeThumbColor: Colors.white,
                activeTrackColor: const Color.fromRGBO(9, 97, 245, 1),
                height: 60,
                width: 350,
                onSwipe: () {
                  setState(() {
                    _signin();
                  });
                },
                child: Text(
                  "Sign In",
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              )),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: SizedBox(
                  width: 380,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "For any queries fill this form ",
                        style: GoogleFonts.mulish(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      GestureDetector(
                          onTap: () {
                            Uri uri = Uri.parse(
                                "https://forms.gle/FRmKaiN5hq1Jeq2Z6");
                            launchUrl(uri);
                          },
                          child: Text("click here",
                              style: GoogleFonts.mulish(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: const Color.fromRGBO(9, 97, 245, 1))))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Center(child: Text("OR")),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not registered yet? ",
                        style: GoogleFonts.mulish(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Registerpage()));
                          },
                          child: Text(
                            "Register",
                            style: GoogleFonts.mulish(
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color.fromRGBO(9, 97, 245, 1)),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
