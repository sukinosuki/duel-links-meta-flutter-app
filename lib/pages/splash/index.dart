import 'dart:async';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/pages/main/index.dart';
import 'package:duel_links_meta/pages/top_decks/index.dart';
import 'package:duel_links_meta/util/storage/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _count = 1;

  late Timer _timer;

  void startCounterDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_count <= 0) {
        timer.cancel();

        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const MainPage(),
            // builder: (context) => const TopDecksPage(isRush: false,),
          ),
          (route) => false, //if you want to disable back feature set to false
          // ModalRoute.withName('/')
        );

        return;
      }

      setState(() {
        _count -= 1;
      });
    });
  }

  Future<void> initDarkMode() async {
    // final mode = await LocalStorage_DarkMode.get();
    final mode = await MyHive.box2.get('dark_mode');

    if (mode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  void init() {
    initDarkMode();
    startCounterDown();
    //
    // Db.init();
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('splash page, $_count'),
      ),
    );
  }
}
