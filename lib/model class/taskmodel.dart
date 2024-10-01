class Task {
  String id;
  String title;
  String description;
  String? priorities;
  String? categories;
  String? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.priorities,
    this.categories,
    this.dueDate,
  });

// Convert a Task into a Map (for JSON serialization)

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priorities': priorities,
      'category': categories,
      'dueDate': dueDate,
    };
  }

  // Convert a Map (from JSON) into a Task
//  rather than always creating a new instance of the class.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priorities: json['priorities'],
      categories: json['categories'],
      dueDate: json['dueDate'],
    );
  }
}
