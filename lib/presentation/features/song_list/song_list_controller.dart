import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_app/apis/sub_categories_api.dart';
import 'package:music_player_app/global/rest_controller.dart';
import 'package:music_player_app/models/response.dart' as r;
import 'package:music_player_app/models/response.dart';
import 'package:music_player_app/presentation/others/my_snackbar.dart';
import 'package:music_player_app/presentation/others/overlay_loading.dart';
import 'package:music_player_app/presentation/utill/categories.dart';
import 'package:music_player_app/presentation/utill/drawer_menus.dart';
import 'package:music_player_app/utill/check_internet.dart';

class SongListController extends GetxController with CheckInternet {
  final restController = Get.find<RestController>();
  SubCategoriesApi? _api;
  RxList<Music> musics = RxList.empty();
  List<r.Music> bMusics = [];
  ScaffoldState? scaffoldState;
  var isMenuOpened = false.obs;
  Rx<Music?> selectedMusic = Rx(null);
  Rx<Categories> selectedCategory = Rx(Categories.all);
  final AudioPlayer player = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStreamSubscription;
  Rx<ProcessingState> musicProcessingState = Rx(ProcessingState.idle);
  var toggleVolumeVisibility = false.obs;
  TextEditingController categoriesMenuController = TextEditingController();

  // open or close side drawer
  void toggleDrawer(ScaffoldState state) {
    scaffoldState = state;
    if (!state.isDrawerOpen) {
      state.openDrawer();
    } else {
      state.closeDrawer();
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _api = SubCategoriesApi(restController.instance!);

    // invoked when network connectivity changed.
    checkNow(
      (connectivity) {
        if (connectivity.first != ConnectivityResult.other) {
          fetchSongList();
        }
      },
    );
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    disposeInternetSubscription();
    scaffoldState = null;
    _playerStreamSubscription?.cancel();
    _playerStreamSubscription = null;
    player.dispose();
    categoriesMenuController.dispose();
  }

  // fetch songs from remote source based on a category and update ui accordingly.
  Future<void> fetchSongList({Categories category = Categories.all}) async {
    if (restController.instance == null) return;

    r.Response? response;

    switch (category) {
      case Categories.occasion:
        response = await OverlayLoading.load(asyncFunc: _api!.categories1);
      case Categories.genre:
        response = await OverlayLoading.load(asyncFunc: _api!.categories2);
      case Categories.mood:
        response = await OverlayLoading.load(asyncFunc: _api!.categories3);
      case Categories.all:
        response = await OverlayLoading.load(asyncFunc: _api!.categories0);
    }

    switch (response?.data != null && response?.data?.success == 1) {
      case true:
        var musics = response?.data?.music;
        if (musics == null) {
          Get.showSnackbar(MySnackbar.instance.get(
              context: Get.context!,
              title: "Error",
              msg:
                  "App is unable to fetch data from server, please restart this app."));
          return;
        }
        this.musics.value = musics;
        bMusics = musics;
        startPlayingMusic(musics.first);
        break;
      case false:
        Get.showSnackbar(MySnackbar.instance.get(
            context: Get.context!,
            title: "Error",
            msg:
                "App is unable to fetch data from server for some reasons, please restart this app."));
        break;
    }
  }

  // change the current music and updates ui.
  void selectMusic(Music m) {
    selectedMusic.value = m;
  }

  // invoked if any sidebar menu selected.
  void onSelectMenu(DrawerMenus menu) {
    switch (menu) {
      case DrawerMenus.home:
      // TODO: Handle this case.
      case DrawerMenus.songs:
      // TODO: Handle this case.
      case DrawerMenus.wrapInMusic:
      // TODO: Handle this case.
      case DrawerMenus.services:
      // TODO: Handle this case.
      case DrawerMenus.contactUs:
      // TODO: Handle this case.
      case DrawerMenus.login:
      // TODO: Handle this case.
      case DrawerMenus.cart:
      // TODO: Handle this case.
    }
  }

  // listens sidebar drawer current state.
  void listenDrawerState(bool isOpened) {
    isMenuOpened.value = isOpened;
  }

  // invoked when an category is selected and fetch appropriate songs from remote source.
  void onTapCategory(Categories category) {
    selectedCategory.value = category;
    categoriesMenuController.text = '';
    fetchSongList(category: category);
  }

  Duration? runningMusicDuration;

  // set an audio source and start playing that audio.
  Future<void> startPlayingMusic(Music music) async {
    selectMusic(music);
    try {
      runningMusicDuration = await player.setAudioSource(AudioSource.uri(
          Uri.parse("${restController.baseUrl}${music.musicFile}"),
          tag: MediaItem(
              id: "${music.id}",
              title: music.name ?? "",
              genre: music.genre ?? "",
              displayDescription: music.description,
              displayTitle: music.name,
              artist: music.genre,
              artUri: Uri.parse("${restController.baseUrl}${music.image}"))));

      await playMusic();
    } on PlayerException catch (e) {
      debugPrint("Error message: ${e.message}");
      Get.showSnackbar(MySnackbar.instance.get(
          context: Get.context!,
          title: "Error",
          msg: "Some error has occurred ${e.code}"));
    } on PlayerInterruptedException catch (e) {
      debugPrint("Connection aborted: ${e.message}");
    } catch (e) {
      Get.showSnackbar(MySnackbar.instance.get(
          context: Get.context!,
          title: "Error",
          msg: "Some error has occurred, please try again."));
      debugPrint('An error occurred: $e');
    }
  }

  //  updates audio position on slide.
  void onSeek(Duration value) {
    player.seek(value);
  }

  // plays the audio
  Future<void> playMusic() async {
    await player.play();
  }

  // pause the audio
  Future<void> pauseMusic() async {
    await player.pause();
  }

  // change audio position to backward or change the audio.
  void prev() async {
    if (player.duration == null) return;

    var seekDuration = player.position.inSeconds - 5;

    if (seekDuration <= 0) {
      prevMusic();
      return;
    }

    await player.seek(Duration(seconds: seekDuration));
  }

  // change audio position to forward or change the audio.
  void next() async {
    if (player.duration == null) return;

    var seekDuration = player.position.inSeconds + 5;
    var duration = player.duration!.inSeconds;

    if (seekDuration >= duration) {
      nextMusic();
      return;
    }

    await player.seek(Duration(seconds: seekDuration));
  }

  // changes the current audio to previous one
  void prevMusic() {
    if (selectedMusic.value == null) return;

    var currentIdx = musics.indexOf(selectedMusic.value);
    var music = musics.elementAtOrNull(currentIdx - 1 < 0 ? 0 : currentIdx - 1);
    if (music == null) return;
    startPlayingMusic(music);
  }

  // changes the current audio to next one
  void nextMusic() {
    if (selectedMusic.value == null) return;

    var currentIdx = musics.indexOf(selectedMusic.value);
    var music = musics.elementAtOrNull(
        currentIdx + 1 > musics.length - 1 ? 0 : currentIdx + 1);
    if (music == null) return;
    startPlayingMusic(music);
  }

  void onViewMusic(Music music) {}

  // toggle volume bar visibility
  void volumeVisibility() async {
    toggleVolumeVisibility.value = !toggleVolumeVisibility.value;
  }

  // filter musics based on selected sub-category
  void filterMusics(String? categoryKey) {
    if (categoryKey == null) return;

    categoriesMenuController.text = categoryKey;

    musics.value = bMusics
        .where(
          (element) =>
              element.occasion == categoryKey ||
              element.genre == categoryKey ||
              element.mood == categoryKey,
        )
        .toList();
  }
}
