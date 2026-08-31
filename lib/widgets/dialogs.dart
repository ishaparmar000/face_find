import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../apptheme/app_colors.dart';
import '../apptheme/stylehelper.dart';
import '../utils/const_image_key.dart';
import 'common_widgets.dart';
import 'custom_button.dart';

class CommonDialog extends StatelessWidget {
  const CommonDialog({
    super.key,
    this.onTapNo,
    required this.onTapYes,
    required this.title,
    this.description,
    this.titleStyle,
    this.descriptionStyle,
    this.tapNoText,
    this.tapYesText,
    this.customBody,
  });
  final Function()? onTapNo;
  final Function() onTapYes;
  final String title;
  final TextStyle? titleStyle;
  final String? description;
  final TextStyle? descriptionStyle;
  final String? tapNoText;
  final String? tapYesText;
  final Widget? customBody;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25.w)),
          boxShadow: const [
            BoxShadow(color: AppColors.primaryColor, spreadRadius: -1, offset: Offset(-5, 0),),
            BoxShadow(color: AppColors.primaryColor, spreadRadius: -1, offset: Offset(5, 0),),
          ],
        ),
        child: customBody ?? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.tr, style: titleStyle ?? StyleHelper.customStyle(family: semiBold, size: 14.sp)),
            if(description!=null)
              Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(description!.tr, style: descriptionStyle ?? StyleHelper.customStyle(family: medium, size: 13.sp, color: AppColors.grey))
              ),
            Row(
              children: [
                if(onTapNo!=null)
                  Expanded(
                    child: CustomButton(
                      onTap: onTapNo,
                      // color: AppColors.textFieldBg,
                      borderRadius: 100,
                      rightMargin: 15.w,
                      height: 35.h,
                      childWidget: Text(tapNoText ?? "No".tr, style: StyleHelper.customStyle()),
                    ),
                  ),

                Expanded(
                  child: CustomButton(
                    onTap: onTapYes,
                    color: AppColors.primaryColor,
                    borderRadius: 100,
                    height: 35.h,
                    childWidget: Text(tapYesText ?? "Yes".tr, style: StyleHelper.customStyle(color: AppColors.whiteColor)),
                  ),
                ),
              ],
            ).marginOnly(top: 15.h)
          ],
        ),
      ),
    );
  }
}

class ImagePickBottomSheet extends StatelessWidget {
  const ImagePickBottomSheet({super.key,required this.onTapCamera,required this.onTapGallery,this.onTapPDF});
  final VoidCallback onTapCamera;
  final VoidCallback onTapGallery;
  final VoidCallback? onTapPDF;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: onTapCamera,
                leading: CommonIconView(icon: AppImages.icCamera, height: 22.h, width: 22.h,),
                title: Text('camera'.tr, style: StyleHelper.customStyle()),
              ),
              Divider(thickness: 0.3.h,color: Colors.black),
              ListTile(
                onTap: onTapGallery,
                leading: CommonIconView(icon: AppImages.icGallery, height: 22.h, width: 22.h,),
                title: Text('gallery'.tr, style: StyleHelper.customStyle()),
              ),
              if(onTapPDF != null)
                Divider(thickness: 0.3.h,color: Colors.black),
              if(onTapPDF != null)
                ListTile(
                  onTap: onTapPDF,
                  leading: Icon(Icons.file_copy, size: 25.sp),
                  title: Text('pdf'.tr, style: StyleHelper.customStyle()),
                ),
              Divider(thickness: 0.3.h,color: Colors.black),
              ListTile(
                onTap: ()=> Get.back(),
                title: Center(child: Text('cancel'.tr, style: StyleHelper.customStyle())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
