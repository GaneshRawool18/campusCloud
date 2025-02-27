import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/authservice.dart';
import 'package:track_tracing/controller/student/sqfliteController.dart';
import 'package:track_tracing/controller/student/studentController.dart';

Map<String, dynamic> collegeData = {};

void fetchCollegeDetails() async {
  await Studentcontroller().fetchCollegeDetail().then((value) {
    collegeData.addAll(value);
  });
}

class VirtualCardPage extends StatefulWidget {
  const VirtualCardPage({super.key});

  @override
  State<VirtualCardPage> createState() => _MainProfilePage();
}

class _MainProfilePage extends State<VirtualCardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          "Virtual ID Card",
          style: GoogleFonts.jost(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card 1 - Basic Information
            FittedBox(
              child: Container(
                height: MediaQuery.of(context).size.height - 350,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image and Name
                    Row(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(),
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.network(
                                collegeData["image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            collegeData["collegeName"],
                            style: GoogleFonts.jost(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      collegeData["address"],
                      style: GoogleFonts.mulish(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          profileData["profileUrl"],
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        profileData["name"],
                        style: GoogleFonts.mulish(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Student Details (PRN, Class)
                    Text(
                      "Student Id : ${Authservice.studentID}",
                      style: GoogleFonts.mulish(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Class : ${profileData["department"]}",
                      style: GoogleFonts.mulish(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Address Section
                    Text(
                      "Atul Nagar Near Raghavdas Vidyalay Warje Pune 411058",
                      style: GoogleFonts.mulish(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            // Card 2 - Instructions and Personal Details
            FittedBox(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height - 350,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Instructions :",
                      style: GoogleFonts.jost(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "1. This card must be presented on demand.",
                      style: GoogleFonts.mulish(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "2. This card is not transferable.",
                      style: GoogleFonts.mulish(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "3. The above information is true as on.",
                      style: GoogleFonts.mulish(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Blood Group : ${profileData["bloodGroup"]}",
                      style: GoogleFonts.mulish(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Date of Birth : ${profileData["dob"]}",
                      style: GoogleFonts.mulish(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Contact No : ${profileData["contactNo"]}",
                      style: GoogleFonts.mulish(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Emergency Contact name : ${profileData["emergencyContactName"]}",
                      style: GoogleFonts.mulish(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Emergency Contact No : ${profileData["emergencyContactNo"]}",
                      style: GoogleFonts.mulish(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Column(
                          children: [
                            Container(
                              height: 70,
                              width: 130,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  profileData["signatureUrl"] ?? "",
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Text("Signature",
                                style: GoogleFonts.mulish(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
