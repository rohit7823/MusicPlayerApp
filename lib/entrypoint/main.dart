import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_app/di/global_binding.dart';
import 'package:music_player_app/presentation/navigation/main_graph.dart';
import 'package:music_player_app/presentation/navigation/routes.dart';
import 'package:music_player_app/presentation/theme/colors.dart';
import 'package:music_player_app/presentation/theme/font.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.rohit.music_player.channel.audio',
      androidNotificationChannelName: 'Music playback',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    );
    runApp(const MusicPlayerApp());
  }, (error, stack) {
    debugPrint("FATAL_ERROR $error\nSTACK $stack");
  });
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Music Player App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
              seedColor: AppColor.primary,
              primary: AppColor.primary,
              secondary: AppColor.secondary,
              surface: AppColor.background),
          useMaterial3: false,
          fontFamily: Font.joseFinSans),
      initialRoute: Routes.songsList,
      getPages: MainGraph.routes(),
      initialBinding: GlobalBinding(),
    );
  }
}
