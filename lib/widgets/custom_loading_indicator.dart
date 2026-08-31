import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../apptheme/app_colors.dart';
import '../apptheme/stylehelper.dart';
import '../utils/const_image_key.dart';
import 'common_widgets.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double? width;
  final double? height;
  final bool? isDisMissile;

  const CustomLoadingIndicator({
    super.key,
    this.width,
    this.height,
    this.isDisMissile = false,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isDisMissile!,
      child: Center(
        child: SizedBox(
          width: width??30.h,
          height: height??30.h,
          child: const CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

class ImageErrorWidget extends StatelessWidget {
  const ImageErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: AppColors.whiteColor),
      child: Image.asset(AppImages.appLogo, fit: BoxFit.contain)
    );
  }
}

class NoDataFoundWidget extends StatelessWidget {
  final String? image;
  final String? title;
  final String? subTitle;

  const NoDataFoundWidget({
    super.key,
    this.image,
    this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonIconView(icon: image ?? AppImages.noData, height: 130.h),
          Text(title!=null ? title!.tr : 'no_data_found'.tr,
            textAlign: TextAlign.center,
            style: StyleHelper.customStyle(color: AppColors.blackColor,size: 15.sp,family: medium)
          ),
          if(subTitle!=null)
          Text(subTitle!.tr,
            textAlign: TextAlign.center,
            style: StyleHelper.customStyle(color: AppColors.blackColor,family: medium)
          )
        ],
      ),
    );
  }
}