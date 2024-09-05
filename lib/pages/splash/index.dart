import 'dart:async';
import 'dart:developer';

import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/CardHiveDb.dart';
import 'package:duel_links_meta/hive/db/DarkModeHiveDb.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/pages/main/index.dart';
import 'package:duel_links_meta/pages/splash/BanStatusCardHiveDb.dart';
import 'package:duel_links_meta/store/BanCardStore.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
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
  final banCardStore = Get.put(BanCardStore());

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();
  }

  //
  void startCounterDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_count <= 0) {
        timer.cancel();

        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(builder: (context) => const MainPage()),
          (route) => false, //if you want to disable back feature set to false
        );

        return;
      }

      setState(() {
        _count -= 1;
      });
    });
  }

  Future<void> initDarkMode() async {
    final mode = await DarkModeHiveDb().get();

    if (mode != ThemeMode.light) {
      Get.changeThemeMode(mode);
    }
  }

  Future<void> init() async {
    await initDarkMode();

    startCounterDown();

    banCardStore.setupLocalData().ignore();
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
