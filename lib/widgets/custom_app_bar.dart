import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../apptheme/app_colors.dart';
import '../apptheme/stylehelper.dart';
import '../utils/const_image_key.dart';
import 'custom_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double? toolBarHeight;
  final Widget? title;
  final Widget? description;
  final double? titleSpacing;
  final double? leadingWidth;
  final List<Widget>? actions;
  final bool isLeading;
  final Widget? leading;
  final bool? centerTitle;
  final Widget? flexibleChild;
  final Color? backgroundColor;
  final Function()? onTap;

  const CustomAppBar({
    super.key,
    this.titleSpacing,
    this.onTap,
    this.toolBarHeight,
    this.leadingWidth,
    this.title,
    this.description,
    this.flexibleChild,
    this.backgroundColor,
    this.actions,
    this.leading,
    this.isLeading = false,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      scrolledUnderElevation: 0,
      toolbarHeight: toolBarHeight ?? 65.h,
      shadowColor: Colors.white,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leadingWidth: leadingWidth ?? 55.w,
      leading: isLeading
          ? CustomSquareButton(
              icon: AppImages.icArrowLeft,
              onTap: () => Get.back(),
              backgroundColor: Colors.white24,
            ).marginOnly(left: 5.w)
          : leading,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title ?? const SizedBox(),
          description ?? const SizedBox(),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight ?? 65.h);
}

class CustomAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final List<Widget>? actions;
  final bool? isLeading;
  final Color? backgroundColor;
  final Function()? onTap;
  final Widget? extraContentWidget;
  final double? toolBarHeight;
  final double? topMargin;
  final IconData? leadingIcon;
  final double? titleMarginTop;
  final double? titleMarginBottom;

  const CustomAppBarHome({
    super.key,
    this.titleStyle,
    this.onTap,
    this.title,
    this.subtitle,
    this.backgroundColor,
    this.actions,
    this.isLeading,
    this.extraContentWidget,
    this.toolBarHeight,
    this.topMargin,
    this.leadingIcon,
    this.titleMarginTop,
    this.titleMarginBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 25.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (isLeading ?? false)
                      GestureDetector(
                        onTap: onTap ?? () => Get.back(),
                        child: Icon(
                          leadingIcon ?? Icons.keyboard_backspace_sharp,
                          color: AppColors.whiteColor,
                          size: 20.h,
                        ).marginOnly(top: 20.h),
                      ).marginOnly(right: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: StyleHelper.customStyle(
                                size: 12.sp,
                                color: AppColors.whiteColor,
                                family: medium,
                              ),
                            ).marginOnly(top: 4.h),
                          if (title != null)
                            Text(
                              title!,
                              style: titleStyle ??
                                  StyleHelper.customStyle(
                                    color: AppColors.whiteColor,
                                    family: bold,
                                    size: 22.sp,
                                  ),
                            ).marginOnly(
                              top: titleMarginTop ?? 0,
                              bottom: titleMarginBottom ?? 0,
                            ),
                          extraContentWidget ?? const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions != null ? Row(children: actions!) : const SizedBox(),
            ],
          ).marginSymmetric(horizontal: 22.w),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight ?? 90.h);
}

class CustomGradientAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final List<Widget>? actions;
  final bool isLeading;
  final Widget? leading;
  final IconData? leadingIcon;
  final Function()? onTapLeading;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? headerHeight;
  final double? borderRadius;
  final Widget? child;
  final Widget? extraContentWidget;
  final EdgeInsetsGeometry? padding;

  const CustomGradientAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.actions,
    this.isLeading = false,
    this.leading,
    this.leadingIcon,
    this.onTapLeading,
    this.backgroundColor,
    this.gradient,
    this.headerHeight,
    this.borderRadius,
    this.child,
    this.extraContentWidget,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: Get.width,
          height: headerHeight ?? 150.h,
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: gradient ??
                LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withValues(alpha: 0.82),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius ?? 32.r),
              bottomRight: Radius.circular(borderRadius ?? 32.r),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (isLeading)
                            leading ??
                              GestureDetector(
                                onTap: onTapLeading ?? () => Get.back(),
                                child: Container(
                                  height: 32.h,
                                  width: 32.h,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    leadingIcon ?? Icons.arrow_back,
                                    color: AppColors.whiteColor,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                          Expanded(
                            child: titleWidget ??
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (title != null)
                                      Text(title!,style:titleStyle ?? StyleHelper.boldWhite_20),
                                    if (subtitle != null)
                                      Text(subtitle!, style: subtitleStyle ??StyleHelper.mediumWhite_12),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (actions != null) Row(children: actions!),
                  ],
                ),
                ?child,
                ?extraContentWidget,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
