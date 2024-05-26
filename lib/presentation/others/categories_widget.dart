import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/models/response.dart';
import 'package:music_player_app/presentation/theme/colors.dart';

import '../utill/categories.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {super.key,
      required this.selectedCategory,
      required this.onTapCategory,
      required this.filterMusics,
      required this.musics,
      required this.menuController});

  final void Function(Categories category) onTapCategory;
  final void Function(String? categoryKey) filterMusics;
  final Categories selectedCategory;
  final List<Music?> musics;
  final TextEditingController menuController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Categories.values
                .map(
                  (category) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: OutlinedButton(
                      onPressed: () => onTapCategory(category),
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              selectedCategory == category
                                  ? Get.theme.colorScheme.secondary
                                  : Colors.transparent),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Get.theme.colorScheme.secondary),
                              borderRadius: BorderRadius.circular(8))),
                          side: WidgetStatePropertyAll(BorderSide(
                              color: Get.theme.colorScheme.secondary))),
                      child: Text(
                        category.category,
                        style: Get.textTheme.titleLarge!.copyWith(
                            color: selectedCategory == category
                                ? Colors.white
                                : Get.theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        selectedCategory == Categories.occasion ||
                selectedCategory == Categories.genre ||
                selectedCategory == Categories.mood
            ? Padding(
                padding: EdgeInsets.only(right: Get.width * .02, top: 10),
                child: DropdownMenu(
                  controller: menuController,
                  dropdownMenuEntries: _getEntries(),
                  width: Get.width * .50,
                  textStyle: Get.textTheme.titleMedium!.copyWith(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.w900),
                  hintText: "Select an option",
                  onSelected: (value) => filterMusics(value),
                  inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.white,
                      constraints:
                          BoxConstraints(minHeight: 45, maxHeight: 45)),
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  List<DropdownMenuEntry<String?>> _getEntries() {
    Map<String?, List<Music?>> filteredCategories = {};

    if (selectedCategory == Categories.occasion) {
      filteredCategories = musics.groupListsBy(
        (element) => element?.occasion,
      );
    } else if (selectedCategory == Categories.genre) {
      filteredCategories = musics.groupListsBy(
        (element) => element?.genre,
      );
    } else if (selectedCategory == Categories.mood) {
      filteredCategories = musics.groupListsBy(
        (element) => element?.mood,
      );
    }
    return filteredCategories
        .map((key, value) => MapEntry(
            key,
            DropdownMenuEntry(
                value: key,
                labelWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        "$key",
                        style: Get.textTheme.titleMedium!.copyWith(
                            color: Get.theme.colorScheme.primary,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      "(${value.length})",
                      style: Get.textTheme.titleMedium!.copyWith(
                          color: AppColor.secondary,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
                label: '')))
        .values
        .toList();
  }
}
