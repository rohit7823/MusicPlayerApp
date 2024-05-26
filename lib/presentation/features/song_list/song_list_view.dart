import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/presentation/others/categories_widget.dart';
import 'package:music_player_app/presentation/others/cover_image_widget.dart';
import 'package:music_player_app/presentation/others/music_player_widget.dart';
import 'package:music_player_app/presentation/others/sidebar_widget.dart';
import 'package:music_player_app/presentation/others/songs_list_widget.dart';
import 'package:music_player_app/presentation/theme/colors.dart';
import 'package:music_player_app/presentation/theme/images.dart';
import 'package:music_player_app/presentation/utill/categories.dart';
import 'package:music_player_app/presentation/utill/drawer_menus.dart';

import 'song_list_controller.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final controller = Get.find<SongListController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Image.asset(Images.img3Png),
        ),
        automaticallyImplyLeading: true,
        leadingWidth: Get.width * .50,
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => controller.toggleDrawer(Scaffold.of(context)),
              icon: Obx(() => AnimatedRotation(
                    turns: controller.isMenuOpened.value ? 90.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: controller.isMenuOpened.value
                        ? const Icon(Icons.close, color: Colors.white)
                        : const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                  )),
            ),
          )
        ],
      ),
      onDrawerChanged: controller.listenDrawerState,
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: Get.theme.colorScheme.primary,
          width: Get.width * .48,
          child: SidebarWidget(
            menus: DrawerMenus.values,
            onSelect: controller.onSelectMenu,
          ),
        ),
      ),
      backgroundColor: AppColor.background,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: ObxValue(
                  (music) => CoverImageWidget(
                      imageUrl:
                          "${controller.restController.baseUrl}${music.value?.image}"),
                  controller.selectedMusic),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.width * .05),
              child: Obx(
                () => Text(
                  controller.selectedMusic.value?.name ?? "It's Time to",
                  style: Get.textTheme.headlineMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Obx(() => Text(
                  controller.selectedCategory.value == Categories.all
                      ? "Occasion"
                      : controller.selectedCategory.value.category,
                  style: Get.textTheme.headlineSmall!.copyWith(
                      color: AppColor.secondary, fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Obx(
                () => Text(
                  "${controller.selectedMusic.value?.description}",
                  style: Get.textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Obx(
                () => Text(
                  "\$ ${int.parse(controller.selectedMusic.value?.amount ?? "0").toStringAsPrecision(3)}",
                  style: Get.textTheme.headlineMedium!.copyWith(
                      color: AppColor.secondary, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Obx(
              () => CategoriesWidget(
                selectedCategory: controller.selectedCategory.value,
                onTapCategory: controller.onTapCategory,
                musics: controller.bMusics,
                filterMusics: controller.filterMusics,
                menuController: controller.categoriesMenuController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ColoredBox(
                color: AppColor.onBackground,
                child: SongsListWidget(
                    songs: controller.musics,
                    onTapMusic: controller.startPlayingMusic,
                    selected: controller.selectedMusic,
                    onView: controller.onViewMusic,
                    category: controller.selectedCategory),
              ),
            )
          ],
        ),
      )),
      bottomNavigationBar: MusicPlayerWidget(
        selectedMusic: controller.selectedMusic,
        baseUrl: controller.restController.baseUrl,
        onTapPrevMusic: controller.prevMusic,
        onPrevPosition: controller.prev,
        positionStream: controller.player.positionStream,
        bufferedPositionStream: controller.player.bufferedPositionStream,
        totalDurationStream: controller.player.durationStream,
        onTapNextMusic: controller.nextMusic,
        onNextPosition: controller.next,
        pauseMusic: controller.pauseMusic,
        playMusic: controller.playMusic,
        onSeek: controller.onSeek,
        playerState: controller.player.playerStateStream,
        volumeSliderVisibility: controller.toggleVolumeVisibility,
        toggleVolumeSliderVisibility: controller.volumeVisibility,
        setVolume: controller.player.setVolume,
        volumeStream: controller.player.volumeStream,
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SongListController>();
    super.dispose();
  }
}
