import 'package:get/get.dart';
import 'package:si_angkot/core/app_routes.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/data/remote/auth_service.dart';
import 'package:si_angkot/data/remote/tracking_service.dart';

class DriverController extends GetxController {
  //---------------USED----------------
  final trackingService = TrackingService();
  final AuthService _authService = Get.put(AuthService());

  var currentIndex = 0.obs;
  // Form selections
  final deliveryType = ''.obs; // atau 'Penjemputan'
  final dutyType = 'OffDuty'.obs; // atau 'OnDuty'
  final selectedRoute = ''.obs; // nama route, misalnya "BOK MALANG"

  // List route names untuk dropdown
  final routeNames = <String>[].obs;
  // List alamat hasil detail route
  final addressList = <String>[].obs;

  final trackingId = ''.obs;

  var nameTemp = "".obs;
  var pictTemp = "".obs;
  var addressTemp = "".obs;
  var phoneTemp = "".obs;
  var emailTemp = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadRoutes();
  }

  void resetDataInfo() {
    nameTemp.value = "";
    addressTemp.value = "";
    pictTemp.value = "";
    phoneTemp.value = "";
    emailTemp.value = "";
  }

  void setDataInfo(
      String name, String pict, String address, String phone, String email) {
    nameTemp.value = name;
    addressTemp.value = address;
    pictTemp.value = pict;
    phoneTemp.value = phone;
    emailTemp.value = email;
  }

  Future<void> updateTrackingIdStudent(
      String studentId, String driverId) async {
    final id = trackingId.value;
    final type = deliveryType.value;

    if (studentId.isEmpty) {
      AppUtils.showSnackbar("Oops!", "Student ID tidak ditemukan",
          isError: true);
      return;
    }

    var studentProfile = await _authService.getUserProfile(studentId);
    if (studentProfile == null) {
      AppUtils.showSnackbar("Oops!", "User tidak ditemukan", isError: true);
      return;
    }

    await trackingService.updateTrackingIdStudent(
      studentId: studentId,
      trackingId: id,
      onResult: (isSuccess, message) {
        if (!isSuccess) {
          AppUtils.showSnackbar("Oops!", "Gagal Memperbarui Data Student",
              isError: true);
          return;
        }
      },
    );

    await trackingService.saveHistory(
      studentId: studentId,
      driverId: driverId,
      dutyType: type,
      trackingId: id,
      onResult: (isSuccess, message) {
        AppUtils.showSnackbar(
          isSuccess ? "Berhasil" : "Gagal",
          message,
          isError: !isSuccess,
        );
      },
    );
  }

  // Ambil list nama routes dari Firebase
  void loadRoutes() async {
    var names = await trackingService.fetchRouteNames();
    routeNames.assignAll(names);
  }

  void findNISN(String nisn, String driverID) async {
    final studentId = await _authService.getUserIdByNISN(nisn);
    if (studentId != null) {
      //Function untuk add history ke Firebase
      await trackingService.updateTrackingIdStudent(
        studentId: studentId,
        trackingId: trackingId.value,
        onResult: (isSuccess, message) {
          if (!isSuccess) {
            AppUtils.showSnackbar("Oops!", "Gagal Memperbarui Data Student",
                isError: true);
            return;
          }
        },
      );
      await trackingService.saveHistory(
        studentId: studentId,
        driverId: driverID,
        dutyType: deliveryType.value,
        trackingId: trackingId.value,
        onResult: (isSuccess, message) {
          if (isSuccess) {
            AppUtils.showSnackbar("Berhasil", message);
          } else {
            AppUtils.showSnackbar("Gagal", message, isError: true);
          }
        },
      );
    } else {
      AppUtils.showSnackbar(
        "Terjadi Kesalahan",
        "NISN tidak ditemukan",
        isError: true,
      );
    }
  }

  /// Simpan data tracking dan ambil detail alamat berdasarkan pilihan
  /// misalnya: jika deliveryType Penjemputan maka ambil routesDropOff
  Future<void> saveTrackingAndFetchRouteDetail(String driverID) async {
    if (selectedRoute.value.isEmpty) return;

    // Simpan data tracking ke Firebase
    String id = await trackingService.saveTracking(
      driverId: driverID,
      routesName: selectedRoute.value,
      dutyType: deliveryType.value,
    );
    trackingId.value = id;

    // Jika duty type OnDuty, mulai update lokasi
    if (dutyType.value == 'OnDuty') {
      trackingService.startLocationUpdates();
    }

    // Ambil detail route berdasarkan pilihan dan deliveryType
    List<String> addresses = await trackingService.fetchRouteDetail(
      selectedRoute: selectedRoute.value,
      deliveryType: deliveryType.value,
    );
    addressList.assignAll(addresses);
  }

  void changePage(int index) {
    currentIndex.value = index;
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

  //---------------UNUSED----------------
  var dutyStatusList = <String>[Constant.DELIVER, Constant.DEPARTURE];
  var selectedStatusIndex = 0.obs;
  var bottomNavIndex = 0.obs;

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
}
