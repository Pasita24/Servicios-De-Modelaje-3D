class PlanData {
  final int? id;
  final String category;
  final String title;
  final String imagePath;
  final String description;
  final String weapon;
  final String role;

  PlanData({
    this.id,
    required this.category,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.weapon,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'imagePath': imagePath,
      'description': description,
      'weapon': weapon,
      'role': role,
    };
  }

  factory PlanData.fromMap(Map<String, dynamic> map) {
    return PlanData(
      id: map['id'] as int?,
      category:
          map['category'] as String? ?? 'Sin categoría', // Valor por defecto
      title: map['title'] as String? ?? 'Sin título',
      imagePath: map['imagePath'] as String? ?? 'assets/images/default.png',
      description: map['description'] as String? ?? 'Sin descripción',
      weapon: map['weapon'] as String? ?? 'Desconocido',
      role: map['role'] as String? ?? 'Desconocido',
    );
  }
}
