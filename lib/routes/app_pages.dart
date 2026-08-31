import 'package:face_find/screens/DashboardScreen/dashboard_screen.dart';
import 'package:face_find/screens/ScanFaceScreen/scan_face_screen.dart';
import 'package:face_find/screens/SearchResultsScreen/search_results_screen.dart';
import 'package:face_find/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
part 'app_routes.dart';

class RouteGenerator {
  int duration = 300;

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.SPLASH_SCREEN:
        return GetPageRoute(
          routeName: settings.name,
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
          transitionDuration: Duration(milliseconds: duration),
        );

      case Routes.DASHBOARD_SCREEN:
        return GetPageRoute(
          routeName: settings.name,
          page: () => const DashboardScreen(),
          transition: Transition.circularReveal,
          transitionDuration: Duration(milliseconds: duration),
        );

      case Routes.SCAN_FACE_SCREEN:
        return GetPageRoute(
          routeName: settings.name,
          page: () => const ScanFaceScreen(),
          transition: Transition.fadeIn,
          transitionDuration: Duration(milliseconds: duration),
        );

      case Routes.SEARCH_RESULTS_SCREEN:
        return GetPageRoute(
          routeName: settings.name,
          page: () => const SearchResultsScreen(),
          transition: Transition.fadeIn,
          transitionDuration: Duration(milliseconds: duration),
        );

      default:
        return GetPageRoute(
          routeName: settings.name,
          page: () => const SplashScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: Duration(milliseconds: duration),
        );
    }
  }
}
