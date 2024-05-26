import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/presentation/theme/colors.dart';
import 'package:music_player_app/presentation/theme/images.dart';
import 'package:music_player_app/presentation/utill/drawer_menus.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key, required this.menus, required this.onSelect});

  final List<DrawerMenus> menus;
  final void Function(DrawerMenus menu) onSelect;

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  DrawerMenus selected = DrawerMenus.songs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(
                top: Get.width * .05,
                left: Get.width * .05,
                right: Get.width * .05,
                bottom: Get.width * .10),
            child: Image.asset(
              Images.logoPng,
              width: 70,
            )),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: widget.menus
                  .map(
                    (menu) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(
                            menu.icon,
                          ),
                          title: Text(
                            menu.menu,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          horizontalTitleGap: 0,
                          dense: true,
                          minVerticalPadding: 10,
                          onTap: () => setState(() {
                            selected = menu;
                            widget.onSelect(menu);
                          }),
                          selected: selected == menu,
                          style: ListTileStyle.drawer,
                          selectedTileColor: selected == menu
                              ? AppColor.secondary
                              : Colors.transparent,
                        ),
                        const Divider(
                          color: Colors.white,
                          indent: 15,
                          endIndent: 15,
                        )
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
