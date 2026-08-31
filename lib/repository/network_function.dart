import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/const_keys.dart';
import '../widgets/common_widgets.dart';
import '../widgets/custom_loading_indicator.dart';


loadingDialog() {
  Get.closeCurrentSnackbar();
  Get.closeAllSnackbars();
  Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false,useSafeArea: true);
}

closeLoadingDialog() {
  if(Get.isDialogOpen!){
    Get.back();
  }
}

class NetworkFunctions {

  static String networkErrorMessage = "";
  static bool isNetworkError = false;
  static String serverTakingLong = 'Time out';
  static String internetConnectionProblem = 'Internet connection problem';
  static String somethingWentWrong = 'Something went wrong';

  static Future<void> logout() async {
    getStorage.erase();
    getStorage.write(IS_LOGIN, false);
  }

  static Map<String, String> getHeader() {
    Map<String, String> headers = {
      'Authorization': getStorage.read(BEARER_TOKEN)==null ? '' : 'Bearer ${getStorage.read(BEARER_TOKEN)}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    log("Token:::::::::::::::::::${getStorage.read(BEARER_TOKEN)}");
    return headers;
  }
  static Future<Map<String,dynamic>?> apiRequest({
    required String url,
    required bool isShowLoader,
    String? method,
    Map<String,dynamic>? body,
    bool isShowError = true
  }) async {
    http.Response response;
    try {
      Get.closeCurrentSnackbar();
      Get.closeAllSnackbars();
      if (isShowLoader) {
        loadingDialog();
      }
      Map<String, String> headers = getHeader();
      if (method == 'get') {
        debugPrint('$url?${Uri(queryParameters: body).query}');
        response = await http.get(Uri.parse('$url?${Uri(queryParameters: body).query}'), headers: headers).timeout(const Duration(seconds: 25));
      }
      else if (method == 'delete') {
        response = await http.delete(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 25));
      }
      else {
        debugPrint(url);
        log(json.encode(body));
        response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body)).timeout(const Duration(seconds: 25));
      }
      if (isShowLoader) {
        closeLoadingDialog();
      }

      log('API URL: $url');
      log('Response: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      else if (response.statusCode == 401) {
        logout();
      }
      else if (response.statusCode == 500) {
        showToast(message: 'internal_server_error');
      }
    } on TimeoutException catch (e) {
      isNetworkError = true;
      networkErrorMessage = serverTakingLong.tr;
      debugPrint(e.toString());
    } on SocketException catch (e) {
      isNetworkError = true;
      networkErrorMessage = internetConnectionProblem.tr;
      debugPrint(e.toString());
    } on http.ClientException catch (e) {
      isNetworkError = true;
      networkErrorMessage = internetConnectionProblem.tr;
      debugPrint(e.toString());
    } on HandshakeException catch (e) {
      isNetworkError = true;
      networkErrorMessage = internetConnectionProblem.tr;
      debugPrint(e.toString());
    } on Error catch (e) {
      isNetworkError = true;
      networkErrorMessage = somethingWentWrong.tr;
      debugPrint(e.toString());
    }
    if(isNetworkError){
      if (isShowLoader) {
        closeLoadingDialog();
      }
      if(isShowError) {
        showToast(message: networkErrorMessage);
      }
    }
    return null;
  }

  static Future<Map<String,dynamic>?> multiPartApiRequestWithImage({
    required String url,
    required bool isShowLoader,
    required String imageParam,
    required String imagePath,
    Map<String,String>? body,
  }) async {
    try {
      Get.closeAllSnackbars();
      if (isShowLoader) {
        loadingDialog();
      }
      Map<String, String> headers = getHeader();
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      if(imagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(imageParam, imagePath));
      }
      if(body!=null) {
        request.fields.addAll(body);
      }
      var response = await request.send();

      if (isShowLoader) {
        closeLoadingDialog();
      }
      // final responseFromStream = await http.Response.fromStream(response);
      // print(responseFromStream.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final responseFromStream = await http.Response.fromStream(response);
        log(responseFromStream.body);
        return json.decode(responseFromStream.body);
      }
      else if (response.statusCode == 401) {
        logout();
      }
      else if (response.statusCode == 500) {
        final responseFromStream = await http.Response.fromStream(response);
        print(json.decode(responseFromStream.body));
        showToast(message: 'internal_server_error');
      }
    } on TimeoutException catch (e) {
      isNetworkError = true;
      networkErrorMessage = serverTakingLong.tr;
      debugPrint(e.toString());
    } on SocketException catch (e) {
      isNetworkError = true;
      networkErrorMessage = internetConnectionProblem.tr;
      debugPrint(e.toString());
    } on http.ClientException catch (e) {
      isNetworkError = true;
      networkErrorMessage = internetConnectionProblem.tr;
      debugPrint(e.toString());
    } on HandshakeException catch (e) {
      isNetworkError = true;
      networkErrorMessage = internetConnectionProblem.tr;
      debugPrint(e.toString());
    } on Error catch (e) {
      isNetworkError = true;
      networkErrorMessage = somethingWentWrong.tr;
      debugPrint(e.toString());
    }
    if(isNetworkError){
      if (isShowLoader) {
        closeLoadingDialog();
      }
      showToast(message: networkErrorMessage);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> multiPartApiRequestWithMultiImages({
    required String url,
    required bool isShowLoader,
    Map<String,String>? body,
    required String imageParam,
    required List<String> imagePaths,
  }) async {
    try {
      Get.closeAllSnackbars();
      if (isShowLoader) {
        loadingDialog();
      }
      Map<String, String> headers = getHeader();
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      for (String path in imagePaths) {
        if (path.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(imageParam, path),
          );
        }
      }

      if(body!=null) {
        request.fields.addAll(body);
      }
      var response = await request.send();

      if (isShowLoader) {
        closeLoadingDialog();
      }
      // final responseFromStream = await http.Response.fromStream(response);
      // print(responseFromStream.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final responseFromStream = await http.Response.fromStream(response);
        return json.decode(responseFromStream.body);
      }
      else if (response.statusCode == 401) {
        logout();
      }
      else if (response.statusCode == 403) {
        final responseFromStream = await http.Response.fromStream(response);
        print(responseFromStream.body.toString());
      }
      else if (response.statusCode == 500) {
        final responseFromStream = await http.Response.fromStream(response);
        print(responseFromStream.body.toString());
        showToast(message: 'internal_server_error');
      }
    } on TimeoutException catch (e) {
      isNetworkError = true;
      networkErrorMessage = serverTakingLong.tr;
      debugPrint(e.toString());
    } on SocketException catch (e) {
      isNetworkError = true;
      networkErrorMessage = internetConnectionProblem.tr;
      debugPrint(e.toString());
    } on http.ClientException catch (e) {
      isNetworkError = true;
      networkErrorMessage = internetConnectionProblem.tr;
      debugPrint(e.toString());
    } on HandshakeException catch (e) {
      isNetworkError = true;
      networkErrorMessage = internetConnectionProblem.tr;
      debugPrint(e.toString());
    } on Error catch (e) {
      isNetworkError = true;
      networkErrorMessage = somethingWentWrong.tr;
      debugPrint(e.toString());
    }
    if(isNetworkError){
      if (isShowLoader) {
        closeLoadingDialog();
      }
      showToast(message: networkErrorMessage);
    }
    return null;
  }
}