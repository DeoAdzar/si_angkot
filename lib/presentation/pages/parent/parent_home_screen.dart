import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/parent/parent_controller.dart';
import 'package:si_angkot/presentation/widgets/gradient_header.dart';
import 'package:si_angkot/presentation/widgets/menu_button.dart';
import 'package:si_angkot/presentation/widgets/student_list_item.dart';

class ParentHomeScreen extends StatelessWidget {
  ParentHomeScreen({super.key});
  final ParentController controller = Get.put(ParentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientHeader(
            name: 'Sri',
            subtitle: 'Monitoring anak mu sedang dimana',
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(
                  icon: MyAssets.svg.settings.svg(
                      width: 50,
                      height: 50,
                      colorFilter: ColorFilter.mode(
                          MyColors.primaryColor, BlendMode.srcIn)),
                  label: Constant.SETTING_PROFILE,
                  onTap: () => AppUtils.showSnackbar("OnClick", "Settings"),
                ),
                SizedBox(width: 20),
                MenuButton(
                  icon: MyAssets.svg.userPlus.svg(
                      width: 50,
                      height: 50,
                      colorFilter: ColorFilter.mode(
                          MyColors.primaryColor, BlendMode.srcIn)),
                  label: Constant.FORM_REGISTER,
                  onTap: () => Get.toNamed('/parent-form-register'),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              Constant.PROFILE_STUDENT,
              style: AppTextStyle.textXLPoppins.copyWith(
                  color: MyColors.fontColorPrimary,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              if (controller.studentsList.isEmpty) {
                return const Center(child: Text("No users found"));
              }
              return RefreshIndicator(
                onRefresh: () async => controller.fetchStudentsDummy(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: controller.studentsList.length,
                  itemBuilder: (context, index) {
                    final student = controller.studentsList[index];
                    return StudentListItem(
                      name: student.name!,
                      school: student.school!,
                      status: student.status!,
                      profileImageUrl: student.pict!,
                      onTap: () =>
                          AppUtils.showSnackbar("OnClick", "${student.name}"),
                    );
                  },
                ),
              );
            }),
          ))
        ],
      ),
    );
  }
}
