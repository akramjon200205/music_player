
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/src/assets/app_text_styles.dart';
import 'package:music_player/src/assets/assets.dart';

// ignore: must_be_immutable
class RepeatIcon extends StatefulWidget {
  const RepeatIcon({super.key});

  @override
  State<RepeatIcon> createState() => _RepeatIconState();
}

class _RepeatIconState extends State<RepeatIcon> {
  bool onTap = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          onTap = !onTap;
        });
      },
      child: SizedBox(
        width: 28.w,
        height: 28.w,
        // decoration: const BoxDecoration(color: Colors.blue),
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
                visible: onTap,
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
