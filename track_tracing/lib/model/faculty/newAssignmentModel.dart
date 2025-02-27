class NewAssignemntModel {
  String? topicName;
  String? description;
  String? deadline;
  String? assignmentName;
  String? attachedFileName;
  String? attachedFileUrl;

  NewAssignemntModel({
    this.topicName,
    this.description,
    this.deadline,
    this.assignmentName,
    this.attachedFileName,
    this.attachedFileUrl,
  }); 

  Map<String,dynamic> toMap()  {
    return {
      'topicName': topicName,
      'description': description,
      'deadline': deadline,
      'assignmentName': assignmentName,
      'attachedFileName': attachedFileName,
      'attachedFileUrl': attachedFileUrl,
    };
  }

}