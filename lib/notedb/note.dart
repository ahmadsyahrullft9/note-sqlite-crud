class Note {
  int id;
  String title, desc;

  Note({this.id, this.title, this.desc}) : assert(title != null);

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "desc": desc};
  }
}
