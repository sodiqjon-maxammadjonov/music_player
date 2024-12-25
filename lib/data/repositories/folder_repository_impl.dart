import '../../domain/repositories/folder_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/folder_model.dart';

class FolderRepositoryImpl implements FolderRepository {
  final DatabaseHelper databaseHelper;

  FolderRepositoryImpl({required this.databaseHelper});

  @override
  Future<int> insertFolder(FolderModel folder) async {
    return await databaseHelper.insertFolder(folder.toMap());
  }

  @override
  Future<List<FolderModel>> getAllFolders() async {
    final List<Map<String, dynamic>> maps = await databaseHelper.getAllFolders();
    return List.generate(maps.length, (i) {
      return FolderModel.fromMap(maps[i]);
    });
  }
}