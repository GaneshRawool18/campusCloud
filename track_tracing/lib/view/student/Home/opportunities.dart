import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/studentController.dart';
import 'package:url_launcher/url_launcher.dart';

class Opportunities extends StatefulWidget {
  const Opportunities({super.key});

  @override
  State<StatefulWidget> createState() => _MainOpportunities();
}

class _MainOpportunities extends State<StatefulWidget> {
  String? selectedCity;
  List<String> cities = [];
  List<String> skills = [];
  String? selectedSkill;
  bool isLoading = false;
  List<Map<String, dynamic>> opportunities = [];
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    !await launchUrl(uri);
  }

  Widget _dropDownBox({
    required BuildContext context,
    required String forWhat,
    required List<String> list,
    required bool isCities,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$forWhat:",
              style: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color.fromRGBO(32, 34, 68, 1),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 7,
            child: DropdownButton2(
              isExpanded: true,
              underline: const SizedBox.shrink(),
              style: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(32, 34, 68, 1),
                  size: 24,
                ),
              ),
              buttonStyleData: ButtonStyleData(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(32, 34, 68, 1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(32, 34, 68, 1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              value: selectedValue,
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              hint: Text(
                "Select $forWhat",
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchLists();
  }

  void _fetchLists() async {
    await Studentcontroller().fetchLocations().then((value) {
      cities.addAll(value);
    });
    await Studentcontroller().fetchStudentSkill().then((value) {
      skills.addAll(value);
    });
    setState(() {});
  }

  void searchOppurtunity() async {
    setState(() {
      isLoading = true;
    });
    opportunities = [];
    await Studentcontroller()
        .searchJobs(selectedCity!, selectedSkill!)
        .then((value) {
      opportunities.addAll(value);
    });
    log("Opportunities: $opportunities");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          automaticallyImplyLeading: false,
          title: Text(
            "Opportunities For You",
            style: GoogleFonts.jost(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _dropDownBox(
                      context: context,
                      forWhat: "Select City",
                      list: cities,
                      isCities: true,
                      selectedValue: selectedCity,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCity = newValue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _dropDownBox(
                      context: context,
                      forWhat: "Select Skill",
                      list: skills,
                      isCities: false,
                      selectedValue: selectedSkill,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSkill = newValue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () => searchOppurtunity(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 150,
                        // height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(9, 97, 245, 1),
                            border: Border.all()),
                        child: Text(
                          "Search",
                          style: GoogleFonts.mulish(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Container(
                      height: 410,
                      child: (isLoading)
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              child: (opportunities.isEmpty)
                                  ? const Text("not available",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: opportunities.length,
                                      itemBuilder: (context, index) {
                                        final job = opportunities[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, left: 10, right: 10),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.network(
                                                      'https://d2jhcfgvzjqsa8.cloudfront.net/storage/2022/04/download.png',
                                                      height: 150,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    job['componyName'] ??
                                                        "Company",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  // Position and Location
                                                  Text(
                                                    '${job['position'] ?? "Position"} - ${job['location'] ?? "Location"}',

                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  // Salary
                                                  Text(
                                                    'Salary: ${job['salary'] ?? "Salary not available"}',

                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.green[700],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  // Positions Opened
                                                  Text(
                                                   'Positions Open: ${job['positionOpened'] ?? "Position not available"}',

                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // Apply Button with URL link
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _launchURL(
                                                          job['siteUrl']);
                                                    },
                                                    child:
                                                        const Text('Apply Now'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
