import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:file/file.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;


class VideoCacheManager extends CacheManager {
  static const key = 'VideoCache';
  static const maxCacheSize = 1024 * 1024 * 1024; // 1GB
  static const maxCacheAge = Duration(days: 30);


  VideoCacheManager._() : super(Config(key, stalePeriod: maxCacheAge, maxNrOfCacheObjects: maxCacheSize));
  static final VideoCacheManager instance = VideoCacheManager._();
  factory VideoCacheManager() => instance;

  @override
  Future<File> getSingleFile(
      String url, {
        String? key,
        Map<String, String>? headers,
      }) async {
    key ??= url;
    final cacheFile = await getFileFromCache(key);
    if (cacheFile != null && cacheFile.validTill.isAfter(DateTime.now())) {
       return  cacheFile.file;
    }
    return (await downloadFile(url, key: key, authHeaders: headers)).file;
  }


  @override
  Future<FileInfo> downloadFile(String url,
      {String? key,
        Map<String, String>? authHeaders,
        bool force = false}) async {
    key ??= url;
    final response = await http.get(Uri.parse(url), headers: authHeaders);
    if (response.statusCode == 200) {
      var file = await _createFile(url);
      await file.writeAsBytes(response.bodyBytes);
      await putFile(url, file.readAsBytesSync(), key: key, fileExtension: p
          .extension(url).replaceAll(".", ""), maxAge: maxCacheAge);

      return FileInfo(
        file,
        FileSource.Cache,
        DateTime.now().add(maxCacheAge),
        url,
      );
    } else {
      throw Exception('Failed to download file');
    }

  }

  Future<File> _createFile(String url) async {
    final filePath = await getFilePath();
    final fileName = Uri.parse(url).pathSegments.last;

    return await store.fileSystem.createFile('$filePath/$fileName');
  }

  Future<String> getFilePath() async {
    final directory = await getTemporaryDirectory();
    if( io.Directory('${directory.path}').existsSync() == false) {
      io.Directory('${directory.path}').createSync();
    }
    return '${directory.path}';
  }



}