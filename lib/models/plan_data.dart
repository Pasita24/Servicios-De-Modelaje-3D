class PlanData {
  final int? id;
  final String category;
  final String title;
  final String imagePath;
  final String description;

  PlanData({
    this.id,
    required this.category,
    required this.title,
    required this.imagePath,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'imagePath': imagePath,
      'description': description,
    };
  }

  factory PlanData.fromMap(Map<String, dynamic> map) {
    return PlanData(
      id: map['id'] as int?,
      category: map['category'] as String,
      title: map['title'] as String,
      imagePath: map['imagePath'] as String,
      description: map['description'] as String,
    );
  }
}
