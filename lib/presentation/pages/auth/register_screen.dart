import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/gen/fonts.gen.dart';
import 'package:si_angkot/presentation/controller/tab_controller.dart';
import 'package:si_angkot/presentation/widgets/chip_tab.dart';

class RegisterScreen extends StatelessWidget {
  final TabControllerX tabController = Get.put(TabControllerX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Text(
              "Buat Akun",
              style: AppTextStyle.textLGPoppins
                  .copyWith(color: MyColors.fontColorPrimary),
            ),
            Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              textAlign: TextAlign.center,
              style: AppTextStyle.textBASEPoppins
                  .copyWith(color: MyColors.fontColorPrimary),
            ),
            const SizedBox(height: 20),

            // Menggunakan ChipTab
            // ChipTab(
            //   tabs: [Constant.PARENT, Constant.DRIVER],
            //   initialIndex: tabController.selectedTab.value,
            //   onTabSelected: (index) {
            //     tabController.changeTab(index);
            //   },
            // ),

            // const SizedBox(height: 20),

            // // Gunakan Obx untuk update tampilan otomatis saat tab berubah
            // Expanded(
            //   child: Obx(() => _buildForm(tabController.selectedTab.value)),
            // ),
          ],
        ),
      ),
    );
  }
}
