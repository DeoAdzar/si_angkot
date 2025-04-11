import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/data/local/shared_prefference_helper.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/widgets/custom_gradient_button.dart';
import 'package:si_angkot/presentation/widgets/custom_text_fields.dart';
import 'package:si_angkot/presentation/controller/student_controller.dart';

class StudentSettingScreen extends StatefulWidget {
  StudentSettingScreen({super.key});

  @override
  State<StudentSettingScreen> createState() => _StudentSettingScreenState();
}

class _StudentSettingScreenState extends State<StudentSettingScreen> {
  final StudentController studentController = Get.find<StudentController>();
  final AuthController authController = Get.find<AuthController>();

  late TextEditingController nameController;

  late TextEditingController addressSchoolController;

  late TextEditingController schoolController;

  late TextEditingController nisnController;

  late TextEditingController phoneController;

  late TextEditingController addressController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController =
        TextEditingController(text: authController.currentUser?.name ?? "");
    addressSchoolController = TextEditingController(
        text: authController.currentUser?.schoolAddress ?? "");
    phoneController =
        TextEditingController(text: authController.currentUser?.phone ?? "");
    addressController =
        TextEditingController(text: authController.currentUser?.address ?? "");
    nisnController =
        TextEditingController(text: authController.currentUser?.nisn ?? "");
    schoolController =
        TextEditingController(text: authController.currentUser?.school ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.colorWhite,
      appBar: AppBar(
        backgroundColor: MyColors.colorWhite,
        surfaceTintColor: Colors.transparent,
        leading: Center(
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: MyAssets.svg.arrowLeft.svg(
              width: 30,
              height: 30,
            ),
          ),
        ),
        title: Text(
          Constant.SETTING,
          style: AppTextStyle.textXLPoppins.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: studentController.pickImage,
                      child: Obx(
                        () => Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  studentController.imageFile.value != null
                                      ? FileImage(
                                          studentController.imageFile.value!)
                                      : NetworkImage(
                                          SharedPreferencesHelper.getString(
                                                  Constant.USER_IMAGE_KEY) ??
                                              "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png",
                                        ) as ImageProvider<Object>,
                              child: SharedPreferencesHelper.getString(
                                              Constant.USER_IMAGE_KEY) ==
                                          null &&
                                      studentController.imageFile.value == null
                                  ? Icon(Icons.person,
                                      size: 50, color: Colors.white)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(4),
                                child: MyAssets.svg.upload.svg(
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                        MyColors.fontColorSecondary,
                                        BlendMode.srcIn)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: nameController,
                      hintText: Constant.FULL_NAME,
                      label: Constant.FULL_NAME,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.name,
                    ),
                    CustomTextField(
                      controller: nisnController,
                      hintText: Constant.NISN,
                      label: Constant.NISN,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.name,
                    ),
                    CustomTextField(
                      controller: schoolController,
                      hintText: Constant.SCHOOL,
                      label: Constant.SCHOOL,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.name,
                    ),
                    CustomTextField(
                      controller: addressSchoolController,
                      hintText: Constant.SCHOOL_ADDRESS,
                      label: Constant.SCHOOL_ADDRESS,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    CustomTextField(
                      controller: phoneController,
                      hintText: Constant.PHONE_NUMBER,
                      label: Constant.PHONE_NUMBER,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.phone,
                    ),
                    CustomTextField(
                      controller: addressController,
                      hintText: Constant.ADDRESS,
                      label: Constant.ADDRESS,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    // CustomTextField(
                    //   controller: passwordController,
                    //   hintText: Constant.PASSWORD,
                    //   label: Constant.PASSWORD,
                    //   borderColor: MyColors.borderInputText,
                    //   keyboardType: TextInputType.visiblePassword,
                    //   isPassword: true,
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomGradientButton(
              text: Constant.SAVE,
              onPressed: () {
                studentController.nameTemp.value = nameController.text;
                studentController.schoolAddressTemp.value =
                    addressSchoolController.text;
                studentController.schoolTemp.value = schoolController.text;
                studentController.nisnTemp.value = nisnController.text;
                studentController.emailTemp.value = addressController.text;
                studentController.phoneTemp.value = phoneController.text;
                AppUtils.showSnackbar("Register Student", "Register");
              },
            )
          ],
        ),
      ),
    );
  }
}
