
class Skills {
  String? skillName;
  String? projectName;
  String? gitLink;
  List<String>? images;

  Skills({this.skillName, this.gitLink, this.images, this.projectName});

  Map<String, dynamic> toMap() {
    return {
      "skillName": skillName,
      "projectName": projectName,
      "gitLink": gitLink,
      "images": images,
    };
  }
}
