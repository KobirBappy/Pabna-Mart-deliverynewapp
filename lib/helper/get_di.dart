import 'dart:convert';

import 'package:appmartbddeliverapp/controller/auth_controller.dart';
import 'package:appmartbddeliverapp/controller/chat_controller.dart';
import 'package:appmartbddeliverapp/controller/language_controller.dart';
import 'package:appmartbddeliverapp/controller/localization_controller.dart';
import 'package:appmartbddeliverapp/controller/notification_controller.dart';
import 'package:appmartbddeliverapp/controller/order_controller.dart';
import 'package:appmartbddeliverapp/controller/splash_controller.dart';
import 'package:appmartbddeliverapp/controller/theme_controller.dart';
import 'package:appmartbddeliverapp/data/repository/auth_repo.dart';
import 'package:appmartbddeliverapp/data/repository/chat_repo.dart';
import 'package:appmartbddeliverapp/data/repository/language_repo.dart';
import 'package:appmartbddeliverapp/data/repository/notification_repo.dart';
import 'package:appmartbddeliverapp/data/repository/order_repo.dart';
import 'package:appmartbddeliverapp/data/repository/splash_repo.dart';
import 'package:appmartbddeliverapp/data/api/api_client.dart';
import 'package:appmartbddeliverapp/util/app_constants.dart';
import 'package:appmartbddeliverapp/data/model/response/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageController(sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => ChatController(chatRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> _languages = Map();
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] = _json;
  }
  return _languages;
}
