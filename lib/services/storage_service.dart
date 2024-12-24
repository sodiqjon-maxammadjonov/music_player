import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  late Directory _appDir;

  static Future<StorageService> init() async {
    final service = StorageService();
    await service._initialize();
    return service;
  }

  Future<void> _initialize() async {
    _appDir = await getApplicationDocumentsDirectory();
    // Create necessary directories
    await Directory('${_appDir.path}/artworks').create(recursive: true);
  }

  Future<String> saveArtwork(List<int> artworkData, String name) async {
    final file = File('${_appDir.path}/artworks/$name.jpg');
    await file.writeAsBytes(artworkData);
    return file.path;
  }

  Future<bool> fileExists(String path) async {
    return File(path).exists();
  }

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}