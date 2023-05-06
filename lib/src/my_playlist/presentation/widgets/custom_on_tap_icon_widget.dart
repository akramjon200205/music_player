// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class CustomOnTapIconWidget extends StatelessWidget {
  Function function;
  String textAssetsIcon;
  CustomOnTapIconWidget({
    Key? key,
    required this.function,
    required this.textAssetsIcon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 28.w,
        width: 28.w,
        child: IconButton(
          splashRadius: 14.r,
          padding: const EdgeInsets.all(0),
          onPressed: () {
            function();
          },
          icon: SvgPicture.asset(
            textAssetsIcon,
            height: 27.w,
            width: 27.w,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
