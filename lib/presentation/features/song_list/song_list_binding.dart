import 'package:get/get.dart';

import 'song_list_controller.dart';

class SongListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SongListController());
  }
}
