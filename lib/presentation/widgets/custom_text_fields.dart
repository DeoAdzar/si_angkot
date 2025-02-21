import 'package:flutter/material.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';

// Custom TextField Widget
class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final Color borderColor;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.borderColor = MyColors.borderInputText,
    this.controller,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      style: AppTextStyle.textBASEPoppins,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? MyAssets.svg.passwordOff.svg(
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                            MyColors.fontColorSecondary, BlendMode.srcIn),
                      )
                    : MyAssets.svg.passwordOn.svg(
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                            MyColors.fontColorSecondary, BlendMode.srcIn),
                      ),
              )
            : null,
      ),
    );
  }
}

// use this widget like this
// CustomTextField(hintText: "Enter your email"),
// CustomTextField(hintText: "Enter password", isPassword: true),
