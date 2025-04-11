import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtils {
  static void showSnackbar(
    String title,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar(); // Cegah spam snackbar

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      colorText: Colors.white,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
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

  static String generateTrackingId(String id) {
    final DateTime now = DateTime.now();
    final String formattedDate = "yymmddHHmm".replaceAllMapped(
      RegExp(r'y|m|d|H|M'),
      (match) {
        switch (match[0]) {
          case 'y':
            return now.year.toString().substring(2, 4);
          case 'm':
            return now.month.toString().padLeft(2, '0');
          case 'd':
            return now.day.toString().padLeft(2, '0');
          case 'H':
            return now.hour.toString().padLeft(2, '0');
          case 'M':
            return now.minute.toString().padLeft(2, '0');
          default:
            return '';
        }
      },
    );
    return "$formattedDate$id";
  }
}
