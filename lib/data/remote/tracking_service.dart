import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/core.dart';

class TrackingService {
  DatabaseReference? _trackingRef;
  StreamSubscription<Position>? _positionStream;

  Future<String> saveTracking({
    required String driverId,
    required String routesName,
    required String dutyType,
  }) async {
    final now = DateTime.now();
    final trackingId = now.millisecondsSinceEpoch.toString();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _trackingRef = FirebaseDatabase.instance.ref('Tracking/$trackingId');

    await _trackingRef!.set({
      'lat': position.latitude,
      'long': position.longitude,
      'routesName': routesName,
      'dutyType': dutyType,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    });

    SharedPreferencesHelper.putString(Constant.TRACKING_ID_KEY, trackingId);

    return trackingId;
  }

  /// Mulai update lokasi jika dutyType OnDuty
  void startLocationUpdates() {
    if (_trackingRef == null) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 50, // update setiap 50 meter
        accuracy: LocationAccuracy.high,
      ),
    ).listen((Position position) {
      _trackingRef!.update({
        'lat': position.latitude,
        'long': position.longitude,
        'updated_at': DateTime.now().toIso8601String(),
      });
      print(
          'Location: Updated Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    });

    print('Location: Location updates started: ${_trackingRef!.key}');
    print(
        'Location: Tracking ID: ${SharedPreferencesHelper.getString(Constant.TRACKING_ID_KEY)}');
  }

  void stopLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  /// Ambil daftar nama routes dari Firebase
  Future<List<String>> fetchRouteNames() async {
    final ref = FirebaseDatabase.instance.ref('Routes');
    final snapshot = await ref.get();
    List<String> routeNames = [];
    if (snapshot.exists) {
      snapshot.children.forEach((child) {
        if (child.key != null) {
          routeNames.add(child.key!);
        }
      });
    }
    return routeNames;
  }

  /// Ambil detail route (list address) berdasarkan pilihan route dan deliveryType
  /// _Jika deliveryType = "Penjemputan", maka ambil data routesDropOff,
  /// jika deliveryType = "Pengantaran", maka ambil data routesPickUp_
  Future<List<String>> fetchRouteDetail({
    required String selectedRoute,
    required String deliveryType,
  }) async {
    final ref = FirebaseDatabase.instance.ref('Routes/$selectedRoute');
    final snapshot = await ref.get();

    List<String> addressList = [];
    if (snapshot.exists) {
      // Tentukan node yang akan diambil berdasarkan deliveryType
      // (Bisa disesuaikan bila aturan sebaliknya)
      String nodeKey =
          (deliveryType == "Penjemputan") ? "routesDropOff" : "routesPickUp";
      final addressSnapshot = snapshot.child(nodeKey);
      addressSnapshot.children.forEach((child) {
        if (child.value != null) {
          addressList.add(child.value.toString());
        }
      });
    }
    return addressList;
  }

  Future<void> updateTrackingIdStudent({
    required String studentId,
    required String trackingId,
    required Function(bool isSuccess, String message) onResult,
  }) async {
    // inisialisasi Firebase Database
    final db = FirebaseDatabase.instance.ref();

    // Path untuk menyimpan data history
    final studentPath = 'Users/$studentId';

    try {
      // Jika belum ada data, buat map untuk menyimpan data baru
      final updates = <String, dynamic>{};
      updates['$studentPath/trackingId'] = trackingId;

      await db.update(updates);
      onResult(true, 'Data berhasil disimpan.');
    } catch (e) {
      onResult(false, 'Terjadi kesalahan: $e');
    }
  }

  //History journey
  Future<void> saveHistory({
    required String studentId,
    required String driverId,
    required String dutyType, // "berangkat" atau "pulang"
    required String trackingId,
    required Function(bool isSuccess, String message) onResult,
  }) async {
    // inisialisasi Firebase Database
    // dan format tanggal
    final db = FirebaseDatabase.instance.ref();
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    final now = DateFormat('HH:mm:ss').format(DateTime.now());

    // Path untuk menyimpan data history
    final studentPath = 'History/$today/$studentId/$dutyType';
    final driverPath = 'History/$today/$driverId/$dutyType/students/$studentId';

    try {
      // Ambil data student dari Firebase
      final studentSnapshot = await db.child(studentPath).get();
      final studentData = studentSnapshot.value as Map<dynamic, dynamic>?;

      //cek apakah sudah ada data onBoardTimestamp dan offBoardTimestamp
      // jika ada, berarti sudah melakukan perjalanan hari ini
      // jika tidak ada, lanjutkan untuk menyimpan data baru
      if (studentData != null &&
          studentData['onBoardTimestamp'] != null &&
          studentData['offBoardTimestamp'] != null) {
        onResult(false,
            'Hari ini anda sudah melakukan perjalanan. Silahkan coba lagi besok.');
        return;
      }

      // Jika belum ada data, buat map untuk menyimpan data baru
      final updates = <String, dynamic>{};

      // Jika onBoardTimeStamp kosong, simpan onBoardTimestamp
      // Jika onBoardTimestamp tidak kosong, simpan offBoardTimestamp
      if (studentData == null || studentData['onBoardTimestamp'] == null) {
        updates['$studentPath/trackingId'] = trackingId;
        updates['$studentPath/onBoardTimestamp'] = now;
        updates['$driverPath/trackingId'] = trackingId;
        updates['$driverPath/onBoardTimestamp'] = now;
      } else {
        updates['$studentPath/offBoardTimestamp'] = now;
        updates['$driverPath/offBoardTimestamp'] = now;
        removeTrackingIdStudent(
          studentId: studentId,
          trackingId: trackingId,
          onResult: (isSuccess, message) {
            if (!isSuccess) {
              AppUtils.showSnackbar("Oops!", "Gagal Memperbarui Data Student",
                  isError: true);
              return;
            }
          },
        );
      }

      await db.update(updates);
      onResult(true, 'Data berhasil disimpan.');
    } catch (e) {
      onResult(false, 'Terjadi kesalahan: $e');
    }
  }

  void removeTrackingIdStudent(
      {required String studentId,
      required String trackingId,
      required Null Function(dynamic isSuccess, dynamic message) onResult}) {
    // inisialisasi Firebase Database
    final db = FirebaseDatabase.instance.ref();

    // Path untuk menyimpan data history
    final studentPath = 'Users/$studentId';

    try {
      // Jika belum ada data, buat map untuk menyimpan data baru
      final updates = <String, dynamic>{};
      updates['$studentPath/trackingId'] = "";

      db.update(updates);
      onResult(true, 'Data berhasil disimpan.');
    } catch (e) {
      onResult(false, 'Terjadi kesalahan: $e');
    }
  }
}
