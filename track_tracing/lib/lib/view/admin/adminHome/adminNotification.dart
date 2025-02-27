import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:track_tracing/controller/student/firestoreAdminController.dart';

class NotificationRequestScreen extends StatefulWidget {
  const NotificationRequestScreen({super.key});

  @override
  State<NotificationRequestScreen> createState() =>
      _NotificationRequestScreenState();
}

class _NotificationRequestScreenState extends State<NotificationRequestScreen> {
  List<Map<String, dynamic>> studentRequests = [];
  bool isLoading = true;
  bool isSucess = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminNotification();
  }

  void _fetchAdminNotification() async {
    setState(() {
      isLoading = true;
    });
    studentRequests = [];
    await FirebaseAdminController().fetchAdminNotifications().then((value) {
      studentRequests.addAll(value);
    });
    studentRequests = studentRequests.reversed.toList();
    setState(() {
      isLoading = false;
    });
  }

  String _checkDay(int index) {
    DateTime requestDate =
        DateFormat.yMMMEd().parse(studentRequests[index]["date"]);
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (DateFormat.yMMMEd().format(requestDate) ==
        DateFormat.yMMMEd().format(today)) {
      return "Today";
    } else if (DateFormat.yMMMEd().format(requestDate) ==
        DateFormat.yMMMEd().format(yesterday)) {
      return "Yesterday";
    } else {
      return DateFormat.yMMMEd().format(requestDate);
    }
  }

  void _rejectRequest(int index, int subIndex) {
    setState(() {
      // Remove the specific subIndex from the "times" list
      studentRequests[index]["times"].removeAt(subIndex);

      // If the "times" list becomes empty, remove the entire index
      if (studentRequests[index]["times"].isEmpty) {
        studentRequests.removeAt(index);
      }
    });
  }

  void _accepted(int index, int subIndex) async {
    setState(() {
      isSucess = false;
    });
    FirebaseAdminController()
        .registerStudentWithCredentials(await FirebaseAdminController()
            .registrationAllowedByAdmin(
                studentRequests[index]["date"],
                studentRequests[index]["times"][subIndex]["time"],
                studentRequests[index]["times"][subIndex]["name"]))
        .then((value) {
      isSucess = value;
      print(isSucess);
    });
    setState(() {
      isSucess = true;
      studentRequests[index]["times"].removeAt(subIndex);
      if (studentRequests[index]["times"].isEmpty) {
        studentRequests.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.jost(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 84, 178, 254),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Color.fromRGBO(255, 255, 255, 1),
            size: 25,
          ),
        ),
        actions: [
          (!isSucess) ? const CircularProgressIndicator() : const SizedBox(),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child:
                  LoadingAnimationWidget.inkDrop(color: Colors.blue, size: 40))
          : _cardsBuilder(),
    );
  }

  Widget _cardsBuilder() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(studentRequests.length, (index) {
          List<Map<String, dynamic>> notification =
              List<Map<String, dynamic>>.from(studentRequests[index]["times"]);

          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 15),
                Text(_checkDay(index),
                    style: GoogleFonts.jost(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(32, 34, 68, 1))),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notification.length,
                  itemBuilder: (context, subIndex) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(232, 241, 255, 1),
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(notification[subIndex]["time"],
                                          style: GoogleFonts.jost(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromRGBO(
                                                  32, 34, 68, 1))),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          notification[subIndex]
                                                  ["profileURL"] ??
                                              'assets/images/default.png',
                                          height: 70,
                                          width: 70,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              Image.asset(
                                                  'assets/images/default.png',
                                                  height: 70,
                                                  width: 70),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification[subIndex]["title"],
                                        style: GoogleFonts.jost(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                221, 88, 179, 135)),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                          "Name : ${notification[subIndex]["name"]}",
                                          style: GoogleFonts.jost(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromRGBO(
                                                  32, 34, 68, 1))),
                                      const SizedBox(height: 10),
                                      Text(
                                          "Contact : ${notification[subIndex]["contact"]}",
                                          style: GoogleFonts.jost(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromRGBO(
                                                  32, 34, 68, 1))),
                                      const SizedBox(height: 10),
                                      Text(
                                          "Department : ${notification[subIndex]["department"]}",
                                          style: GoogleFonts.jost(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromRGBO(
                                                  32, 34, 68, 1))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () => _accepted(index, subIndex),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      "Accept",
                                      style: GoogleFonts.mulish(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _rejectRequest(index, subIndex),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      "Reject",
                                      style: GoogleFonts.mulish(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
