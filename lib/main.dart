import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/pages/open_source_licenses/index.dart';
import 'package:duel_links_meta/pages/splash/index.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:duel_links_meta/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  final onError = FlutterError.onError;

  FlutterError.onError = (FlutterErrorDetails err) {
    // FlutterError.dumpErrorToConsole(err);
    onError?.call(err);
    // TODO
    log('main catch exception: ${err.exception}', level: 4);
  };

  await MyHive.init();

  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final appStore = Get.put(AppStore());

  runApp(MyApp(appStore: appStore));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appStore, super.key});

  final AppStore appStore;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'Duel Links Meta',
        themeMode: ThemeMode.light,
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.dark(
            primary: appStore.themeColor,
          ),
          navigationBarTheme: NavigationBarTheme.of(context).copyWith(
            iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((Set<MaterialState> states) {
              // 这里可以根据不同的状态返回不同的 IconThemeData
              // 如果没有特别的状态要求，可以返回一个默认的 IconThemeData
              // 例如，在所有状态下使用相同的图标颜色和大小
              return const IconThemeData();
            }),
          ),
          // tabBarTheme: const TabBarTheme(labelColor: BaColors.theme, indicatorColor: BaColors.theme),
          appBarTheme: const AppBarTheme(
            elevation: 2,
            centerTitle: true,
            shadowColor: Colors.black12,
          ),
        ),
        theme: ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.light(
            primary: appStore.themeColor,
          ),
          navigationBarTheme: NavigationBarTheme.of(context).copyWith(
            iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((Set<MaterialState> states) {
              // 这里可以根据不同的状态返回不同的 IconThemeData
              // 如果没有特别的状态要求，可以返回一个默认的 IconThemeData
              // 例如，在所有状态下使用相同的图标颜色和大小
              return IconThemeData(
                color: states.contains(MaterialState.selected) ? Colors.white : Colors.black54, // 设置为白色，以便在黑色背景上清晰可见
                // size: 20, // 设置图标大小
              );
            }),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 2,
            centerTitle: true,
            shadowColor: Colors.black12,
          ),
        ),
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(
          toastBuilder: (msg) => ToastWidget(msg: msg),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
