import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:si_angkot/core/app_routes.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_utils.dart';

class DriverController extends GetxController {
  //---------------SCANNER----------------
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  var dutyStatusList = <String>[Constant.DELIVER, Constant.DEPARTURE];

  var nameTemp = "".obs;
  var pictTemp = "".obs;
  var addressTemp = "".obs;
  var phoneTemp = "".obs;
  var emailTemp = "".obs;

  var selectedStatusIndex = 0.obs;
  var bottomNavIndex = 0.obs;

  void setDataInfo(
      String name, String pict, String address, String phone, String email) {
    nameTemp.value = name;
    addressTemp.value = address;
    pictTemp.value = pict;
    phoneTemp.value = phone;
    emailTemp.value = email;
  }

  var carRoutesDeliver = <String>[
    'Bok Malang',
    'Pilang Werda',
    'Lapangan Pilang Bango',
    'Pilang Mulya',
    'Lapangan Rejomulyo',
    'Pelita Tama',
    'Imam Bonjol',
    'Diponegoro',
    'Biliton',
    'Kompol Sunaryo',
    'Dr. Soetomo',
    'Sumatera',
    'Pahlawan',
    'Kartini',
    'Jawa',
    'Pahlawan',
    'Cokroaminoto',
    'Citandui',
    'H. A. Salim',
    'Kol. Marhadi',
    'Alun-Alun',
  ].obs;

  var carRoutesDepart = <String>[
    'Alun-Alun',
    'Pandan',
    'A. Yani',
    'Pahlawan',
    'Kartini',
    'Jawa',
    'Pahlawan',
    'Sumatera',
    'Dr. Soetomo',
    'Kompol Sunaryo',
    'Biliton',
    'Diponegoro',
    'Imam Bonjol',
    'Pelita Tama',
    'Lapangan Rejomulyo',
    'Lapangan Pilangbango',
    'Pilang Werda',
    'Bok Malang',
  ].obs;

  void selectStatus(int index) {
    selectedStatusIndex.value = index;
  }

  void selectBottomNav(int index) {
    if (index == 1) {
      // Jika menu Scan QR ditekan, langsung navigasi ke halaman ScanQRPage
      Get.toNamed(AppRoutes.driverBaseScan);
    } else {
      // Mapping index bottom navigation ke index halaman:
      // tappedIndex 0 -> Beranda (0)
      // tappedIndex 2 -> History (1)
      // tappedIndex 3 -> Pengaturan (2)
      if (index == 0) {
        bottomNavIndex.value = 0;
      } else if (index == 2) {
        bottomNavIndex.value = 1;
      } else if (index == 3) {
        bottomNavIndex.value = 2;
      }
    }
  }
}
