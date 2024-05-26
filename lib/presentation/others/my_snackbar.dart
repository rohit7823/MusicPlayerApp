import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySnackbar {
  MySnackbar._internal();

  static MySnackbar instance = MySnackbar._internal();

  GetSnackBar get(
      {required BuildContext context,
      required String title,
      required String msg,
      Color? color,
      Duration? duration}) {
    return GetSnackBar(
      title: title,
      messageText: Text(msg,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      snackPosition: SnackPosition.TOP,
      backgroundColor: color ?? Colors.redAccent,
      icon: Icon(
        Icons.error,
        color: color != null ? Colors.black87 : Colors.white,
      ),
      dismissDirection: DismissDirection.horizontal,
      mainButton: TextButton(
          onPressed: () => Get.closeCurrentSnackbar(),
          child: Text("OK",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: color != null ? Colors.black87 : Colors.white))),
      duration: duration ?? const Duration(seconds: 2),
    );
  }
}
