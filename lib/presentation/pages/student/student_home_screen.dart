import 'package:flutter/material.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/widgets/gradient_header.dart';
import 'package:si_angkot/presentation/widgets/menu_button.dart';
import 'package:si_angkot/presentation/widgets/qr_card.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          GradientHeader(
            name: 'Sri',
            subtitle: 'Semangat belajar ya',
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            child: Column(
              children: [
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
                        onTap: () =>
                            AppUtils.showSnackbar("OnClick", "Settings"),
                      ),
                      SizedBox(width: 20),
                      MenuButton(
                        icon: MyAssets.svg.history.svg(
                            width: 50,
                            height: 50,
                            colorFilter: ColorFilter.mode(
                                MyColors.primaryColor, BlendMode.srcIn)),
                        label: Constant.HISTORY_EN,
                        onTap: () =>
                            AppUtils.showSnackbar("OnClick", "History"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                QRCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
