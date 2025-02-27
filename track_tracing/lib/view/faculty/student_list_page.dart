import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/view/faculty/manageCourses.dart';

final ScrollController scrollController = ScrollController();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentListPage(),
    );
  }
}

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _MainStudentListPage();
}

class _MainStudentListPage extends State<StudentListPage> {
  final List<Map<String, dynamic>> students = [
    {
      "srNo": "1",
      "name": "Ganesh Rawool",
      "email": "ganesh@gmail.com",
      "id": "101",
      "isBlocked": false
    },
    {
      "srNo": "2",
      "name": "Abhishek Bhosale",
      "email": "abhishek@gmail.com",
      "id": "102",
      "isBlocked": false
    },
    {
      "srNo": "3",
      "name": "Yashodip Thakare",
      "email": "yashodip@gmail.com",
      "id": "103",
      "isBlocked": false
    },
    {
      "srNo": "4",
      "name": "Atharva Gosavi",
      "email": "atharva@gmail.com",
      "id": "104",
      "isBlocked": false
    },
    {
      "srNo": "5",
      "name": "Atharva Gosavi",
      "email": "atharva@gmail.com",
      "id": "104",
      "isBlocked": false
    },
    {
      "srNo": "6",
      "name": "Atharva Gosavi",
      "email": "atharva@gmail.com",
      "id": "104",
      "isBlocked": false
    },
    {
      "srNo": "7",
      "name": "Atharva Gosavi",
      "email": "atharva@gmail.com",
      "id": "104",
      "isBlocked": false
    },
    {
      "srNo": "8",
      "name": "Atharva Gosavi",
      "email": "atharva@gmail.com",
      "id": "104",
      "isBlocked": false
    },
    {
      "srNo": "9",
      "name": "Atharva Gosavi",
      "email": "atharva@gmail.com",
      "id": "104",
      "isBlocked": false
    },
    {
      "srNo": "10",
      "name": "Atharva Gosavi",
      "email": "atharva@gmail.com",
      "id": "104",
      "isBlocked": false
    },
    {
      "srNo": "11",
      "name": "Atharva Gosavi",
      "email": "atharva@gmail.com",
      "id": "104",
      "isBlocked": false
    },
    {
      "srNo": "12",
      "name": "Atharva Gosavi",
      "email": "atharva@gmail.com",
      "id": "104",
      "isBlocked": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Student list",
          style: GoogleFonts.jost(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 91, 219, 236).withOpacity(0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 5,
                      blurStyle: BlurStyle.outer,
                    )
                  ],
                  // gradient: const LinearGradient(
                  //   colors: [
                  //     Color.fromARGB(255, 198, 219, 219),
                  //     Color.fromARGB(255, 80, 200, 224)
                  //   ], // Replace with your preferred colors
                  //   begin: Alignment.centerLeft,
                  //   end: Alignment.centerRight,
                  // ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Sr.No: ${student["srNo"]}",
                            style: GoogleFonts.jost(fontSize: 20),
                          ),
                          Text(
                            "Student Id: ${student["id"]}",
                            style: GoogleFonts.jost(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Student Name: ${student["name"]}",
                      style: GoogleFonts.jost(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Email: ${student["email"]}",
                        style: GoogleFonts.jost(fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Status:",
                            style: GoogleFonts.jost(fontSize: 20),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              student["isBlocked"] = !student["isBlocked"];
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0, 5),
                                  blurRadius: 5,
                                  blurStyle: BlurStyle.outer,
                                )
                              ], borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Icon(
                                  student["isBlocked"]
                                      ? Icons.block
                                      : Icons.check,
                                  color: student["isBlocked"]
                                      ? const Color.fromARGB(255, 246, 44, 30)
                                      : const Color.fromARGB(255, 32, 65, 33),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
