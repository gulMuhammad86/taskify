class Todo {
  int? id;
  String? name;
  String? description;
  String? category;
  String? date;
  int? isfinished = 0;

  gettodoMap() {
    var mapping = Map<String, dynamic>();
    mapping['name'] = name;
    mapping['description'] = description;
    mapping['category'] = category;
    mapping['date'] = date;
    mapping['id'] = id;
    mapping['isfinished'] = isfinished;
    return mapping;
  }
}
