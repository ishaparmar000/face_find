import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../apptheme/app_colors.dart';
import '../apptheme/stylehelper.dart';
import 'common_widgets.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? horizontalPadding;
  final double? leftMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? bottomMargin;
  final double? topPadding;
  final double? bottomPadding;
  final double? borderRadius;
  final Color? color;
  final String? text;
  final Function()? onTap;
  final TextStyle? textStyle;
  final Widget? childWidget;
  final List<BoxShadow>? boxShadow;
  final AlignmentGeometry? alignment;

  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.color,
    this.textStyle,
    this.leftMargin,
    this.rightMargin,
    this.horizontalPadding,
    this.topMargin,
    this.bottomMargin,
    this.topPadding,
    this.bottomPadding,
    this.borderRadius,
    this.childWidget,
    this.text,
    this.boxShadow,
    this.onTap,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: Platform.isAndroid,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: height ?? 45.h,
          width: width,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: leftMargin??0, right: rightMargin??0, top: topMargin??0, bottom: bottomMargin??0),
          padding: EdgeInsets.only(left: horizontalPadding??0, right: horizontalPadding??0, top: topPadding??0, bottom: bottomPadding??0),
          decoration: BoxDecoration(
            color: color ?? AppColors.primaryColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
            // border: Border.all(color: AppColors.colorD8CDFF, width: 1.w),
            // boxShadow: boxShadow ?? [
            //   BoxShadow(
            //     spreadRadius: 3,
            //     offset: Offset(0, 0),
            //     blurRadius: 0,
            //     color: AppColors.colorD8CDFF,
            //   )
            // ],
          ),
          child: childWidget ??
            Text(text!.tr, style: textStyle ?? StyleHelper.customStyle(family: bold, color: AppColors.whiteColor, size: 16.sp),
              textAlign: TextAlign.center
            ),
        ),
      ),
    );
  }
}


class CustomSquareButton extends StatelessWidget {
  const CustomSquareButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.leftMargin,
    this.rightMargin,
    this.topMargin,
    this.bottomMargin,
    this.backgroundColor,
    this.border,
    this.svgColor,
  });
  final String icon;
  final Function() onTap;
  final double? leftMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? bottomMargin;
  final Color? backgroundColor;
  final Color? svgColor;
  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.centerLeft,
          height: 38.w, width: 38.w,
          margin: EdgeInsets.only(left: leftMargin??0, right: rightMargin??0, top: topMargin??0, bottom: bottomMargin??0),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(10.r)
          ),
          child: Center(child: Icon(Icons.arrow_back, color: AppColors.whiteColor))
        ),
      ),
    );
  }
}