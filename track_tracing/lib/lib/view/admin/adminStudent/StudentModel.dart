class StudentInfo {
  final String name;
  final String graduate;
  final String role;
  final String studentID;
  final String registrationDate;
  final String dateOfBirth;
  final String bloodGroup;
  final String specialization;
  final String email;
  final String emergencyContactName;
  final String emergencyContact;

  StudentInfo({
    required this.name,
    required this.graduate,
    required this.role,
    required this.studentID,
    required this.registrationDate,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.specialization,
    required this.email,
    required this.emergencyContactName,
    required this.emergencyContact,
  });

Map<String, dynamic> toMap() {
    return {
      "Name": name,
      "Graduate": graduate,
      "Role": role,
      "StudentID": studentID,
      "RegistrationDate": registrationDate,
      "DateOfBirth": dateOfBirth,
      "BloodGroup": bloodGroup,
      "Specialization": specialization,
      "Email": email,
      "EmergencyContactName": emergencyContactName,
      "EmergencyContact": emergencyContact,
    };
  }
}
