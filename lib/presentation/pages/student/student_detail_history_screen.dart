import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/history_controller.dart';

class StudentDetailHistoryScreen extends StatelessWidget {
  StudentDetailHistoryScreen({super.key});
  final HistoryController controller = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail History'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.studentSelectedEntry.value == null) {
          return Center(child: Text('No data selected'));
        }

        // Mengubah format tanggal untuk header
        DateTime entryDate = DateFormat('yyyy-MM-dd')
            .parse(controller.studentSelectedEntry.value!.date);
        String formattedDate =
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(entryDate);

        for (var activity in controller.selectedStudentActivities) {
          print("Selected Entry: ${activity.type}");
        }
        print(
            "Selected Entry: ${controller.studentSelectedEntry.value!.activities.length}");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: controller.selectedStudentActivities.length,
                itemBuilder: (context, index) {
                  final activity = controller.selectedStudentActivities[index];
                  print("Student activity: ${activity.type}");
                  return ListTile(
                    title: Text(activity.type),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(activity.time),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
