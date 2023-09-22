class ToDo {
  String? id; //id: daymonthyear-number
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      todoText: json['todoText'],
      isDone: json['isDone'] ?? false, // Use default value of false if 'isDone' is not present in JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
    };
  }

  static List<ToDo> todoList() {
    return [
      ToDo(id: "20092023-001", todoText: 'Shower Cold', isDone: true),
      ToDo(id: "20092023-002", todoText: 'Meditate', isDone: true),
      ToDo(id: "20092023-003", todoText: 'Wash Hair'),
      ToDo(id: "20092023-004", todoText: "Wash sheets"),
      ToDo(id: "21092023-005", todoText: "Volleyball training"),
    ];
  }
}