import 'package:duel_links_meta/components/SkillModalView.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/pages/deck_type_detail/index.dart';
import 'package:duel_links_meta/pages/home/index.dart';
import 'package:duel_links_meta/pages/main/index.dart';
import 'package:duel_links_meta/pages/skill_stats/index.dart';
import 'package:duel_links_meta/pages/splash/index.dart';
import 'package:duel_links_meta/pages/tier_list/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // appBarTheme: AppBarTheme(
        //   iconTheme: IconThemeData(
        //     // splashRadius: 1
        //     opticalSize: 10
        //   )
        // )
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
        '/splash': (context) => const SkillStatsPage(name: 'The Legend of the Heroes'),
        // '/splash': (context) => const SkillStatsPage(name: 'Monster Move'),
        // '/splash': (context) => const SkillModalView(name: 'Photon Dragon Advent'),
        // '/splash': (context) => const CardsViewpagerPage(mdCards: [], index: 0,),
        // '/home': (context) => const HomePage() // TODO: routes声明与不声明有什么区别
      },
    );
  }
}
