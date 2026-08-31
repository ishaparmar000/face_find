import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'apptheme/app_colors.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false, right: false, left: false,
      child: ScreenUtilInit(
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: true,
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: GetMaterialApp(
            title: 'Face Find',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'SFPro',
                scaffoldBackgroundColor: AppColors.whiteColor
            ),
            initialRoute: Routes.SPLASH_SCREEN,
            onGenerateRoute: RouteGenerator().generateRoute,
            useInheritedMediaQuery: true,
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
