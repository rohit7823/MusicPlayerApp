import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/presentation/theme/colors.dart';
import 'package:music_player_app/presentation/theme/images.dart';
import 'package:transparent_image/transparent_image.dart';

class CoverImageWidget extends StatelessWidget {
  const CoverImageWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: Get.width * .10),
      height: Get.height * .25,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.secondary,
      ),
      child: imageUrl.isURL
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: imageUrl,
              fadeInCurve: Curves.easeInExpo,
              fadeOutCurve: Curves.easeOutExpo,
              fit: BoxFit.fitHeight,
              placeholderFit: BoxFit.fitHeight,
              imageErrorBuilder: (context, error, stackTrace) =>
                  Image.memory(kTransparentImage),
            )
          : Image.asset(Images.placeHolderPng),
    );
  }
}
