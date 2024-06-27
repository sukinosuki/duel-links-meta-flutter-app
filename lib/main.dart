import 'dart:developer';

import 'package:duel_links_meta/db/index.dart';
import 'package:duel_links_meta/pages/ban_list_change/index.dart';
import 'package:duel_links_meta/pages/splash/index.dart';
import 'package:duel_links_meta/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'hive/MyHive.dart';

void main() async {
  await MyHive.init();

  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  await Db.init();
  var onError = FlutterError.onError;

  FlutterError.onError = (FlutterErrorDetails err) {
    // FlutterError.dumpErrorToConsole(err);
    onError?.call(err);
    log('捕获异常: ${err.exception}', level: 4);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Duel Links Meta',
      themeMode: ThemeMode.light,
      scrollBehavior: CustomScrollBehavior(),
      // themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          // seedColor: BaColors.main,
          // onPrimary: Colors.yellow,
          // onSecondary: Colors.tealAccent,
          // background: Colors.yellow,
          primary: Colors.pinkAccent,
          secondary: Colors.white,

          // tertiary: Colors.orange,
          // brightness: Brightness.dark,
          // background: BaColors.main
        ),
        navigationBarTheme: NavigationBarTheme.of(context).copyWith(backgroundColor: Colors.white),
        primaryColor: Colors.deepOrangeAccent,
        primarySwatch: Colors.yellow,
        // scaffoldBackgroundColor: BaColors.theme,
        // textTheme: TextTheme(
        // ),
        useMaterial3: true,

        // tabBarTheme: const TabBarTheme(labelColor: BaColors.theme, indicatorColor: BaColors.theme),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          shadowColor: Color(0xff121212),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          // backgroundColor: BaColors.main
        ),
      ),

      theme: ThemeData(
        colorScheme: ColorScheme.light(
          // seedColor: Colors.pink,
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          tertiary: Colors.deepOrange,
          inversePrimary: Colors.deepPurple,
          onSecondary: Colors.green,
          onSurface: Colors.black87,
          // tertiary: Colors.orange,
          // brightness: Brightness.dark,
        ),
        navigationBarTheme: NavigationBarTheme.of(context).copyWith(backgroundColor: Colors.white),

        primaryColor: Colors.deepOrangeAccent,
        // primaryColorDark: Colors.blue,
        // scaffoldBackgroundColor: Colors.blueAccent,
        // textTheme: TextTheme(
        // ),
        useMaterial3: true,

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
      // initialRoute: '/splash',
      // routes: {
      //   // '/splash': (context) => const SplashPage(),
      //   // '/splash': (context) => const DeckTypeDetailPage(),
      //   // '/splash': (context) => const SkillStatsPage(name: 'The Legend of the Heroes'),
      //   // '/splash': (context) => const CharactersPage(),
      //   // '/splash': (context) => const MainPage(),
      //   '/splash': (context) => const BanListChangePage(),
      //   // '/splash': (context) => const SkillStatsPage(name: 'Monster Move'),
      //   // '/splash': (context) => const SkillModalView(name: 'Photon Dragon Advent'),
      //   // '/splash': (context) => const CardsViewpagerPage(mdCards: [], index: 0,),
      //   // '/home': (context) => const HomePage() // TODO: routes声明与不声明有什么区别
      // },
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {}
