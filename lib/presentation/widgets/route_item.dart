import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:si_angkot/core.dart';

class RouteListItem extends StatelessWidget {
  final String routeName;
  final bool isLast; // Keeping this parameter for compatibility

  const RouteListItem({
    super.key,
    required this.routeName,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTextStyle.textBASEPoppins.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              routeName,
              style: AppTextStyle.textBASEPoppins.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: MyColors.fontColorPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
