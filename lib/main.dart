import 'package:duel_links_meta/pages/ban_list_change/index.dart';
import 'package:duel_links_meta/pages/main/index.dart';
import 'package:duel_links_meta/pages/splash/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{

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
        primaryColor: Colors.deepOrangeAccent,
        primarySwatch: Colors.yellow,
        // scaffoldBackgroundColor: BaColors.theme,
        // textTheme: TextTheme(
        // ),
        useMaterial3: true,

        // tabBarTheme: const TabBarTheme(labelColor: BaColors.theme, indicatorColor: BaColors.theme),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          shadowColor:  Color(0xff121212),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          // backgroundColor: BaColors.main
        ),
      ),


      theme: ThemeData(
        colorScheme: ColorScheme.light(
          // seedColor: Colors.pink,
          primary: Colors.blue,
          secondary: Colors.black,
          onSecondary: Colors.yellow,
          onSurface: Colors.black87
          // tertiary: Colors.orange,
          // brightness: Brightness.dark,
        ),
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
      // home: const MyHomePage(
      //   title: 'Flutter Demo Home Page',
      // ),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  init() {
    initializeDateFormatting();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duel Links Meta',
      initialRoute: '/splash',
      routes: {
        // '/splash': (context) => const SplashPage(),
        // '/splash': (context) => const DeckTypeDetailPage(),
        // '/splash': (context) => const SkillStatsPage(name: 'The Legend of the Heroes'),
        // '/splash': (context) => const CharactersPage(),
        // '/splash': (context) => const MainPage(),
        '/splash': (context) => const BanListChangePage(),
        // '/splash': (context) => const SkillStatsPage(name: 'Monster Move'),
        // '/splash': (context) => const SkillModalView(name: 'Photon Dragon Advent'),
        // '/splash': (context) => const CardsViewpagerPage(mdCards: [], index: 0,),
        // '/home': (context) => const HomePage() // TODO: routes声明与不声明有什么区别
      },
    );
  }
}
