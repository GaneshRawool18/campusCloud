import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/controller/student/authservice.dart';
import 'package:track_tracing/controller/student/sharedPreference.dart';
import 'package:track_tracing/view/student/Login/signinPage.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.jost(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
            size: 25,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 84, 178, 254),
        actions: [
          IconButton(
            onPressed: () {
              SharedPreferenceController.setData(isLogin: false, studentID: "");
              Authservice().signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Signinpage()),
                  (route) => false);
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _adminInfoCard(),
            _profileInfoCard(),
            // _passwordManagerCard(),
            _languageSettingsCard(),
            _contactSupportCard(),
          ],
        ),
      ),
    );
  }

  Widget _adminInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.admin_panel_settings, color: Colors.blue),
        title: Text(
          'Admin',
          style: GoogleFonts.mulish(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _profileInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style:
                  GoogleFonts.mulish(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Admin Name'),
              subtitle: Text('Yashodip Thakare',
                  style: GoogleFonts.mulish(fontSize: 16)),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Email'),
              subtitle: Text('ganu123@gmail.com',
                  style: GoogleFonts.mulish(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordManagerCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password Manager',
              style:
                  GoogleFonts.mulish(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.lock),
                    label: const Text('Change Password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageSettingsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.language, color: Colors.blue),
        title: Text(
          'Language Settings',
          style: GoogleFonts.mulish(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Selected Language: English'),
      ),
    );
  }

  Widget _contactSupportCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Support',
              style:
                  GoogleFonts.mulish(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('Email'),
              subtitle: Text('eduCompany@gmail.com'),
            ),
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.blue),
              title: Text('Call Us'),
              subtitle: Text('12345678'),
            ),
          ],
        ),
      ),
    );
  }
}
