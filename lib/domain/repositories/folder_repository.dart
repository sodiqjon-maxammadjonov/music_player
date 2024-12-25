import '../../data/models/folder_model.dart';

abstract class FolderRepository {
  Future<int> insertFolder(FolderModel folder);
  Future<List<FolderModel>> getAllFolders();
}