// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:track_tracing/view/student/Login/signinPage.dart';

// import 'introPage2.dart';

// class Intropage1 extends StatefulWidget {
//   const Intropage1({super.key});

//   @override
//   State<Intropage1> createState() => _IntropageState();
// }

// class _IntropageState extends State<Intropage1> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
//       body: Padding(
//         padding:
//             const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 25),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Signinpage()));
//                   },
//                   child: Text(
//                     "Skip",
//                     style: GoogleFonts.jost(
//                         fontSize: 20, decoration: TextDecoration.none),
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 const SizedBox(
//                   height: 150,
//                 ),
//                 Text(
//                   "Online Learning",
//                   style: GoogleFonts.jost(
//                       fontWeight: FontWeight.w600, fontSize: 20),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   textAlign: TextAlign.center,
//                   "We Provide also avoide to  Classes Online Classes and Pre Recorded Leactures.!",
//                   style: GoogleFonts.jost(
//                       fontWeight: FontWeight.w500, fontSize: 15),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Container(
//                   width: 20,
//                   height: 10,
//                   decoration: BoxDecoration(
//                       color: const Color.fromRGBO(9, 97, 245, 1),
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 Container(
//                   width: 20,
//                   height: 10,
//                   decoration: const BoxDecoration(
//                     color: Color.fromRGBO(213, 226, 245, 1),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Intropage2()));
//                   },
//                   child: Container(
//                     width: 60,
//                     height: 60,
//                     decoration: const BoxDecoration(
//                         color: Color.fromRGBO(9, 97, 245, 1),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                               offset: Offset(0, 0),
//                               color: Color.fromRGBO(0, 0, 0, 0.3),
//                               spreadRadius: 3)
//                         ]),
//                     child: const Icon(
//                       Icons.arrow_forward,
//                       color: Colors.white,
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; 
import 'package:track_tracing/view/student/Login/signinPage.dart';

import 'introPage2.dart';

class Intropage1 extends StatefulWidget {
  const Intropage1({super.key});

  @override
  State<Intropage1> createState() => _IntropageState();
}

class _IntropageState extends State<Intropage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Signinpage()));
                  },
                  child: Text(
                    "Skip",
                    style: GoogleFonts.jost(
                        fontSize: 20, decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                // Add Lottie animation here
                Lottie.asset(
                  'assets/images/BookAnimation.json',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Online Learning",
                  style: GoogleFonts.jost(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "We Provide also avoide to Classes Online Classes and Pre Recorded Leactures.!",
                  style: GoogleFonts.jost(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(9, 97, 245, 1),
                      borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                  width: 20,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(213, 226, 245, 1),
                    shape: BoxShape.circle,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Intropage2()));
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(9, 97, 245, 1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                              spreadRadius: 3)
                        ]),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
