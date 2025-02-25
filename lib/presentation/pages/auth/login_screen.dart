import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/core/utils/helper/size_helper.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/presentation/controller/auth/login_controller.dart';
import 'package:si_angkot/presentation/widgets/custom_gradient_button.dart';
import 'package:si_angkot/presentation/widgets/custom_text_fields.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../gen/colors.gen.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeHelper.dynamicWidth(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              MyAssets.png.icon.image(
                  width: SizeHelper.dynamicWidth(80),
                  height: SizeHelper.dynamicHeight(80),
                  cacheHeight: 80,
                  cacheWidth: 80),
              GradientText(
                Constant.APP_NAME,
                style: AppTextStyle.text3XLInter.copyWith(fontSize: 32),
                gradientType: GradientType.linear,
                gradientDirection: GradientDirection.ltr,
                colors: [
                  MyColors.primaryColor,
                  MyColors.secondaryColor,
                ],
              ),
              SizedBox(height: SizeHelper.dynamicHeight(4)),
              GradientText(
                Constant.APP_DESCRIPTION,
                style: AppTextStyle.textHeadingInter.copyWith(fontSize: 14),
                gradientType: GradientType.linear,
                gradientDirection: GradientDirection.ltr,
                colors: [MyColors.primaryColor, MyColors.secondaryColor],
              ),
              SizedBox(height: SizeHelper.dynamicHeight(24)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeHelper.dynamicHeight(24)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      hintText: Constant.EMAIL,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    SizedBox(height: SizeHelper.dynamicHeight(15)),
                    CustomTextField(
                      hintText: Constant.PASSWORD,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                    ),
                    SizedBox(height: SizeHelper.dynamicHeight(15)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => AppUtils.showSnackbar(
                            "On Click", "Forgot Password Clicked"),
                        child: Text(
                          Constant.FORGOT_PASSWORD,
                          style: AppTextStyle.textBASEPoppins.copyWith(
                            color: MyColors.fontColorSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeHelper.dynamicHeight(15)),
                    GetBuilder<LoginController>(
                      builder: (controller) {
                        return controller.isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    MyColors.primaryColor),
                              )
                            : CustomGradientButton(
                                text: Constant.LOGIN,
                                onPressed: () {
                                  controller.login(emailController.text,
                                      passwordController.text);
                                },
                              );
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: SizeHelper.dynamicHeight(30)),
                child: RichText(
                  text: TextSpan(
                    text: Constant.DOESNT_HAVE_ACCOUNT,
                    style: AppTextStyle.textBASEPoppins
                        .copyWith(color: MyColors.fontColorSecondary),
                    children: [
                      TextSpan(
                        text: ' ${Constant.REGISTER}',
                        style: AppTextStyle.textBASEPoppins.copyWith(
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.w700),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed('/base-register');
                          },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
