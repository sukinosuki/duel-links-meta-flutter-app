import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppStore  extends GetxController{
  var themeMode = ThemeMode.light.obs;

  changeThemeMode(ThemeMode mode) => themeMode.value = mode;
}