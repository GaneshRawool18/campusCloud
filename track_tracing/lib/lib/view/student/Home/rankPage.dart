import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Ranking",
          style: GoogleFonts.jost(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shadowColor: Colors.black,
      ),
      body: Column(
        children: [
          // Header with current user's rank
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Profile Picture
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(
                        'assets/user_profile.png'), // Use a placeholder image
                  ),
                  const SizedBox(width: 15),
                  // User Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Username",
                        style: GoogleFonts.jost(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Points: 1200",
                        style: GoogleFonts.jost(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Rank Position
                  Text(
                    "#07",
                    style: GoogleFonts.jost(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Rank List
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Profile Picture for each rank entry
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            '${index + 1}',
                            style: GoogleFonts.jost(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Username and Points
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User ${index + 1}",
                              style: GoogleFonts.jost(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Points: ${1000 - (index * 100)}",
                              style: GoogleFonts.jost(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Rank Position
                        Text(
                          "#${index + 1}",
                          style: GoogleFonts.jost(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.amber[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
