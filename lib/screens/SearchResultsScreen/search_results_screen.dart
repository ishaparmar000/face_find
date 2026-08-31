import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../apptheme/app_colors.dart';
import '../../apptheme/stylehelper.dart';
import '../../repository/api_services.dart';
import '../GalleryScreen/full_screen_image_viewer.dart';
import '../ScanFaceScreen/scan_face_controller.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScanFaceController scanFaceController = Get.find<ScanFaceController>();

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textWhite, size: 20.sp),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Search Results', style: StyleHelper.boldWhite_18),
                    ),
                  ),
                  SizedBox(width: 32.w),
                ],
              ),
              SizedBox(height: 4.h),
              Obx(() => Text(
                'Found ${scanFaceController.totalMatchingPhotos.value} matching ${scanFaceController.totalMatchingPhotos.value == 1 ? 'photo' : 'photos'}',
                style: StyleHelper.regularGray_13,
              )),
              SizedBox(height: 18.h),
              Expanded(
                child: Obx(() {
                  if (scanFaceController.matchingPhotos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.face_retouching_off_rounded, color: AppColors.textSubtle, size: 54.sp),
                          SizedBox(height: 12.h),
                          Text('No Matching Photos Found', style: StyleHelper.boldWhite_16),
                          SizedBox(height: 6.h),
                          Text('Try scanning a clearer image', style: StyleHelper.regularGray_12),
                        ],
                      ),
                    );
                  }
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.w,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: scanFaceController.matchingPhotos.length,
                    itemBuilder: (context, index) {
                      final item = scanFaceController.matchingPhotos[index];
                      final String fullImageUrl = item.imageUrl == null
                          ? ''
                          : item.imageUrl!.startsWith('http')
                              ? item.imageUrl!
                              : '${ApiServices.imageURL}${item.imageUrl!.startsWith('/') ? item.imageUrl!.substring(1) : item.imageUrl}';
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => FullScreenImageViewer(
                                initialIndex: index,
                                photos: scanFaceController.matchingPhotos,
                              ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.r),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: fullImageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(color: AppColors.cardBg),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.cardBg,
                                  child: Icon(Icons.broken_image_outlined, color: AppColors.textSubtle, size: 24.sp),
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
                              if (item.faceCount != null)
                                Positioned(
                                  right: 6.w,
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
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}