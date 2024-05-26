import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/presentation/theme/images.dart';

class OverlayLoading {
  OverlayLoading._();

  static Future<T> load<T>({required Future<T> Function() asyncFunc}) async {
    return await Get.showOverlay(
      asyncFunction: () async => await asyncFunc(),
      loadingWidget: Dialog(
          insetPadding: EdgeInsets.all(Get.width * .30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: PopScope(
            canPop: false,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF19333d), width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.loadingGif,
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        " Please Wait",
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.primary),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
      opacity: .8,
    );
  }
}
