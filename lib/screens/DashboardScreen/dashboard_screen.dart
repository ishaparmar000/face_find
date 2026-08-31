import 'package:face_find/screens/ScanFaceScreen/scan_face_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../apptheme/app_colors.dart';
import '../../apptheme/stylehelper.dart';
import '../../utils/const_image_key.dart';
import '../../widgets/common_widgets.dart';
import '../GalleryScreen/gallery_screen.dart';
import '../HomeScreen/home_screen.dart';
import 'dashboard_screen_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashBoardController dashBoardController = Get.put(DashBoardController());

  final List<Widget> screenList = const [
    HomeScreen(),
    GalleryScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.transparent,
      body: Obx(() {
        return screenList[dashBoardController.pageIndex.value];
      }),
      floatingActionButton: SizedBox(
        width: 56.w,
        height: 56.w,
        child: FloatingActionButton(
          onPressed: () => Get.to(() => const ScanFaceScreen()),
          elevation: 8,
          backgroundColor: AppColors.transparent,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          shape: const CircleBorder(),
          child: Container(
            width: 56.w,
            height: 56.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.purpleGradientStart, AppColors.pinkAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purpleGlow,
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.center_focus_strong_rounded,
              color: AppColors.whiteColor,
              size: 26.sp,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() => BottomAppBar(
          color: AppColors.navBarBg,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.w,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.navBarBg,
              border: Border(top: BorderSide(color: AppColors.borderColor, width: 1)),
            ),
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: BottomTabWidget(
                    title: 'Home',
                    image: AppImages.icHome,
                    isSelected: dashBoardController.pageIndex.value == 0,
                    onTap: () {
                      dashBoardController.pageIndex.value = 0;
                    },
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  child: BottomTabWidget(
                    title: 'Gallery',
                    image: AppImages.icGallery,
                    isSelected: dashBoardController.pageIndex.value == 1,
                    onTap: () {
                      dashBoardController.pageIndex.value = 1;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomTabWidget extends StatelessWidget {
  const BottomTabWidget({
    super.key,
    required this.image,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final Function() onTap;
  final String image;
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonIconView(
            icon: image,
            height: 22.h,
            width: 22.h,
            color: isSelected
                ? AppColors.navBarSelected
                : AppColors.navBarUnselected,
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: StyleHelper.customStyle(
              size: 11.sp,
              family: isSelected ? semiBold : regular,
              color: isSelected
                  ? AppColors.navBarSelected
                  : AppColors.navBarUnselected,
            ),
          ),
        ],
      ),
    );
  }
}

