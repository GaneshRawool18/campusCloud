class AdminDepartmentModel {
  final String? department;
  final String? enrolledStudents;
  final String? totalCapacity;
  final String? totalSem;

  AdminDepartmentModel({
    this.department,
    this.enrolledStudents,
    this.totalCapacity,
    this.totalSem,
  });

  Map<String, dynamic> toMap() {
    return {
      "department": department!,
      "EnrolledStudents": enrolledStudents!,
      "TotalCapacity": totalCapacity!,
      "totalSem": totalSem!
    };
  }
}
