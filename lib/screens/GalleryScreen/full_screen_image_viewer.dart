import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../apptheme/app_colors.dart';
import '../../apptheme/stylehelper.dart';
import '../../models/scan_photo_model.dart';
import '../../repository/api_services.dart';
import '../../widgets/common_widgets.dart';
import 'gallery_controller.dart';

class FullScreenImageViewer extends StatefulWidget {
  final int initialIndex;
  final List<PhotoItem> photos;

  const FullScreenImageViewer({
    super.key,
    required this.initialIndex,
    required this.photos,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  String getFullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '${ApiServices.imageURL}${imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: widget.photos.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final photo = widget.photos[index];
                final String fullImageUrl = getFullImageUrl(photo.imageUrl);

                return InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: fullImageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: AppColors.pinkAccent),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image_outlined, color: AppColors.textSubtle, size: 54.sp),
                            SizedBox(height: 12.h),
                            Text('Failed to load image', style: StyleHelper.regularGray_13),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            Positioned(
              top: 10.h,
              left: 16.w,
              right: 16.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.badgeBg,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.darkBorderLight, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.whiteColor, size: 18.sp),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.badgeBg,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.darkBorderLight, width: 1),
                    ),
                    child: Text(
                      '${currentIndex + 1} / ${widget.photos.length}',
                      style: StyleHelper.boldWhite_14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.photos.isNotEmpty && currentIndex < widget.photos.length) {
                        final currentPhoto = widget.photos[currentIndex];
                        if (currentPhoto.id != null) {
                          Get.dialog(
                            commonDialog(
                              title: 'Delete Photo',
                              subtitle: 'Are you sure you want to delete this photo?',
                              onYes: () {
                                final GalleryController galleryController = Get.find<GalleryController>();
                                galleryController.deletePhoto(id: currentPhoto.id!);
                                if (widget.photos.length <= 1) {
                                  Get.back();
                                } else {
                                  if (currentIndex >= widget.photos.length - 1) {
                                    setState(() {
                                      currentIndex = widget.photos.length - 2;
                                    });
                                  }
                                }
                              },
                            ),
                          );
                        }
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.badgeBg,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.darkBorderLight, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.delete_outline_rounded, color: AppColors.errorRed, size: 18.sp),
                    ),
                  ),
                ],
              ),
            ),

            if (widget.photos.isNotEmpty && currentIndex < widget.photos.length && widget.photos[currentIndex].faceCount != null)
              Positioned(
                bottom: 20.h,
                left: 20.w,
                right: 20.w,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.badgeBg,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.darkBorderLight, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.face_rounded, color: AppColors.pinkAccent, size: 16.sp),
                        SizedBox(width: 6.w),
                        Text(
                          '${widget.photos[currentIndex].faceCount} ${widget.photos[currentIndex].faceCount == 1 ? 'Face' : 'Faces'} detected',
                          style: StyleHelper.boldWhite_12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
