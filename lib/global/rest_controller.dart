import 'package:dio/dio.dart';
import 'package:get/get.dart';

class RestController extends GetxController {
  Dio? _instance;

  Dio? get instance => _instance;

  String get baseUrl =>
      _instance?.options.baseUrl ?? 'https://wrappedinmusic.com';

  @override
  void onReady() {
    super.onReady();
    _instance = Dio()
      ..options = BaseOptions(
        baseUrl: 'https://wrappedinmusic.com',
        followRedirects: true,
        persistentConnection: false,
      );
  }

  @override
  void onClose() {
    super.onClose();
    _instance?.close(force: true);
    _instance = null;
  }
}
