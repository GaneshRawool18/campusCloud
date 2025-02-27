import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:track_tracing/controller/student/authservice.dart';
import 'package:track_tracing/controller/student/studentController.dart';

Database? database;
Map<String, dynamic> profileData = {};

class SqfliteController {

  Future<void> fetchStudentData(String id) 
  async {
    await Studentcontroller().fetchStudentdetails(id).then((value) {
      profileData = value;
    });
  }
//   // Initialize the database
//   Future<void> initDatabase() async {
//     log("Initializing database...");
//     if (database != null && database!.isOpen) {
//       log("Database already open.");
//       return;
//     }

//     try {
//       var databasesPath = await getDatabasesPath();
//       String path = join(databasesPath, 'online_learning_platform.db');

//       database = await openDatabase(
//         path,
//         version: 1,
//         onCreate: (db, version) async {
//           log("Creating database table...");
//           await db.execute('''
//             CREATE TABLE IF NOT EXISTS student(
//               studentID TEXT PRIMARY KEY,
//               name TEXT,
//               email TEXT,
//               bloodGroup TEXT,
//               contactNo TEXT,
//               department TEXT,s
//               dob TEXT,
//               emergencyContactName TEXT,
//               emergencyContactNo TEXT,
//               password TEXT,
//               signatureUrl TEXT,
//               profileUrl TEXT,
//               title TEXT,
//               isDone TEXT
//             )
//           ''');
//         },
//       );
//       log("Database initialized successfully.");
//     } catch (e) {
//       log("Error initializing database: $e");
//     }
//   }

//   // Read data for the current student
//   void readData() async {
//     final db = database;
//     log("Reading data from Sqflite...");
//     if (db != null) {
//       log("Student ID: ${Authservice.studentID}");
//       if (Authservice.studentID == null) {
//         log("No student ID provided.");
//         profileData = {};
//         return;
//       }

//       try {
//         var result = await db.query(
//           'student',
//           where: 'studentID = ?',
//           whereArgs: [Authservice.studentID],
//         );

//         if (result.isNotEmpty) {
//           profileData = result.first;
//           log("Profile data retrieved: $profileData");
//         } else {
//           profileData = {};
//           log("No profile data found for student ID ${Authservice.studentID}");
//         }
//       } catch (e) {
//         log("Error reading data from Sqflite: $e");
//         profileData = {};
//       }
//     } else {
//       log("Database is not initialized.");
//       profileData = {};
//     }
//   }

//   // Insert or update student data in the database
//   Future<void> insertData() async {
//     Map<String, dynamic> tmpData = {};
//     try {
//       log("Inserting or updating data in Sqflite...");
//       if (Authservice.studentID != null) {
//         tmpData = await Studentcontroller()
//             .fetchStudentdetails(Authservice.studentID!);
//         log("Fetched student details: $tmpData");
//       } else {
//         log("Student ID is null, unable to fetch details.");
//         return;
//       }

//       final db = database;
//       if (db != null) {
//         int rowsAffected = await db.update(
//           'student',
//           {...tmpData, "studentID": Authservice.studentID},
//           where: 'studentID = ?',
//           whereArgs: [Authservice.studentID],
//           conflictAlgorithm: ConflictAlgorithm.replace,
//         );

//         log("Rows affected: $rowsAffected");

//         if (rowsAffected == 0) {
//           // If no rows were affected, insert a new row
//           log("No rows updated, inserting new record...");
//           await db.insert(
//             'student',
//             {...tmpData, "studentID": Authservice.studentID},
//             conflictAlgorithm: ConflictAlgorithm.replace,
//           );
//           log("New student record inserted.");
//         }
//       }
//       readData(); // This will refresh the profileData from the database
//       log("Profile data after insert/update: $profileData");
//     } catch (e) {
//       log("Failed to insert or update in Sqflite: $e");
//     }
//   }

//   // Handle logout logic
//   void handleLogOut() {
//     log("Handling log-out...");
//     profileData = {};
//   }
// }
}