import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/models/response.dart';
import 'package:music_player_app/presentation/theme/colors.dart';
import 'package:transparent_image/transparent_image.dart';

import '../theme/images.dart';

/*
  Audio player widget handles all kinds of audio controls.
*/

class MusicPlayerWidget extends StatelessWidget {
  const MusicPlayerWidget(
      {super.key,
      required this.selectedMusic,
      required this.baseUrl,
      required this.onTapPrevMusic,
      required this.onPrevPosition,
      required this.positionStream,
      required this.bufferedPositionStream,
      required this.totalDurationStream,
      required this.onTapNextMusic,
      required this.onNextPosition,
      required this.pauseMusic,
      required this.playMusic,
      required this.onSeek,
      required this.playerState,
      required this.volumeSliderVisibility,
      required this.toggleVolumeSliderVisibility,
      required this.volumeStream,
      required this.setVolume});

  final void Function() onTapPrevMusic;
  final void Function() onTapNextMusic;
  final void Function() onPrevPosition;
  final void Function() onNextPosition;
  final void Function() pauseMusic;
  final void Function() playMusic;
  final void Function(Duration duration) onSeek;
  final void Function() toggleVolumeSliderVisibility;
  final void Function(double vol) setVolume;
  final Rx<Music?> selectedMusic;
  final String baseUrl;
  final Stream<Duration?> positionStream;
  final Stream<Duration?> bufferedPositionStream;
  final Stream<Duration?> totalDurationStream;
  final Stream<PlayerState> playerState;
  final Rx<bool> volumeSliderVisibility;
  final Stream<double> volumeStream;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => AnimatedSwitcher(
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.linearToEaseOut,
              duration: const Duration(milliseconds: 500),
              child: volumeSliderVisibility.value
                  ? Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      insetPadding: EdgeInsets.zero,
                      child: StreamBuilder(
                        stream: volumeStream,
                        builder: (context, snapshot) => Slider(
                          value: snapshot.data ?? 0.0,
                          onChanged: setVolume,
                          thumbColor: Colors.redAccent,
                          activeColor: Colors.redAccent,
                          allowedInteraction: SliderInteraction.slideThumb,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            )),
        ColoredBox(
          color: Color.alphaBlend(AppColor.primary, AppColor.onBackground),
          child: SizedBox(
            height: Get.height * .10,
            child: Builder(
              builder: (BuildContext context) => Row(
                children: [
                  Expanded(
                    child: ObxValue(
                        (music) => Container(
                              height: context.height,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: const BoxDecoration(
                                  color: AppColor.secondary,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12))),
                              child: "$baseUrl${music.value?.image}".isURL
                                  ? FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: "$baseUrl${music.value?.image}",
                                      fadeInCurve: Curves.easeInExpo,
                                      fadeOutCurve: Curves.easeOutExpo,
                                      fit: BoxFit.scaleDown,
                                      placeholderFit: BoxFit.fitHeight,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.memory(kTransparentImage))
                                  : Image.asset(
                                      Images.placeHolderPng,
                                    ),
                            ),
                        selectedMusic),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * .05),
                                child: GestureDetector(
                                  onTap: onTapPrevMusic,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Image.asset(
                                      Images.startPng,
                                      width: 20,
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: onPrevPosition,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Image.asset(
                                    Images.prevPng,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                              StreamBuilder(
                                stream: playerState,
                                builder: (context, snapshot) => snapshot
                                            .data?.playing ==
                                        true
                                    ? GestureDetector(
                                        onTap: pauseMusic,
                                        child: Image.asset(
                                          Images.pause100Png,
                                          width: 50,
                                          height: 50,
                                          color: Colors.white,
                                        ),
                                      )
                                    : snapshot.data?.processingState ==
                                                ProcessingState.loading ||
                                            snapshot.data?.processingState ==
                                                ProcessingState.buffering
                                        ? const SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeCap: StrokeCap.round,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: playMusic,
                                            child: Image.asset(
                                              Images.play100Png,
                                              color: Colors.white,
                                              width: 50,
                                              height: 50,
                                            ),
                                          ),
                              ),
                              GestureDetector(
                                onTap: onNextPosition,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Image.asset(
                                    Images.nextPng,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * .05),
                                child: GestureDetector(
                                  onTap: onTapNextMusic,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Image.asset(
                                      Images.end50Png,
                                      width: 20,
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 46,
                                height: 46,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(100)),
                                child: InkWell(
                                  onTap: toggleVolumeSliderVisibility,
                                  child: StreamBuilder(
                                    stream: volumeStream,
                                    builder: (context, snapshot) =>
                                        snapshot.data == 0.0
                                            ? const Icon(
                                                Icons.volume_off,
                                                color: AppColor.secondary,
                                              )
                                            : const Icon(
                                                Icons.volume_up,
                                                color: AppColor.secondary,
                                              ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: StreamBuilder(
                              stream: totalDurationStream,
                              builder: (context, totalDuration) =>
                                  StreamBuilder(
                                stream: bufferedPositionStream,
                                builder: (context, position) => StreamBuilder(
                                  stream: positionStream,
                                  builder: (context, snapshot) => ProgressBar(
                                    thumbColor: Colors.redAccent,
                                    progress: snapshot.data ?? Duration.zero,
                                    total: totalDuration.data ?? Duration.zero,
                                    buffered: position.data ?? Duration.zero,
                                    baseBarColor: Colors.white,
                                    onSeek: onSeek,
                                    thumbGlowRadius: 5,
                                    bufferedBarColor:
                                        AppColor.secondary.withAlpha(80),
                                    progressBarColor: Colors.redAccent,
                                    timeLabelTextStyle:
                                        Get.textTheme.labelMedium!.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                    timeLabelLocation: TimeLabelLocation.sides,
                                    timeLabelPadding: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
