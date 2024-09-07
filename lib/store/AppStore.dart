import 'dart:developer';
import 'dart:ui';

import 'package:duel_links_meta/hive/db/SettingHiveDb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppStore extends GetxController{

  PackageInfo? packageInfo;

  RxBool showWebviewNavs = false.obs;
  RxInt themeColorIndex = 0.obs;
  Color get themeColor => themeColorList[themeColorIndex.value];

  List<Color> themeColorList = [
    Colors.red,
    Colors.redAccent,
    Colors.deepOrange,
    Colors.orangeAccent,
    Colors.orange,
    Colors.yellow,
    Colors.yellow,
    Colors.pink,
    Colors.pinkAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.blueGrey,
    Colors.lightBlue,
    Colors.lightBlueAccent,
  ];

  void toggleShowWebviewNavs() {
    showWebviewNavs.value = !showWebviewNavs.value;

    SettingHiveDb().setShowWebviewNavs(show: showWebviewNavs.value);
  }

  Future<void> changeThemeColorIndex(int index) async {
    themeColorIndex.value = index;
    SettingHiveDb().setThemeColorIndex(index).ignore();
  }

  @override
  void onClose() {
    super.onClose();
    log('AppStore on close');
  }

  @override
  Future<void> onInit() async{
    super.onInit();
    log('AppStore on init');

    themeColorIndex.value = (await SettingHiveDb().getThemeColorIndex()) ?? 0;
    showWebviewNavs.value  = (await SettingHiveDb().getShowWebviewNavs()) ?? false;
    final info = await PackageInfo.fromPlatform();

    packageInfo = info;
  }
}