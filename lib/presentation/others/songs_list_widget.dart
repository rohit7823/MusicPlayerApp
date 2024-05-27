import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/models/response.dart';
import 'package:music_player_app/presentation/theme/colors.dart';
import 'package:music_player_app/presentation/theme/images.dart';
import 'package:music_player_app/presentation/utill/categories.dart';

class SongsListWidget extends StatefulWidget {
  const SongsListWidget(
      {super.key,
      required this.songs,
      required this.onTapMusic,
      this.onView,
      required this.selected,
      required this.category});

  final RxList<Music> songs;
  final void Function(Music music) onTapMusic;
  final void Function(Music music)? onView;
  final Rx<Music?> selected;
  final Rx<Categories> category;

  @override
  State<SongsListWidget> createState() => _SongsListWidgetState();
}

class _SongsListWidgetState extends State<SongsListWidget> {
  Map<int, TableColumnWidth> colWidths = {};
  Worker? _worker;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: ObxValue(
          (musics) => AnimatedCrossFade(
              firstChild: widget.category.value == Categories.occasion
                  ? Table(
                      columnWidths: {
                        0: FixedColumnWidth(Get.width * .30),
                        1: FixedColumnWidth(Get.width * .75),
                        2: FixedColumnWidth(Get.width * .40),
                        3: FixedColumnWidth(Get.width * .40),
                        4: FixedColumnWidth(Get.width * .40),
                      },
                      children: [
                        TableRow(
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 8),
                                child: Text(
                                  "Select",
                                  style: Get.textTheme.titleMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                              TableCell(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Song Title",
                                  style: Get.textTheme.titleMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                              TableCell(
                                  child: Obx(() => widget.category.value ==
                                              Categories.occasion ||
                                          widget.category.value ==
                                              Categories.all
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            "Occasion",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        )
                                      : const SizedBox.shrink())),
                              TableCell(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Amount",
                                  style: Get.textTheme.titleMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                            ],
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 2)),
                            )),
                        ...musics.map((music) => TableRow(
                              children: [
                                TableRowInkWell(
                                  onTap: () => widget.onView?.call(music),
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: InkWell(
                                      onTap: () => widget.onTapMusic(music),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ObxValue(
                                              (selectedMusic) =>
                                                  selectedMusic.value == music
                                                      ? Image.asset(
                                                          Images.accentGif,
                                                          width: 32,
                                                          color: Colors.blue,
                                                        )
                                                      : Image.asset(
                                                          Images.play100Png,
                                                          width: 32,
                                                          color: Colors.blue,
                                                        ),
                                              widget.selected),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            music.name ?? "",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    color:
                                                        widget.selected.value ==
                                                                music
                                                            ? AppColor.secondary
                                                            : Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    )),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Obx(() => widget.category.value ==
                                                Categories.occasion ||
                                            widget.category.value ==
                                                Categories.all
                                        ? Text(
                                            music.occasion ?? "",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    color:
                                                        widget.selected.value ==
                                                                music
                                                            ? AppColor.secondary
                                                            : Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )
                                        : const SizedBox.shrink())),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text(
                                      "\$ ${int.parse(music.amount ?? "0").toStringAsPrecision(3)}",
                                      style: Get.textTheme.titleMedium!
                                          .copyWith(
                                              color:
                                                  widget.selected.value == music
                                                      ? AppColor.secondary
                                                      : Colors.white,
                                              fontWeight: FontWeight.bold),
                                    )),
                              ],
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColor.background, width: 1)),
                              ),
                            ))
                      ],
                    )
                  : widget.category.value == Categories.genre
                      ? Table(
                          columnWidths: {
                            0: FixedColumnWidth(Get.width * .30),
                            1: FixedColumnWidth(Get.width * .75),
                            2: FixedColumnWidth(Get.width * .40),
                            3: FixedColumnWidth(Get.width * .40),
                            4: FixedColumnWidth(Get.width * .40),
                          },
                          children: [
                            TableRow(
                                children: [
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 8),
                                    child: Text(
                                      "Select",
                                      style: Get.textTheme.titleMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                      "Song Title",
                                      style: Get.textTheme.titleMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  TableCell(
                                      child: Obx(() => widget.category.value ==
                                                  Categories.genre ||
                                              widget.category.value ==
                                                  Categories.all
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              child: Text(
                                                "Genres",
                                                style: Get
                                                    .textTheme.titleMedium!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            )
                                          : const SizedBox.shrink())),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                      "Amount",
                                      style: Get.textTheme.titleMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ))
                                ],
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.white, width: 2)),
                                )),
                            ...musics.map((music) => TableRow(
                                  children: [
                                    TableRowInkWell(
                                      onTap: () => widget.onView?.call(music),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: InkWell(
                                          onTap: () => widget.onTapMusic(music),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ObxValue(
                                                  (selectedMusic) =>
                                                      selectedMusic.value ==
                                                              music
                                                          ? Image.asset(
                                                              Images.accentGif,
                                                              width: 32,
                                                              color:
                                                                  Colors.blue,
                                                            )
                                                          : Image.asset(
                                                              Images.play100Png,
                                                              width: 32,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                  widget.selected),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                music.name ?? "",
                                                style: Get
                                                    .textTheme.titleMedium!
                                                    .copyWith(
                                                        color: widget.selected
                                                                    .value ==
                                                                music
                                                            ? AppColor.secondary
                                                            : Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        )),
                                    TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Obx(() => widget
                                                        .category.value ==
                                                    Categories.genre ||
                                                widget.category.value ==
                                                    Categories.all
                                            ? Text(
                                                music.genre ?? "",
                                                style: Get
                                                    .textTheme.titleMedium!
                                                    .copyWith(
                                                        color: widget.selected
                                                                    .value ==
                                                                music
                                                            ? AppColor.secondary
                                                            : Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              )
                                            : const SizedBox.shrink())),
                                    TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Text(
                                          "\$ ${double.parse(music.amount ?? "0")}",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color:
                                                      widget.selected.value ==
                                                              music
                                                          ? AppColor.secondary
                                                          : Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: AppColor.background,
                                            width: 1)),
                                  ),
                                ))
                          ],
                        )
                      : widget.category.value == Categories.mood
                          ? Table(
                              columnWidths: {
                                0: FixedColumnWidth(Get.width * .30),
                                1: FixedColumnWidth(Get.width * .75),
                                2: FixedColumnWidth(Get.width * .40),
                                3: FixedColumnWidth(Get.width * .40),
                                4: FixedColumnWidth(Get.width * .40),
                              },
                              children: [
                                TableRow(
                                    children: [
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 8),
                                        child: Text(
                                          "Select",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text(
                                          "Song Title",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      TableCell(
                                          child: Obx(() => widget
                                                          .category.value ==
                                                      Categories.mood ||
                                                  widget.category.value ==
                                                      Categories.all
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: Text(
                                                    "Moods",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                )
                                              : const SizedBox.shrink())),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text(
                                          "Amount",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                    ],
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.white, width: 2)),
                                    )),
                                ...musics.map((music) => TableRow(
                                      children: [
                                        TableRowInkWell(
                                          onTap: () =>
                                              widget.onView?.call(music),
                                          child: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: InkWell(
                                              onTap: () =>
                                                  widget.onTapMusic(music),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ObxValue(
                                                      (selectedMusic) =>
                                                          selectedMusic.value ==
                                                                  music
                                                              ? Image.asset(
                                                                  Images
                                                                      .accentGif,
                                                                  width: 32,
                                                                  color: Colors
                                                                      .blue,
                                                                )
                                                              : Image.asset(
                                                                  Images
                                                                      .play100Png,
                                                                  width: 32,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                      widget.selected),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    music.name ?? "",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: widget
                                                                        .selected
                                                                        .value ==
                                                                    music
                                                                ? AppColor
                                                                    .secondary
                                                                : Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
                                                ],
                                              ),
                                            )),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Obx(() => widget
                                                            .category.value ==
                                                        Categories.mood ||
                                                    widget.category.value ==
                                                        Categories.all
                                                ? Text(
                                                    music.mood ?? "",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: widget
                                                                        .selected
                                                                        .value ==
                                                                    music
                                                                ? AppColor
                                                                    .secondary
                                                                : Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
                                                : const SizedBox.shrink())),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Text(
                                              "\$ ${double.parse(music.amount ?? "0")}",
                                              style: Get.textTheme.titleMedium!
                                                  .copyWith(
                                                      color: widget.selected
                                                                  .value ==
                                                              music
                                                          ? AppColor.secondary
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )),
                                      ],
                                      decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppColor.background,
                                                width: 1)),
                                      ),
                                    ))
                              ],
                            )
                          : Table(
                              columnWidths: {
                                0: FixedColumnWidth(Get.width * .30),
                                1: FixedColumnWidth(Get.width * .75),
                                2: FixedColumnWidth(Get.width * .40),
                                3: FixedColumnWidth(Get.width * .40),
                                4: FixedColumnWidth(Get.width * .40),
                                5: FixedColumnWidth(Get.width * .40)
                              },
                              children: [
                                TableRow(
                                    children: [
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 8),
                                        child: Text(
                                          "Select",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text(
                                          "Song Title",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      TableCell(
                                          child: Obx(() => widget
                                                          .category.value ==
                                                      Categories.occasion ||
                                                  widget.category.value ==
                                                      Categories.all
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: Text(
                                                    "Occasion",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                )
                                              : const SizedBox.shrink())),
                                      TableCell(
                                          child: Obx(() => widget
                                                          .category.value ==
                                                      Categories.genre ||
                                                  widget.category.value ==
                                                      Categories.all
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: Text(
                                                    "Genres",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                )
                                              : const SizedBox.shrink())),
                                      TableCell(
                                          child: Obx(() => widget
                                                          .category.value ==
                                                      Categories.mood ||
                                                  widget.category.value ==
                                                      Categories.all
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: Text(
                                                    "Moods",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                )
                                              : const SizedBox.shrink())),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text(
                                          "Amount",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                    ],
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.white, width: 2)),
                                    )),
                                ...musics.map((music) => TableRow(
                                      children: [
                                        TableRowInkWell(
                                          onTap: () =>
                                              widget.onView?.call(music),
                                          child: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: InkWell(
                                              onTap: () =>
                                                  widget.onTapMusic(music),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ObxValue(
                                                      (selectedMusic) =>
                                                          selectedMusic.value ==
                                                                  music
                                                              ? Image.asset(
                                                                  Images
                                                                      .accentGif,
                                                                  width: 32,
                                                                  color: Colors
                                                                      .blue,
                                                                )
                                                              : Image.asset(
                                                                  Images
                                                                      .play100Png,
                                                                  width: 32,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                      widget.selected),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    music.name ?? "",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: widget
                                                                        .selected
                                                                        .value ==
                                                                    music
                                                                ? AppColor
                                                                    .secondary
                                                                : Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
                                                ],
                                              ),
                                            )),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Obx(() => widget
                                                            .category.value ==
                                                        Categories.occasion ||
                                                    widget.category.value ==
                                                        Categories.all
                                                ? Text(
                                                    music.occasion ?? "",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: widget
                                                                        .selected
                                                                        .value ==
                                                                    music
                                                                ? AppColor
                                                                    .secondary
                                                                : Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
                                                : const SizedBox.shrink())),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Obx(() => widget
                                                            .category.value ==
                                                        Categories.genre ||
                                                    widget.category.value ==
                                                        Categories.all
                                                ? Text(
                                                    music.genre ?? "",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: widget
                                                                        .selected
                                                                        .value ==
                                                                    music
                                                                ? AppColor
                                                                    .secondary
                                                                : Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
                                                : const SizedBox.shrink())),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Obx(() => widget
                                                            .category.value ==
                                                        Categories.mood ||
                                                    widget.category.value ==
                                                        Categories.all
                                                ? Text(
                                                    music.mood ?? "",
                                                    style: Get
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: widget
                                                                        .selected
                                                                        .value ==
                                                                    music
                                                                ? AppColor
                                                                    .secondary
                                                                : Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
                                                : const SizedBox.shrink())),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Text(
                                              "\$ ${double.tryParse(music.amount ?? "0")}",
                                              style: Get.textTheme.titleMedium!
                                                  .copyWith(
                                                      color: widget.selected
                                                                  .value ==
                                                              music
                                                          ? AppColor.secondary
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )),
                                      ],
                                      decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppColor.background,
                                                width: 1)),
                                      ),
                                    ))
                              ],
                            ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: musics.isNotEmpty
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500)),
          widget.songs),
    );
  }
}
