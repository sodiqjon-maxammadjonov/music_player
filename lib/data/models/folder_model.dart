class FolderModel {
  final int id;
  final String path;
  final String name;

  FolderModel({
    required this.id,
    required this.path,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'name': name,
    };
  }

  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel(
      id: map['id'],
      path: map['path'],
      name: map['name'],
    );
  }
}