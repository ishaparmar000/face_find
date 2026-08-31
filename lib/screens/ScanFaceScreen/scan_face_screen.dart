import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../apptheme/app_colors.dart';
import '../../apptheme/stylehelper.dart';
import 'scan_face_controller.dart';

class ScanTipItem extends StatelessWidget {
  const ScanTipItem({super.key, required this.tipText});

  final String tipText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(Icons.check_rounded, color: AppColors.pinkAccent, size: 16.sp),
          SizedBox(width: 6.w),
          Text(tipText, style: StyleHelper.regularGray_12),
        ],
      ),
    );
  }
}

class ScanFaceScreen extends StatefulWidget {
  const ScanFaceScreen({super.key});

  @override
  State<ScanFaceScreen> createState() => ScanFaceScreenState();
}

class ScanFaceScreenState extends State<ScanFaceScreen> with SingleTickerProviderStateMixin {
  final ScanFaceController scanFaceController = Get.put(ScanFaceController());
  late AnimationController scanAnimationController;
  late Animation<double> scanAnimation;

  @override
  void initState() {
    super.initState();
    scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    scanAnimation = Tween<double>(begin: -90.0, end: 90.0).animate(
      CurvedAnimation(parent: scanAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    scanAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.borderColor, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textWhite, size: 16.sp),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Scan Face', style: StyleHelper.boldWhite_18),
                    ),
                  ),
                  Obx(() {
                    if (scanFaceController.selectedImagePath.value.isNotEmpty) {
                      return GestureDetector(
                        onTap: scanFaceController.resetSelectedImage,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.borderColor, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.refresh_rounded, color: AppColors.pinkAccent, size: 20.sp),
                        ),
                      );
                    }
                    return SizedBox(width: 38.w);
                  }),
                ],
              ),
              SizedBox(height: 6.h),
              Text('Take a photo or upload from gallery', style: StyleHelper.regularGray_13),
              SizedBox(height: 24.h),
              SizedBox(
                width: 280.w,
                height: 280.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 256.w,
                      height: 256.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.purplePrimary, width: 3.5.w),
                            left: BorderSide(color: AppColors.purplePrimary, width: 3.5.w),
                          ),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(14.r)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.pinkAccent, width: 3.5.w),
                            right: BorderSide(color: AppColors.pinkAccent, width: 3.5.w),
                          ),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(14.r)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.purplePrimary, width: 3.5.w),
                            left: BorderSide(color: AppColors.purplePrimary, width: 3.5.w),
                          ),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14.r)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.pinkAccent, width: 3.5.w),
                            right: BorderSide(color: AppColors.pinkAccent, width: 3.5.w),
                          ),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(14.r)),
                        ),
                      ),
                    ),
                    Container(
                      width: 220.w,
                      height: 220.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.purpleGradientStart, AppColors.pinkAccent, AppColors.cyanAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(color: AppColors.purpleGlow, blurRadius: 28, spreadRadius: 4),
                        ],
                      ),
                      padding: EdgeInsets.all(3.5.w),
                      child: ClipOval(
                        child: Obx(() {
                          if (scanFaceController.selectedImagePath.value.isNotEmpty) {
                            return Image.file(
                              File(scanFaceController.selectedImagePath.value),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.cardBg,
                                child: Icon(Icons.person, color: AppColors.textSubtle, size: 80.sp),
                              ),
                            );
                          }
                          return Container(
                            color: AppColors.darkSurface,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 68.w,
                                  height: 68.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.cardBg,
                                    border: Border.all(
                                      color: AppColors.pinkAccent.withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.face_retouching_natural_rounded,
                                    color: AppColors.pinkAccent,
                                    size: 38.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Select a face photo',
                                  style: StyleHelper.regularGray_11,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: scanAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, scanAnimation.value.h),
                          child: Container(
                            width: 220.w,
                            height: 3.h,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.transparent, AppColors.pinkAccent, AppColors.pinkAccent, AppColors.transparent],
                              ),
                              boxShadow: [
                                BoxShadow(color: AppColors.pinkGlow, blurRadius: 12, spreadRadius: 3),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.borderColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: AppColors.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Obx(() {
                      final String statusText = scanFaceController.isScanning.value
                          ? 'Scanning Face...'
                          : scanFaceController.selectedImagePath.value.isNotEmpty
                              ? 'Face Photo Ready'
                              : 'AI Scanner Active';
                      return Text(statusText, style: StyleHelper.boldWhite_11);
                    }),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: scanFaceController.pickImageFromCamera,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: AppColors.borderColor, width: 1),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: AppColors.uploadIconBg,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.camera_alt_rounded, color: AppColors.pinkAccent, size: 24.sp),
                            ),
                            SizedBox(height: 10.h),
                            Text('Camera', style: StyleHelper.boldWhite_14),
                            SizedBox(height: 2.h),
                            Text('Take a photo', style: StyleHelper.regularGray_11),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: scanFaceController.pickImageFromGallery,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: AppColors.borderColor, width: 1),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: AppColors.scanIconBg,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.photo_library_rounded, color: AppColors.cyanAccent, size: 24.sp),
                            ),
                            SizedBox(height: 10.h),
                            Text('Gallery', style: StyleHelper.boldWhite_14),
                            SizedBox(height: 2.h),
                            Text('Choose from files', style: StyleHelper.regularGray_11),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (scanFaceController.selectedImagePath.value.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: GestureDetector(
                      onTap: scanFaceController.scanFaceApi,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.purpleGradientStart, AppColors.pinkAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.purpleGlow,
                              blurRadius: 16,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_rounded, color: AppColors.whiteColor, size: 20.sp),
                            SizedBox(width: 8.w),
                            Text('Scan Selected Face', style: StyleHelper.boldWhite_16),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.borderColor, width: 1),
                ),
                padding: EdgeInsets.all(18.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.statPurpleBg,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.lightbulb_outline_rounded, color: AppColors.pinkAccent, size: 22.sp),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tips for better results', style: StyleHelper.boldWhite_14),
                          SizedBox(height: 10.h),
                          const ScanTipItem(tipText: 'Use a clear front-facing photo'),
                          const ScanTipItem(tipText: 'Good lighting improves accuracy'),
                          const ScanTipItem(tipText: 'One face per photo works best'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}