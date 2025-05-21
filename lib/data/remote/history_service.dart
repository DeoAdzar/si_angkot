import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/data/models/driver_history/driver_student_activity_model.dart';
import 'package:si_angkot/data/models/parent_student_history/parent_student_history_model.dart';
import 'package:si_angkot/data/models/student_history/student_history_activity_detail.dart';

class HistoryService {
  final databaseRef = FirebaseDatabase.instance.ref();

  /// Fetch history khusus untuk siswa
  Future<Map<String, List<StudentHistoryActivityDetail>>> fetchStudentHistory(
      String studentId) async {
    final Map<String, List<StudentHistoryActivityDetail>> groupedActivities =
        {};

    try {
      final snapshot = await databaseRef.child("History").once();
      final data = snapshot.snapshot.value;

      if (data != null && data is Map) {
        for (final dateEntry in data.entries) {
          final dateKey = dateEntry.key;
          final studentMap = Map<String, dynamic>.from(dateEntry.value);
          print("Student Data: Date Key: $dateKey");

          for (final studentEntry in studentMap.entries) {
            print("Student Data: Student Entry Key: ${studentEntry.key}");
            final dutyTypes = Map<String, dynamic>.from(studentEntry.value);

            for (final dutyType in ['Berangkat', 'Pulang']) {
              if (dutyTypes.containsKey(dutyType)) {
                print("Student Data:   Found dutyType: $dutyType");
                final dutyData = Map<String, dynamic>.from(dutyTypes[dutyType]);
                print("Student Data:   Found dutyData: $dutyData");

                final students = dutyData['students'] as Map?;
                if (students != null && students.containsKey(studentId)) {
                  print("Student Data:     Found studentId: $studentId");

                  final studentData =
                      Map<String, dynamic>.from(students[studentId]);
                  final onBoardTs = studentData['onBoardTimestamp'];
                  final offBoardTs = studentData['offBoardTimestamp'];

                  final dateStr = DateFormat('yyyy-MM-dd').format(
                    DateTime.parse(dateKey),
                  );

                  print(
                      "Student Data:       onBoard: $onBoardTs, offBoard: $offBoardTs");

                  groupedActivities.putIfAbsent(dateStr, () => []);

                  void addActivity(String label, String tsString) {
                    try {
                      final timeParts = tsString.split(":");
                      final tsDateTime = DateTime(
                        int.parse(dateStr.split("-")[0]),
                        int.parse(dateStr.split("-")[1]),
                        int.parse(dateStr.split("-")[2]),
                        int.parse(timeParts[0]),
                        int.parse(timeParts[1]),
                        int.parse(timeParts[2]),
                      );
                      final tsMillis = tsDateTime.millisecondsSinceEpoch;

                      groupedActivities[dateStr]!.add(
                        StudentHistoryActivityDetail(
                          type: label,
                          time: DateFormat('HH:mm a').format(tsDateTime),
                          timestamp: tsMillis,
                        ),
                      );
                    } catch (e) {
                      print("Error parsing timestamp string: $e");
                    }
                  }

                  if (onBoardTs != null && onBoardTs is String) {
                    addActivity("$dutyType - Naik", onBoardTs);
                  }
                  if (offBoardTs != null && offBoardTs is String) {
                    addActivity("$dutyType - Turun", offBoardTs);
                  }
                }
              }
            }
          }
        }

        groupedActivities.forEach((_, activities) {
          activities.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        });

        print("Grouped activities: $groupedActivities");
      }
    } catch (e) {
      print("Error fetching student history: $e");
    }

    return groupedActivities;
  }

  /// Fetch history untuk driver
  Future<Map<String, Map<String, List<DriverStudentActivityModel>>>>
      fetchDriverHistory(String driverId) async {
    final groupedActivities =
        <String, Map<String, List<DriverStudentActivityModel>>>{};
    final userNames = <String, String>{};

    try {
      // Ambil semua nama user
      final userSnap = await databaseRef.child("User").once();
      final userMap = userSnap.snapshot.value;
      if (userMap != null && userMap is Map) {
        userMap.forEach((key, value) {
          if (value is Map && value['name'] != null) {
            userNames[key.toString()] = value['name'].toString();
          }
        });
      }

      final snapshot = await databaseRef
          .child("History")
          .orderByChild("driverId")
          .equalTo(driverId)
          .once();

      final data = snapshot.snapshot.value;
      if (data != null && data is Map) {
        data.forEach((key, rawValue) {
          final entry = Map<String, dynamic>.from(rawValue);

          final studentId = entry['studentId']?.toString();
          final dutyType = entry['dutyType']?.toString();
          final timestamp =
              entry['onBoardTimestamp'] ?? entry['offBoardTimestamp'];

          if (studentId != null &&
              dutyType != null &&
              timestamp != null &&
              (dutyType == 'berangkat' || dutyType == 'pulang')) {
            final dateStr = DateFormat('yyyy-MM-dd')
                .format(DateTime.fromMillisecondsSinceEpoch(timestamp));

            final studentName = userNames[studentId] ?? 'Unknown Student';
            final formattedTime = DateFormat('HH:mm a')
                .format(DateTime.fromMillisecondsSinceEpoch(timestamp));

            groupedActivities.putIfAbsent(
                dateStr,
                () => {
                      'berangkat': [],
                      'pulang': [],
                    });

            groupedActivities[dateStr]![dutyType]!.add(
              DriverStudentActivityModel(
                studentName: studentName,
                dutyType: dutyType,
                timestamp: timestamp,
                formattedTime: formattedTime,
              ),
            );
          }
        });

        groupedActivities.forEach((_, map) {
          map.forEach((_, list) {
            list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          });
        });
      }
    } catch (e) {
      print("Error fetching driver history: $e");
    }

    return groupedActivities;
  }

  /// Fetch kegiatan hari ini untuk siswa
  // Future<List<ParentStudentHistoryModel>> fetchTodayActivities(
  //     String studentId) async {
  //   final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   final allActivities = await fetchStudentHistory(studentId);
  //   return allActivities[todayStr] ?? [];
  // }
}
