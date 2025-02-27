// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:track_tracing/view/student/Login/signinPage.dart';

// class Intropage2 extends StatefulWidget {
//   const Intropage2({super.key});

//   @override
//   State<Intropage2> createState() => _IntropageState();
// }

// class _IntropageState extends State<Intropage2> {
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
//                     style: GoogleFonts.jost(fontSize: 20),
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
//                   "Learn from Anytime",
//                   style: GoogleFonts.jost(
//                       fontWeight: FontWeight.w600, fontSize: 20),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   textAlign: TextAlign.center,
//                   "Booked or Same the Lectures for Future",
//                   style: GoogleFonts.jost(
//                       fontWeight: FontWeight.w500, fontSize: 15),
//                 ),
//               ],
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const Signinpage()));
//               },
//               child: Row(
//                 children: [
//                   Container(
//                     width: 20,
//                     height: 10,
//                     decoration: const BoxDecoration(
//                       color: Color.fromRGBO(213, 226, 245, 1),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   Container(
//                     width: 20,
//                     height: 10,
//                     decoration: BoxDecoration(
//                         color: const Color.fromRGBO(9, 97, 245, 1),
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   const Spacer(),
//                   Container(
//                     padding: const EdgeInsets.only(
//                         left: 15, top: 10, right: 5, bottom: 10),
//                     width: 200,
//                     height: 60,
//                     decoration: BoxDecoration(
//                         color: const Color.fromRGBO(9, 97, 245, 1),
//                         borderRadius: BorderRadius.circular(30)),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Get Started",
//                           style: GoogleFonts.jost(
//                               color: const Color.fromRGBO(255, 255, 255, 1),
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600),
//                         ),
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(Icons.arrow_forward),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:track_tracing/view/student/Login/signinPage.dart';

class Intropage2 extends StatefulWidget {
  const Intropage2({super.key});

  @override
  State<Intropage2> createState() => _IntropageState();
}

class _IntropageState extends State<Intropage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 25),
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
                    style: GoogleFonts.jost(fontSize: 20),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                // Add Lottie animation here
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Lottie.asset(
                    'assets/images/BookAnimation.json',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),

                // Lottie.asset(
                //   'assets/images/IntroPage2.json',
                //   width: 250,
                //   height: 250,
                // ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Learn from Anytime",
                  style: GoogleFonts.jost(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Booked or Same the Lectures for Future",
                  style: GoogleFonts.jost(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Signinpage()));
              },
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(213, 226, 245, 1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 10,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(9, 97, 245, 1),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, top: 10, right: 5, bottom: 10),
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(9, 97, 245, 1),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Get Started",
                          style: GoogleFonts.jost(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
