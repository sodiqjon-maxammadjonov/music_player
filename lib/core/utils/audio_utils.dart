import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioUtils {
  static Future<List<File>> getAudioFiles(String folderName) async {
    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}/$folderName');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return folder.listSync().where((item) => item.path.endsWith('.mp3')).map((item) => File(item.path)).toList();
  }
}