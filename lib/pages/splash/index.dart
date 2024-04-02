import 'dart:async';
import 'dart:developer';

import 'package:duel_links_meta/pages/main/index.dart';
import 'package:duel_links_meta/util/storage/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var count = 10;

  late Timer timer;

  startCounterDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (count <= 0) {
        timer.cancel();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );

        return;
      }

      setState(() {
        count -= 1;
      });
    });
  }

  initConfig() async {
    var mode = await LocalStorage_DarkMode.get();
    log('[initConfig] mode $mode');

    if (mode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  init() {
    initConfig();
    startCounterDown();
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: BaColors.momo,
        child: Center(
          child: Text("splash page, $count"),
        ),
      ),
    );
  }
}
