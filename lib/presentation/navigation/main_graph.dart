import 'package:get/get.dart';
import 'package:music_player_app/presentation/features/song_list/song_list_view.dart';
import 'package:music_player_app/presentation/navigation/routes.dart';

import '../features/song_list/song_list_binding.dart';

class MainGraph {
  MainGraph._();

  static List<GetPage> routes() => [
        GetPage(
          name: Routes.songsList,
          page: () => const SongListPage(),
          binding: SongListBinding(),
        )
      ];
}
