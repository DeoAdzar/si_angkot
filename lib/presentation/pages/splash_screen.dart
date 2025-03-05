import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/app_routes.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../data/local/shared_prefference_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _opacity = 1.0;
    });

    await Future.delayed(Constant.SPLASH_DURATION);
    setState(() {
      _opacity = 0.0;
    });

    await Future.delayed(Duration(milliseconds: 500));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    String? role = SharedPreferencesHelper.getString(Constant.ROLE_KEY);
    if (role != null) {
      Get.offNamed(_getRouteForRole(role));
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }

  String _getRouteForRole(String role) {
    switch (role) {
      case 'student':
        return AppRoutes.student;
      case 'driver':
        return AppRoutes.driver;
      case 'parent':
        return AppRoutes.parent;
      default:
        return AppRoutes.login;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.colorWhite,
      body: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: _opacity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            MyAssets.png.icon.image(width: 95, height: 95),
            Spacer(),
            Column(
              children: [
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
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyAssets.png.iconDinasPerhubungan
                        .image(width: 17, height: 20),
                    SizedBox(width: 4),
                    GradientText(
                      Constant.DINAS_PERHUBUNGAN,
                      style: AppTextStyle.textBASEInter,
                      gradientType: GradientType.linear,
                      gradientDirection: GradientDirection.ltr,
                      colors: [
                        MyColors.primaryColor,
                        MyColors.secondaryColor,
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
