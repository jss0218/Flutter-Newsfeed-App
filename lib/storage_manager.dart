import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'post.dart';

class StorageManager {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/posts.json');
  }

  static Future<File> writePosts(List<Post> posts) async {
    final file = await _localFile;
    return file.writeAsString(json.encode(posts.map((post) => post.toJson()).toList()));
  }

  static Future<List<Post>> readPosts() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((data) => Post.fromJson(data)).toList();
    } catch (e) {
      return [];
    }
  }
}
