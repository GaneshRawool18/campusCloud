import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _MainAboutUsPage();
}

class _MainAboutUsPage extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(
            "About Us",
            style: GoogleFonts.jost(
                fontSize: 21, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(255, 11, 8, 118)
                                .withOpacity(0.7),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                            blurStyle: BlurStyle.outer),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 20),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              "assets/images/sir.jpeg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(35),
                          child: Text(
                            "Master : \nShashi Bagal Sir",
                            style: GoogleFonts.jost(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Information : \n",
                        style: GoogleFonts.jost(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text:
                            "Our online submission platform streamlines assignment and project submissions, allowing quick file uploads, multiple formats, and easy tracking. Instructors can review and grade submissions directly,with built-in security and privacy features that enhance efficiency and transparency for all users.",
                        style: GoogleFonts.jost(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Team Members :",
                  style: GoogleFonts.jost(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "1. Abhishek Bhosale (Leader)\n2. Atharva Gosavi\n3. Yashodip Thakare\n4. Ganesh Rawool",
                  style: GoogleFonts.jost(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
