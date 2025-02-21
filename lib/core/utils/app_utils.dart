import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtils {
  static void showSnackbar(String title, String message,
      {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      colorText: Colors.white,
    );
  }

  static void showLoading() {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) Get.back();
  }
}
