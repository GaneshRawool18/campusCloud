

class RegistrationModel {
  String? profileUrl;
  String? name;
  String? contact;
  String? dob;
  String? bloodGroup;
  String? department;
  String? emergencyContactNo;
  String? emergencyContactName;
  String? signatureUrl;

  RegistrationModel({
    this.profileUrl,
    this.name,
    this.contact,
    this.dob,
    this.bloodGroup,
    this.department,
    this.emergencyContactNo,
    this.emergencyContactName,
    this.signatureUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "profileUrl": profileUrl,
      "name": name,
      "contactNo": contact,
      "dob": dob,
      "bloodGroup": bloodGroup,
      "department": department,
      "emergencyContactNo": emergencyContactNo,
      "emergencyContactName": emergencyContactName,
      "signatureUrl": signatureUrl,
    };
  }
}
