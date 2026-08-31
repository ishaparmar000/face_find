import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../apptheme/app_colors.dart';
import '../apptheme/stylehelper.dart';
import '../utils/const_keys.dart';
import 'custom_button.dart';
import 'custom_loading_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';

void hideKeyBoard(){
  FocusManager.instance.primaryFocus?.unfocus();
}

void showToast({required String message,int? seconds}){
  Fluttertoast.showToast(
    msg: message.tr,
    backgroundColor: AppColors.primaryColor,
    textColor: Colors.white,
    fontSize: 14.sp,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    // textColor: Colors.pink
  );
}

class PaddingHorizontal15 extends StatelessWidget {
  const PaddingHorizontal15({super.key,required this.child,this.top,this.bottom,this.horizontal});

  final Widget child;
  final double? top;
  final double? bottom;
  final double? horizontal;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: horizontal ?? 15.w,right: horizontal ?? 15.w,top: top??0,bottom: bottom??0),
      child: child
    );
  }
}

Color getColorFromHex(String hexColor) {
  try{
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  } catch(e){
    return Colors.white;
  }
}

double? convertFontSize(String? size) {
  try{
    if(size == null) return null;
    double fontSize = double.parse(size.toString());
    return fontSize.sp;
  } catch(e){
    return null;
  }
}

String greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}


Alignment getAlignment(String alignment) {
  return alignment == "top-left" ? Alignment.topLeft :
  alignment == "top-center" ? Alignment.topCenter :
  alignment == "top-right" ? Alignment.topRight :
  alignment == "center-left" ? Alignment.centerLeft :
  alignment == "center-center" ? Alignment.center :
  alignment == "center-right" ? Alignment.centerRight :
  alignment == "bottom-left" ? Alignment.bottomLeft :
  alignment == "bottom-center" ? Alignment.bottomCenter :
  Alignment.bottomRight;
}

String removeHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

bool isEmailValid(String email) {
  final RegExp emailRegex = RegExp(
    r'(^.*[a-zA-Z]+[\.\-]?[a-zA-Z0-9]+@\w+([\.-]?\w+)*(\.\w{2,3})+$)',
    caseSensitive: false,
    multiLine: false,
  );
  return emailRegex.hasMatch(email);
}

String convertTo12HourFormat(String time24) {
  try {
    final inputFormat = DateFormat("HH:mm");
    final outputFormat = DateFormat("h:mm a");

    DateTime dateTime = inputFormat.parse(time24);
    return outputFormat.format(dateTime);
  } catch (e) {
    return time24;
  }
}

String ddMMYYYYDateFormat(DateTime date){
  try {
    return DateFormat('dd MMM yyyy').format(date);
  } catch (e){
    return '';
  }
}

String yyyyMMddDateFormat(String date){
  try {
    final parsedDate = DateFormat('dd-MM-yyyy').parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  } catch (e){
    return '';
  }
}

String formatApiDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('yyyy-MM-dd').format(date);
}

String apiToUtcDate(String date){
  try {
    final utcDateTime = DateFormat('yyyy-MM-dd').parseUtc(date);
    DateTime localDateTime = utcDateTime.toLocal();
    return DateFormat('dd-MM-yyyy').format(localDateTime);
  } catch (e){
    return '';
  }
}

String apiToUtcDateTime(String date){
  try {
    final utcDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parseUtc(date);
    DateTime localDateTime = utcDateTime.toLocal();
    return DateFormat('dd-MM-yyyy h:mm a').format(localDateTime);
  } catch (e){
    return '';
  }
}

String apiToUtcDateNextTime(String date){
  try {
    final utcDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parseUtc(date);
    DateTime localDateTime = utcDateTime.toLocal();
    return DateFormat('dd MMM yyyy\nhh:mm:a').format(localDateTime);
  } catch (e){
    return '';
  }
}


String formatDateString(String formatWant,String apiFormat, String dateString) {
  try {
    final parsedDate = DateFormat(apiFormat).parse(dateString);
    return DateFormat(formatWant).format(parsedDate);
  } catch (e) {
    return '';
  }
}

String utcToTime(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
    return DateFormat('h:mm a').format(dateTime);
  } catch (e) {
    return "";
  }
}

String formatTimeHMmA(String? timeStr) {
  if (timeStr == null || timeStr.trim().isEmpty) return '';
  final str = timeStr.trim();
  try {
    final parsed = DateFormat("HH:mm:ss").parse(str);
    return DateFormat("h:mm a").format(parsed);
  } catch (_) {}
  return str;
}


String getCurrentTimeUTC() {
  final now = DateTime.now().toUtc();
  final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(now);
}

String formatRouteHistoryDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  DateTime now = DateTime.now();

  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(const Duration(days: 1));
  DateTime inputDate = DateTime(date.year, date.month, date.day);

  String formattedDate = DateFormat('MMMM dd').format(date);

  if (inputDate == today) {
    return 'Today · $formattedDate';
  } else if (inputDate == yesterday) {
    return 'Yesterday · $formattedDate';
  } else {
    return formattedDate;
  }
}

String formatChildTripHistoryDate(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  } catch (e) {
    return dateString;
  }
}

String formatDateTime(String dateTimeString) {
  try {
    DateTime date = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('dd MMM yyyy h:mm a').format(date);
    return formattedDate;
  } catch (e) {
    return dateTimeString;
  }
}

class FormattedEventDate {
  final String day;
  final String month;
  final String fullDate;

  const FormattedEventDate({
    required this.day,
    required this.month,
    required this.fullDate,
  });
}

FormattedEventDate getEventDateParts(String? dateString) {
  if (dateString == null || dateString.trim().isEmpty) {
    return const FormattedEventDate(day: '--', month: '', fullDate: '');
  }
  try {
    final dateTime = DateTime.parse(dateString.trim());
    final day = DateFormat('dd').format(dateTime);
    final month = DateFormat('MMM').format(dateTime).toUpperCase();
    final fullDate = DateFormat('d MMMM yyyy').format(dateTime);
    return FormattedEventDate(day: day, month: month, fullDate: fullDate);
  } catch (e) {
    final parts = dateString.trim().split('-');
    if (parts.length == 3) {
      return FormattedEventDate(
        day: parts[2],
        month: parts[1].toUpperCase(),
        fullDate: dateString,
      );
    }
    return FormattedEventDate(day: dateString, month: '', fullDate: dateString);
  }
}


// Future<String> getAppVersion() async {
//   final versionInfo = await PackageInfo.fromPlatform();
//   return versionInfo.version;
// }
//
// Future<String> getDeviceId() async {
//   final deviceInfo = DeviceInfoPlugin();
//   AndroidDeviceInfo? androidInfo;
//   IosDeviceInfo? iosInfo;
//   try {
//     if (Platform.isAndroid) {
//       androidInfo = await deviceInfo.androidInfo;
//       return androidInfo.id;
//     } else if (Platform.isIOS) {
//       iosInfo = await deviceInfo.iosInfo;
//       return iosInfo.identifierForVendor.toString();
//     }
//     return "";
//   } catch (e) {
//     return DateTime.now().microsecondsSinceEpoch.toString();
//   }
// }


commonBottomSheetShow({required Widget widget}){
  Get.bottomSheet(
    ignoreSafeArea: true,
    isScrollControlled: true,
    widget
  );
}

class CommonBottomSheetContainer extends StatelessWidget {
  const CommonBottomSheetContainer({
    super.key,
    required this.child,
    this.height,
    this.top,
    this.horizontalPadding,
    this.topPadding,
    this.bottomPadding,
  });
  final Widget child;
  final double? height;
  final double? top;
  final double? horizontalPadding;
  final double? topPadding;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height,
        margin: EdgeInsets.only(top: top ?? 0),
        padding: EdgeInsets.only(left: horizontalPadding ?? 15.w, right: horizontalPadding ?? 15.w, top: topPadding ?? 15.h, bottom: bottomPadding ?? 15.h),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))
        ),
        child: child,
      ),
    );
  }
}

class CommonIconView extends StatelessWidget {
  const CommonIconView({
    super.key,
    required this.icon,
    this.height,
    this.width,
    this.color,
    this.package,
    this.scale, this.fit
  });

  final String icon;
  final double? height;
  final double? width;
  final Color? color;
  final String? package;
  final double? scale;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return icon.contains('.svg') ? 
    SvgPicture.asset(icon, height: height, width: width, colorFilter: color == null ? null : setSvgColor(color!), package: package) :
    Image.asset(icon, color: color, package: package, scale: scale, height: height, width: width, fit: fit);
  }
}

ColorFilter setSvgColor(Color color) {
  return ColorFilter.mode(color, BlendMode.srcIn);
}


Future<void> getImagesFromCameraGallery({required ImageSource source, required Function(XFile) onPick}) async {
  XFile? pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 40);
  if (pickedFile != null) {
    onPick.call(pickedFile);
  }
}

String returnString(String? text){
  return text != null && text.isNotEmpty ? text : "-";
}

Widget commonDialog({
  required String title,
  required String subtitle,
  required VoidCallback onYes,
  Color? borderColor,
  VoidCallback? onNo,
}) {
  return Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25.w)),
        boxShadow: [
          BoxShadow(color: borderColor ?? AppColors.primaryColor, spreadRadius: -1, offset: Offset(-5, 0),),
          BoxShadow(color: borderColor ?? AppColors.primaryColor, spreadRadius: -1, offset: Offset(5, 0),),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: StyleHelper.customStyle(family: bold, size: 18.sp, color: AppColors.primaryColor),
          ),

          SizedBox(height: 12.h),
          Text(subtitle, textAlign: TextAlign.center, style: StyleHelper.customStyle(color: Colors.grey.shade700)),

          SizedBox(height: 25.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "No".tr,
                  color: Colors.grey.shade300,
                  textStyle: StyleHelper.customStyle(family: bold),
                  onTap: () {
                    Get.back();
                    if (onNo != null) onNo();
                  },
                ),
              ),

              SizedBox(width: 15.w),

              Expanded(
                child: CustomButton(
                  text: "Yes".tr,
                  onTap: () {
                    Get.back();
                    onYes();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

