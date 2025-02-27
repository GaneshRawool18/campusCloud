import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Student {
  final String name;
  final String course;
  final int id;
  final String className;
  final int phoneNo;
  final String moPay = "e-Fund Transfer";
  final String instrumentNo = "pay_IZciBqPuX4Amjm";
  final String bankName;
  final String branch;

  Student({
    required this.name,
    required this.course,
    required this.id,
    required this.className,
    required this.phoneNo,
    required this.bankName,
    required this.branch,
  });
}

class Feesstructure extends StatelessWidget {
  const Feesstructure({super.key});

  @override
  Widget build(BuildContext context) {
    final Student student = Student(
      name: "Tiger Shroff",
      course: "Computer Science",
      id: 14635,
      className: "CS101",
      phoneNo: 9876543210,
      bankName: "Bank of India",
      branch: "Branch1",
    );

    List<Map<String, dynamic>> listContent = [
      {'Description': 'University Pro-Rata Fees / 2122', 'Amount': 517.00},
      {'Description': 'Student Insurance / 2122', 'Amount': 5500.00},
      {'Description': 'Eligibility Fees / 2122', 'Amount': 5500.00},
      {'Description': 'Medical Fees / 2122', 'Amount': 600.00},
      {'Description': 'Student Activity Fees / 2122', 'Amount': 10000.00},
      {'Description': 'Caution Money Deposit / 2122', 'Amount': 8000.00},
      {'Description': 'Student Training Programme / 2122', 'Amount': 40000.00},
    ];

      double totalFees = 0;

  double totalFeesLoop(double totalFees) {
    for (int i = 0; i < listContent.length; i++) {
      totalFees = listContent[i]['Amount'] + totalFees;
    }
    print("$totalFees");
    return totalFees;
  }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fees Structure',
          style: GoogleFonts.mulish(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Color.fromRGBO(0, 0, 0, 0.7),
            size: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 10, color: Colors.blue),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Student Fee Details",
                  style: GoogleFonts.mulish(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(255, 44, 116, 175),
                  ),
                ),
                Image.asset(
                  "assets/UniLogo.jpg",
                  height: 60,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Student Name: ${student.name}", style: _textStyle()),
                Text("Course: ${student.course}", style: _textStyle()),
                Text("Student ID: ${student.id}", style: _textStyle()),
                Text("Class: ${student.className}", style: _textStyle()),
                Text("Phone No: ${student.phoneNo}", style: _textStyle()),
                const Divider(thickness: 1, color: Colors.blue),
                const SizedBox(height: 10),
                Table(
                  border: TableBorder.all(
                    width: 1,
                    color: const Color.fromRGBO(0, 0, 0, 1),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        _tableCell("Description", FontWeight.w700),
                        _tableCell("Amount(Rs)", FontWeight.w700),
                      ],
                    ),
                    ...listContent.map((item) {
                      return TableRow(
                        children: [
                          _tableCell(item['Description'], FontWeight.w500),
                          _tableCell('${item['Amount']}', FontWeight.w500),
                        ],
                      );
                    }),
                    TableRow(
                      children: [
                        _tableCell("Total", FontWeight.w700),
                        _tableCell('$totalFees', FontWeight.w700),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text("Mode Of Payment: ${student.moPay}", style: _textStyle()),
                Text("Instrument Name: ${student.instrumentNo}", style: _textStyle()),
                Text("Bank Name: ${student.bankName}", style: _textStyle()),
                Text("Branch: ${student.branch}", style: _textStyle()),
                const SizedBox(height: 20),
                const Divider(thickness: 10, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return GoogleFonts.mulish(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color.fromRGBO(0, 0, 0, 1),
    );
  }

  Widget _tableCell(String text, FontWeight fontWeight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: GoogleFonts.mulish(
          fontSize: 14,
          fontWeight: fontWeight,
          color: const Color.fromRGBO(0, 0, 0, 1),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
