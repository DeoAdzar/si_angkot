import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:si_angkot/core/app_routes.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/data/local/shared_prefference_helper.dart';
import 'package:si_angkot/data/remote/auth_service.dart';
import 'package:si_angkot/data/remote/tracking_service.dart';

import '../../core/constants.dart';

class DriverController extends GetxController {
  //---------------USED----------------
  final trackingService = TrackingService();
  final AuthService _authService = Get.put(AuthService());
  final ImagePicker _picker = ImagePicker(); // Init function ImagePicker

  var currentIndex = 0.obs;
  // Form selections
  final deliveryType = ''.obs; // atau 'Penjemputan'
  final dutyType = 'OffDuty'.obs; // atau 'OnDuty'
  final selectedRoute = ''.obs; // nama route, misalnya "BOK MALANG"

  // List route names untuk dropdown
  final routeNames = <String>[].obs;
  // List alamat hasil detail route
  final addressList = <String>[].obs;

  final studentIds = <String>[].obs;

  final trackingId = ''.obs;

  var nameTemp = "".obs;
  var pictTemp = "".obs;
  var addressTemp = "".obs;
  var phoneTemp = "".obs;
  var emailTemp = "".obs;

  var selectedStatusIndex = 0.obs;
  var bottomNavIndex = 0.obs;

  // Variable untuk menyimpan gambar yang diambil
  var capturedImage = Rxn<File>();
  var capturedImageBase64 = ''.obs;

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

  Future<void> takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera, // Pastikan menggunakan kamera
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear, // Gunakan kamera belakang
      );

      if (image != null) {
        capturedImage.value = File(image.path);

        // Convert gambar ke base64
        List<int> imageBytes = await capturedImage.value!.readAsBytes();
        capturedImageBase64.value = base64Encode(imageBytes);
      } else {
        AppUtils.showSnackbar("Info", "Pengambilan gambar dibatalkan",
            isError: false);
      }
    } catch (e) {
      AppUtils.showSnackbar("Error", "Gagal mengambil gambar: ${e.toString()}",
          isError: true);
    }
  }

  // Function untuk reset gambar
  void resetCapturedImage() {
    capturedImage.value = null;
    capturedImageBase64.value = '';
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

    // Reset gambar sebelumnya
    resetCapturedImage();

    // Ambil gambar terlebih dahulu
    await takePicture();

    // Cek apakah gambar berhasil diambil
    if (capturedImage.value == null) {
      AppUtils.showSnackbar("Oops!", "Gambar diperlukan untuk melanjutkan",
          isError: true);
      return;
    }

    AppUtils.showDialog(
      "Apakah Data Anda Benar?",
      "nama: ${studentProfile.name}\nnisn: ${studentProfile.nisn}\nalamat: ${studentProfile.address}\nsekolah: ${studentProfile.school}",
      image: capturedImage.value!, // Pass the captured image
      onConfirm: () async {
        // Jika user menekan tombol konfirmasi, lanjutkan dengan update
        studentIds.add(studentId);

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
          imageBase64: capturedImageBase64
              .value, // Tambahkan parameter base64 jika diperlukan
          onResult: (isSuccess, message) {
            AppUtils.showSnackbar(
              isSuccess ? "Berhasil" : "Gagal",
              message,
              isError: !isSuccess,
            );
          },
        );

        // Reset gambar setelah berhasil
        resetCapturedImage();
      },
      onCancel: () {
        // Reset gambar jika dibatalkan
        resetCapturedImage();
      },
      confirmText: "Sudah Benar",
      cancelText: "Batalkan",
      countdownSeconds: 5,
    );
  }

  void removeTrackingIdStudent(
      {required String studentId,
      required Null Function(dynamic isSuccess, dynamic message) onResult}) {
    trackingService.removeTrackingIdStudent(
      studentId: studentId,
      onResult: onResult,
    );
  }

  // Ambil list nama routes dari Firebase
  void loadRoutes() async {
    var names = await trackingService.fetchRouteNames();
    routeNames.assignAll(names);
  }

  void findNISN(String nisn, String driverID) async {
    final studentProfile = await _authService.getUserIdByNISN(nisn);
    if (studentProfile != null) {
      String studentId = studentProfile.userId;

      // Reset gambar sebelumnya
      resetCapturedImage();

      // Ambil gambar terlebih dahulu
      await takePicture();

      // Cek apakah gambar berhasil diambil
      if (capturedImage.value == null) {
        AppUtils.showSnackbar("Oops!", "Gambar diperlukan untuk melanjutkan",
            isError: true);
        return;
      }

      //Function untuk add history ke Firebase
      AppUtils.showDialog(
        "Apakah Data Anda Benar?",
        "nama: ${studentProfile.name}\nnisn: ${studentProfile.nisn}\nalamat: ${studentProfile.address}\nsekolah: ${studentProfile.school}",
        image: capturedImage.value!, // Pass the captured image
        onConfirm: () async {
          // Jika user menekan tombol konfirmasi, lanjutkan dengan update
          studentIds.add(studentId);

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
            imageBase64: capturedImageBase64
                .value, // Tambahkan parameter base64 jika diperlukan
            onResult: (isSuccess, message) {
              if (isSuccess) {
                AppUtils.showSnackbar("Berhasil", message);
              } else {
                AppUtils.showSnackbar("Gagal", message, isError: true);
              }
            },
          );

          // Reset gambar setelah berhasil
          resetCapturedImage();
        },
        onCancel: () {
          // Reset gambar jika dibatalkan
          resetCapturedImage();
        },
        confirmText: "Sudah Benar",
        cancelText: "Batalkan",
        countdownSeconds: 5,
      );
      studentIds.add(studentId);
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
    print(" Location:dutyType: ${dutyType.value}");
    if (dutyType.value == 'OnDuty') {
      print("Location: Starting location updates...");
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

  @override
  void onClose() {
    super.onClose();
    SharedPreferencesHelper.putString(Constant.TRACKING_ID_KEY, "");
  }
}
