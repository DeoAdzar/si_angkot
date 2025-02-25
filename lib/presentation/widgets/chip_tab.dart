import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/presentation/controller/tab_controller.dart';

class ChipTab extends StatelessWidget {
  final List<String> tabs;

  const ChipTab({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final TabControllerX tabController = Get.find<TabControllerX>();

    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabs.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(tabs[index]),
                  selected: tabController.selectedTab.value == index,
                  onSelected: (bool selected) => tabController.changeTab(index),
                  selectedColor: Colors.white,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: tabController.selectedTab.value == index
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
// use this widget like this
// ChipTabBar(
//   tabs: ["Tab 1", "Tab 2", "Tab 3"],
//   onTabSelected: (index) {
//     print("Tab terpilih: $index");
//   },
// )
