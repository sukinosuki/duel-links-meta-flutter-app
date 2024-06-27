import 'dart:async';

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
  var count = 1;

  late Timer timer;

  startCounterDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (count <= 0) {
        timer.cancel();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
          (route) => false, //if you want to disable back feature set to false
          // ModalRoute.withName('/')
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

    if (mode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  init() {
    initConfig();
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
        child: Text("splash page, $count"),
      ),
    );
  }
}
