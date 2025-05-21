import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/data/models/driver_history/driver_history_model.dart';
import 'package:si_angkot/data/models/driver_history/driver_student_activity_model.dart';
import 'package:si_angkot/data/models/parent_student_history/parent_student_history_model.dart';
import 'package:si_angkot/data/models/student_history/student_history_activity_detail.dart';
import 'package:si_angkot/data/models/student_history/student_history_model.dart';
import 'package:si_angkot/data/remote/history_service.dart';

class HistoryController {
  final HistoryService _historyService = HistoryService();
  final RxBool isLoading = true.obs;

  //student history
  final RxList<StudentHistoryModel> historyStudentEntries =
      <StudentHistoryModel>[].obs;
  final RxList<StudentHistoryActivityDetail> selectedStudentActivities =
      <StudentHistoryActivityDetail>[].obs;
  final RxList<StudentHistoryActivityDetail> todayStudentActivities =
      <StudentHistoryActivityDetail>[].obs;
  final Rx<StudentHistoryModel?> studentSelectedEntry =
      Rx<StudentHistoryModel?>(null);

  //driver history
  final RxList<DriverHistoryModel> historyDriverEntries =
      <DriverHistoryModel>[].obs;
  final RxList<DriverStudentActivityModel> selectedActivities =
      <DriverStudentActivityModel>[].obs;
  final Rx<DriverHistoryModel?> driverSelectedEntry =
      Rx<DriverHistoryModel?>(null);
  final RxString selectedTabHistoryDetailDriver = "Keberangkatan".obs;

  // Fetch student history
  // This method fetches the history of a student based on their ID.
  void fetchStudentHistory(String studentId, bool isParent) async {
    try {
      isLoading.value = true;
      print("Fetching student history for ID: $studentId");
      Map<String, List<StudentHistoryActivityDetail>> groupedActivities =
          await _historyService.fetchStudentHistory(studentId);

      print("Grouped activities: $groupedActivities");

      List<StudentHistoryModel> entries = [];

      // Create history entries from the grouped activities
      groupedActivities.forEach((date, activities) {
        entries.add(StudentHistoryModel(
          id: date,
          date: date,
          activities: activities,
        ));
      });

      // Sort entries by date (newest first)
      entries.sort((a, b) => b.date.compareTo(a.date));

      historyStudentEntries.value = entries;
      if (isParent) {
        final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final allActivities = historyStudentEntries;
        // Find the entry for today
        final todayEntry =
            allActivities.firstWhereOrNull((entry) => entry.date == todayStr);
        todayStudentActivities.value = todayEntry?.activities ?? [];
      }
      print("History student entries: ${historyStudentEntries.length}");
    } catch (e) {
      print("Error fetching student history: $e");
      AppUtils.showSnackbar("Oops", "Gagal mendapatkan data history",
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void selectStudentEntry(StudentHistoryModel entry) {
    studentSelectedEntry.value = entry;
    selectedStudentActivities.value =
        entry.activities; // Pastikan ini dipanggil dan listnya sudah update
  }

  //fetch driver history
  // This method fetches the history of a driver based on their ID.
  void fetchDriverHistory(String driverId) async {
    try {
      isLoading.value = true;
      Map<String, Map<String, List<DriverStudentActivityModel>>>
          groupedActivities =
          await _historyService.fetchDriverHistory(driverId);

      List<DriverHistoryModel> entries = [];

      // Create driver history entries from the grouped activities
      groupedActivities.forEach((date, dutyMap) {
        List<DriverStudentActivityModel> allActivities = [
          ...dutyMap['berangkat'] ?? [],
          ...dutyMap['pulang'] ?? []
        ];

        allActivities.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        entries.add(DriverHistoryModel(
          id: date,
          date: date,
          studentActivities: allActivities,
        ));
      });

      // Sort entries by date (newest first)
      entries.sort((a, b) => b.date.compareTo(a.date));

      historyDriverEntries.value = entries;

      // Initially select the first entry if available
      if (entries.isNotEmpty) {
        driverSelectedEntry(entries.first);
      }
    } catch (e) {
      print("Error fetching driver history: $e");
      AppUtils.showSnackbar("Oops", "Gagal mendapatkan data history",
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
