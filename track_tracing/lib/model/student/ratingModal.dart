class Rating {
  String? title;
  String? description;
  int? rating;

  Rating({this.description, this.title, this.rating});

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "rating": rating,
    };
  }
}
