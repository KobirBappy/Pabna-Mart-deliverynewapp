import 'package:appmartbddeliverapp/controller/auth_controller.dart';
import 'package:appmartbddeliverapp/helper/route_helper.dart';
import 'package:appmartbddeliverapp/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      Get.find<AuthController>().stopLocationRecord();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }else {
      showCustomSnackBar(response.statusText);
    }
  }
}