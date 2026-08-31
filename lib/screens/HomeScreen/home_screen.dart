import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_find/screens/DashboardScreen/dashboard_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../apptheme/app_colors.dart';
import '../../apptheme/stylehelper.dart';
import '../ScanFaceScreen/scan_face_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DashBoardController dashboardController = Get.find();
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeController.getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Welcome', style: StyleHelper.boldWhite_28),
                  SizedBox(width: 8.w),
                  Text('👋', style: StyleHelper.boldWhite_20),
                ],
              ),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [AppColors.pinkAccent, AppColors.purplePrimary, AppColors.cyanAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text('Find Your Moments', style: StyleHelper.boldWhite_26),
              ),
              SizedBox(height: 6.h),
              Text('Upload photos and scan faces to find all matching memories', style: StyleHelper.regularGray_13),

              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () => dashboardController.pageIndex.value = 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.cardBgPurple, AppColors.cardBgPurpleEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(color: AppColors.borderColor, width: 1.2),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowColor, blurRadius: 18, offset: Offset(0, 8)),
                    ],
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.uploadIconBg,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(color: AppColors.pinkGlow, width: 1),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.cloud_upload_outlined, color: AppColors.pinkAccent, size: 24.sp),
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Upload Photos', style: StyleHelper.boldWhite_20),
                                    SizedBox(width: 6.w),
                                    Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 12.sp),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text('Add new photos to\nyour collection', style: StyleHelper.regularGray_15),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 116.w,
                            height: 116.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.rotate(
                                  angle: 0.20,
                                  child: Container(
                                    width: 62.w,
                                    height: 76.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBgLight,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(color: AppColors.whiteColor, width: 2.2),
                                      boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 10)],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=300&q=80',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(color: AppColors.darkSurface),
                                        errorWidget: (context, url, error) => Container(color: AppColors.darkSurface),
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.rotate(
                                  angle: -0.10,
                                  child: Container(
                                    width: 66.w,
                                    height: 82.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBgLight,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(color: AppColors.whiteColor, width: 2.5),
                                      boxShadow: const [
                                        BoxShadow(color: AppColors.shadowColor, blurRadius: 12, offset: Offset(0, 4)),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(color: AppColors.darkSurface),
                                        errorWidget: (context, url, error) => Container(color: AppColors.darkSurface),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.pinkAccent, size: 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () => Get.to(() => const ScanFaceScreen()),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 22.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.cardBgBlue, AppColors.cardBgBlueEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(color: AppColors.borderColor, width: 1.2),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowColor, blurRadius: 18, offset: Offset(0, 8)),
                    ],
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: AppColors.scanIconBg,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(color: AppColors.cyanAccent.withValues(alpha: 0.3), width: 1),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.person_search_outlined, color: AppColors.cyanAccent, size: 24.sp),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Scan Face', style: StyleHelper.boldWhite_20),
                                SizedBox(width: 6.w),
                                Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 12.sp),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text('Scan a face to find\nmatching photos', style: StyleHelper.regularGray_15),
                          ],
                        ),
                      ),
                      Container(
                        width: 96.w,
                        height: 96.h,
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.r)),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: 20.w,
                                      height: 20.w,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: AppColors.purplePrimary, width: 3.w),
                                          left: BorderSide(color: AppColors.purplePrimary, width: 3.w),
                                        ),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r)),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 20.w,
                                      height: 20.w,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: AppColors.cyanAccent, width: 3.w),
                                          right: BorderSide(color: AppColors.cyanAccent, width: 3.w),
                                        ),
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(8.r)),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      width: 20.w,
                                      height: 20.w,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: AppColors.purplePrimary, width: 3.w),
                                          left: BorderSide(color: AppColors.purplePrimary, width: 3.w),
                                        ),
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.r)),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 20.w,
                                      height: 20.w,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: AppColors.cyanAccent, width: 3.w),
                                          right: BorderSide(color: AppColors.cyanAccent, width: 3.w),
                                        ),
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.r)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 52.w,
                              height: 52.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.darkSurface,
                                border: Border.all(color: AppColors.borderColor, width: 1),
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6.h,
                              right: 6.w,
                              child: Text('✦', style: StyleHelper.customStyle(family: bold, size: 14.sp, color: AppColors.pinkAccent)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Text('Quick Stats', style: StyleHelper.boldWhite_18),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        color: AppColors.cardBg,
                        border: Border.all(color: AppColors.borderColor, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(color: AppColors.statPurpleBg, borderRadius: BorderRadius.circular(12.r)),
                            alignment: Alignment.center,
                            child: Icon(Icons.photo_library_outlined, color: AppColors.statPurple, size: 20.sp),
                          ),
                          SizedBox(height: 12.h),
                          Obx(() => Text(
                            '${homeController.homeModel.value?.data?.stats?.photos ?? 0}',
                            style: StyleHelper.boldWhite_18,
                          )),
                          SizedBox(height: 2.h),
                          Text('Photos', style: StyleHelper.regularGray_12),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: AppColors.borderColor, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(color: AppColors.statOrangeBg, borderRadius: BorderRadius.circular(12.r)),
                            alignment: Alignment.center,
                            child: Icon(Icons.face_retouching_natural_outlined, color: AppColors.statOrange, size: 20.sp),
                          ),
                          SizedBox(height: 12.h),
                          Obx(() => Text(
                            '${homeController.homeModel.value?.data?.stats?.faces ?? 0}',
                            style: StyleHelper.boldWhite_18,
                          )),
                          SizedBox(height: 2.h),
                          Text('Faces', style: StyleHelper.regularGray_12),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: AppColors.borderColor, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(color: AppColors.statCyanBg, borderRadius: BorderRadius.circular(12.r)),
                            alignment: Alignment.center,
                            child: Icon(Icons.center_focus_strong_outlined, color: AppColors.statCyan, size: 20.sp),
                          ),
                          SizedBox(height: 12.h),
                          Obx(() => Text(
                            '${homeController.homeModel.value?.data?.stats?.searches ?? 0}',
                            style: StyleHelper.boldWhite_18,
                          )),
                          SizedBox(height: 2.h),
                          Text('Searches', style: StyleHelper.regularGray_12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 90.h),
            ],
          ),
        ),
      ),
    );
  }
}