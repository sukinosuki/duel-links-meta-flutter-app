import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppStore  extends GetxController{
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  void changeThemeMode(ThemeMode mode) => themeMode.value = mode;
}