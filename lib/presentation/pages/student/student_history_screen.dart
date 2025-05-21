import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/presentation/controller/history_controller.dart';
import 'package:si_angkot/presentation/pages/student/student_detail_history_screen.dart';

import '../../controller/auth_controller.dart';

class StudentHistoryScreen extends StatefulWidget {
  StudentHistoryScreen({super.key});

  @override
  State<StudentHistoryScreen> createState() => _StudentHistoryScreenState();
}

class _StudentHistoryScreenState extends State<StudentHistoryScreen> {
  final HistoryController controller = Get.put(HistoryController());
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    controller.fetchStudentHistory(
        authController.currentUser?.userId ?? '', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.historyStudentEntries.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          itemCount: controller.historyStudentEntries.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            final entry = controller.historyStudentEntries[index];
            // Mengubah format tanggal
            DateTime entryDate = DateFormat('yyyy-MM-dd').parse(entry.date);
            String formattedDate =
                DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(entryDate);

            return ListTile(
              title: Text(
                formattedDate,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                controller.selectStudentEntry(entry);
                Get.to(() => StudentDetailHistoryScreen());
              },
            );
          },
        );
      }),
    );
  }
}
