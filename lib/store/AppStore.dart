import 'dart:developer';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppStore extends GetxController{

  PackageInfo? packageInfo;

  @override
  void onClose() {
    super.onClose();
    log('AppStore on close');
  }

  @override
  Future<void> onInit() async{
    super.onInit();
    log('AppStore on init');

    final info = await PackageInfo.fromPlatform();
    packageInfo = info;
  }
}