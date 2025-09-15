import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast_clipboard/presenter/handler/logger_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HttpServerClientHandler {
  HttpServerClientHandler._();

  static final HttpServerClientHandler _instance = HttpServerClientHandler._();

  static HttpServerClientHandler get instance => _instance;

  final Dio _dio = Dio();

  // 下载文件并返回保存路径
  Future<String?> downloadFile({
    required String url,
    required String saveFileName, // 保存的文件名（如 "image.png"）
    void Function(int received, int total)? onProgress, // 进度回调
  }) async {
    try {
      // 1. 检查存储权限（仅Android需要，iOS根据需求配置）
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception("需要存储权限才能下载文件");
        }
      }

      // 2. 获取保存目录（例如：应用文档目录）
      final directory = await getApplicationDocumentsDirectory();
      final savePath = "${directory.path}/$saveFileName";

      // 3. 执行下载
      await _dio.download(
        url,
        savePath,
        cancelToken: CancelToken(),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // 调用进度回调（可用于更新UI进度条）
            onProgress?.call(received, total);
          }
        },
        options: Options(
          responseType: ResponseType.bytes, // 二进制响应类型
          followRedirects: true,
          validateStatus: (status) => status! < 500, // 允许重定向和非500错误
        ),
      );

      // final task = DownloadTask(
      //   url: url,
      //   filename: 'results.zip',
      //   headers: {'myHeader': 'value'},
      //   directory: directory.path,
      //   updates: Updates.statusAndProgress,
      //   requiresWiFi: true,
      //   retries: 5,
      //   allowPause: true,
      //   metaData: 'data for me',
      // );
      //
      // // Start download, and wait for result. Show progress and status changes
      // // while downloading
      // final result = await FileDownloader().download(
      //   task,
      //   onProgress: (progress) => print('Progress: ${progress * 100}%'),
      //   onStatus: (status) => print('Status: $status'),
      // );
      //
      // // Act on the result
      // switch (result.status) {
      //   case TaskStatus.complete:
      //     print('Success!');
      //
      //   case TaskStatus.canceled:
      //     print('Download was canceled');
      //
      //   case TaskStatus.paused:
      //     print('Download was paused');
      //
      //   default:
      //     print('Download not successful');
      // }

      return savePath; // 返回保存路径
    } catch (e) {
      LoggerHandler.instance.info("下载失败: $e");
      return null;
    }
  }
}
