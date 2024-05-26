import 'package:get/get.dart';
import 'package:music_player_app/global/rest_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RestController());
  }
}
