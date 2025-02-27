class AddCourse {
  String? courseName;
  String? courseDescription;
  String? courseDate;
  String? facultyName;
  String? semester;
  String? department;
  String? courseCode;
  int? totalTask = 0;
  String? image;

  AddCourse(
      {this.courseName,
      this.courseDescription,
      this.semester,
      this.courseDate,
      this.department,
      this.facultyName,
      this.image,
      this.courseCode});

  Map<String, dynamic> toMap() {
    return {
      "courseName": courseName,
      "courseDescription": courseDescription,
      "courseDate": courseDate,
      "faculty": facultyName,
      "semester": semester,
      "department": department,
      "images": image,
      "courseCode": courseCode,
      "enrollStudents": [],
      "totalTasks": totalTask,
      "taskCompleted" : {}
    };
  }
}
