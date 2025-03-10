import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/data/local/shared_prefference_helper.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/driver_controller.dart';
import 'package:si_angkot/presentation/widgets/gradient_header.dart';
import 'package:si_angkot/presentation/widgets/route_item.dart';
import 'package:si_angkot/presentation/widgets/status_chip.dart';

class DriverHomeView extends StatelessWidget {
  DriverHomeView({super.key});
  final DriverController driverController = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusChip(
                      listStatus: [
                        Constant.DELIVER,
                        Constant.PICKUP
                      ], // Add this if missing
                    ),
                    // Make sure the StatusChip is actually using an observable variable
                    const SizedBox(height: 20),
                    _carCard(),
                    const SizedBox(height: 20),
                    _buildRouteSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        GradientHeader(
          name: SharedPreferencesHelper.getString(Constant.USER_NAME_KEY) ??
              'Guest',
          subtitle: 'Selamat bekerja',
          imageUrl:
              'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
        ),
      ],
    );
  }

  Widget _carCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Angkot',
          style: TextStyle(
            color: MyColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "AE 1923 AS",
                style: AppTextStyle.textHeadingLGPoppins
                    .copyWith(color: MyColors.fontColorPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rute Bok Malang',
          style: TextStyle(
            color: MyColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Only use Obx on the parts that need to react to changes
        Obx(() => _buildRouteList()),
      ],
    );
  }

  // Extract the route list to its own method for better organization
  Widget _buildRouteList() {
    var selectedIndex = driverController.selectedStatusIndex.value;
    var routes = selectedIndex == 0
        ? driverController.carRoutesDeliver
        : driverController.carRoutesDepart;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final isLast = index == routes.length - 1;
        return RouteListItem(
          routeName: routes[index],
          isLast: isLast,
        );
      },
    );
  }
}
