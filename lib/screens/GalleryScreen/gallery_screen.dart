import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../apptheme/app_colors.dart';
import '../../apptheme/stylehelper.dart';
import '../../repository/api_services.dart';
import '../../widgets/common_widgets.dart';
import 'full_screen_image_viewer.dart';
import 'gallery_controller.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  GalleryController galleryController = Get.put(GalleryController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      galleryController.getGalleryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.borderColor, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: AppColors.pinkAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Obx(() => Text(
                          '${galleryController.totalPhotos.value} Photos',
                          style: StyleHelper.regularGray_11,
                        )),
                      ],
                    ),
                  ),
                  Text('Gallery', style: StyleHelper.boldWhite_18),
                  GestureDetector(
                    onTap: () {
                      if (galleryController.galleryPhotos.isEmpty) {
                        showToast(message: 'No photos to clear');
                        return;
                      }
                      Get.dialog(
                        commonDialog(
                          title: 'Clear All Photos',
                          subtitle: 'Are you sure you want to delete all photos from gallery?',
                          onYes: () {
                            galleryController.deleteAllPhotos();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.borderColor, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete_sweep_outlined, color: AppColors.errorRed, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text('Clear All', style: StyleHelper.customStyle(family: bold, size: 11.sp, color: AppColors.errorRed)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Expanded(
              child: Obx(() {
                if (galleryController.isLoading.value && galleryController.galleryPhotos.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.pinkAccent),
                  );
                }
                if (galleryController.galleryPhotos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library_outlined, color: AppColors.textSubtle, size: 54.sp),
                        SizedBox(height: 12.h),
                        Text('No Photos in Gallery', style: StyleHelper.boldWhite_16),
                        SizedBox(height: 6.h),
                        Text('Upload photos to see them here', style: StyleHelper.regularGray_12),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 90.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.w,
                    childAspectRatio: 0.88,
                  ),
                  itemCount: galleryController.galleryPhotos.length,
                  itemBuilder: (context, index) {
                    final item = galleryController.galleryPhotos[index];
                    final String fullImageUrl = item.imageUrl == null
                        ? ''
                        : item.imageUrl!.startsWith('http')
                            ? item.imageUrl!
                            : '${ApiServices.imageURL}${item.imageUrl!.startsWith('/') ? item.imageUrl!.substring(1) : item.imageUrl}';
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => FullScreenImageViewer(
                                    initialIndex: index,
                                    photos: galleryController.galleryPhotos,
                                  ));
                            },
                            child: CachedNetworkImage(
                              imageUrl: fullImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: AppColors.cardBg),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.cardBg,
                                child: Icon(Icons.broken_image_outlined, color: AppColors.textSubtle, size: 24.sp),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.transparent, AppColors.shadowColor],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          // Individual delete button
                          Positioned(
                            top: 6.h,
                            right: 6.w,
                            child: GestureDetector(
                              onTap: () {
                                if (item.id != null) {
                                  Get.dialog(
                                    commonDialog(
                                      title: 'Delete Photo',
                                      subtitle: 'Are you sure you want to delete this photo?',
                                      onYes: () {
                                        galleryController.deletePhoto(id: item.id!);
                                      },
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeBg,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.darkBorderLight, width: 0.8),
                                ),
                                child: Icon(Icons.delete_outline_rounded, color: AppColors.errorRed, size: 14.sp),
                              ),
                            ),
                          ),
                          if (item.faceCount != null)
                            Positioned(
                              left: 6.w,
                              bottom: 6.h,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeBg,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: AppColors.darkBorderLight, width: 0.8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.face_rounded, color: AppColors.pinkAccent, size: 12.sp),
                                    SizedBox(width: 3.w),
                                    Text('${item.faceCount}', style: StyleHelper.boldWhite_11),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 56.w,
        height: 56.w,
        margin: EdgeInsets.only(bottom: 65.h),
        child: FloatingActionButton(
          onPressed: () => showUploadDialog(context),
          elevation: 8,
          backgroundColor: AppColors.transparent,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
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
              Icons.add,
              color: AppColors.whiteColor,
              size: 26.sp,
            ),
          ),
        ),
      ),
    );
  }

  void showUploadDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(22.w),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.darkBorderLight, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: AppColors.purpleGlow,
                blurRadius: 28,
                spreadRadius: 2,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.purpleGradientStart, AppColors.pinkAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.add_photo_alternate_rounded, color: AppColors.whiteColor, size: 18.sp),
                      ),
                      SizedBox(width: 10.w),
                      Text('Upload Photos', style: StyleHelper.boldWhite_18),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: AppColors.cardBgLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderColor, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.close_rounded, color: AppColors.textMuted, size: 16.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Select a source to upload photos to your gallery',
                style: StyleHelper.regularGray_12,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        galleryController.pickImageFromCamera();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: AppColors.borderColor, width: 1),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                color: AppColors.uploadIconBg,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.pinkAccent.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.camera_alt_rounded, color: AppColors.pinkAccent, size: 26.sp),
                            ),
                            SizedBox(height: 12.h),
                            Text('Camera', style: StyleHelper.boldWhite_14),
                            SizedBox(height: 4.h),
                            Text('Take photo', style: StyleHelper.regularGray_11),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        galleryController.pickImagesFromGallery();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: AppColors.borderColor, width: 1),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 50.w,
                                  height: 50.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.scanIconBg,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: AppColors.cyanAccent.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.photo_library_rounded, color: AppColors.cyanAccent, size: 26.sp),
                                ),
                                Positioned(
                                  top: -6.h,
                                  right: -8.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [AppColors.purpleGradientStart, AppColors.pinkAccent],
                                      ),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      'MULTI',
                                      style: StyleHelper.customStyle(
                                        family: bold,
                                        size: 8.sp,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text('Gallery', style: StyleHelper.boldWhite_14),
                            SizedBox(height: 4.h),
                            Text('Multiple photos', style: StyleHelper.regularGray_11),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}