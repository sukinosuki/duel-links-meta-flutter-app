import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/pages/open_source_licenses/index.dart';
import 'package:duel_links_meta/pages/splash/index.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Duel Links Meta',
      themeMode: ThemeMode.light,
      // themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: const ColorScheme.dark(
          // seedColor: BaColors.main,
          // onPrimary: Colors.yellow,
          // onSecondary: Colors.tealAccent,
          // background: Colors.yellow,
          primary: Colors.pink, // tab bar indicator / navigation bar indicator
          secondary: Colors.pinkAccent,

          // tertiary: Colors.orange,
          // brightness: Brightness.dark,
          // background: BaColors.main
        ),
        navigationBarTheme: NavigationBarTheme.of(context).copyWith(
          backgroundColor: Colors.black,
          // iconTheme: const MaterialStatePropertyAll(
          //   IconThemeData(
          //     size: 20,
          //   ),
          // ),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((Set<MaterialState> states) {
            // 这里可以根据不同的状态返回不同的 IconThemeData
            // 如果没有特别的状态要求，可以返回一个默认的 IconThemeData
            // 例如，在所有状态下使用相同的图标颜色和大小
            return const IconThemeData(
                // color: Colors.white, // 设置为白色，以便在黑色背景上清晰可见
                // size: 20, // 设置图标大小
                );
          }),
        ),
        primaryColor: Colors.deepOrangeAccent,
        // primarySwatch: Colors.yellow,
        // scaffoldBackgroundColor: BaColors.theme,
        // textTheme: TextTheme(
        // ),
        // useMaterial3: true,

        // tabBarTheme: const TabBarTheme(labelColor: BaColors.theme, indicatorColor: BaColors.theme),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          shadowColor: Color(0xff121212),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          // backgroundColor: BaColors.main
        ),
      ),

      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: const ColorScheme.light(
          // seedColor: Colors.pink,
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          tertiary: Colors.deepOrange,
          inversePrimary: Colors.deepPurple,
          // onSecondary: Colors.green,
          onSurface: Colors.black54,
          // tertiary: Colors.orange,
          // brightness: Brightness.dark,
        ),
        navigationBarTheme: NavigationBarTheme.of(context).copyWith(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
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
        primaryColor: Colors.pink,
        // primaryColorDark: Colors.blue,
        // scaffoldBackgroundColor: Colors.blueAccent,
        // textTheme: TextTheme(
        // ),
        // useMaterial3: true,
        // tabBarTheme: const TabBarTheme(labelColor: BaColors.theme, indicatorColor: BaColors.theme),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          shadowColor: Colors.white24,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(
        toastBuilder: (msg) => ToastWidget(msg: msg),
      ),
      home: const SplashPage(),
      // home: const OpenSourceLicensePage(),
    );
  }
}
