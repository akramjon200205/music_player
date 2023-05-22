// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/src/assets/app_text_styles.dart';
import 'package:music_player/src/assets/assets.dart';

// ignore: must_be_immutable
class RepeatIcon extends StatefulWidget {
  Function function;
  bool onTap;
  RepeatIcon({
    Key? key,
    required this.function,
    required this.onTap,
  }) : super(key: key);

  @override
  State<RepeatIcon> createState() => _RepeatIconState();
}

class _RepeatIconState extends State<RepeatIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.function(),
      child: SizedBox(
        width: 28.w,
        height: 28.w,        
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                Assets.icons.reshare,
                fit: BoxFit.scaleDown,
                height: 28.w,
                width: 28.w,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: widget.onTap,
                child: Text(
                  '1',
                  style: AppTextStyles.body10w4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
