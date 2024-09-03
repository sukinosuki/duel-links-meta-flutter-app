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

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Future<bool> fetchBanCards({bool force = false}) async {
    final banCardStore = Get.put(BanCardStore());
    final cardIds = await BanStatusCardHiveDb.getCardIds();
    final expireDate = await BanStatusCardHiveDb.getExpireTime();
    var refreshFlag = false;

    var list = <MdCard>[];

    if (cardIds == null || force) {
      if (cardIds == null) {
        log('splash 获取本地ban cards为空');
      }

      final params = <String, String>{
        'limit': '0',
        r'banStatus[$exists]': 'true',
        r'alternateArt[$ne]': 'true',
        r'rush[$ne]': 'true',
        // 'fields': 'oid,banStatus'
      };

      final (err, res) = await CardApi().list(params).toCatch;
      if (err != null || res == null) {
        banCardStore.setPageStatus(PageStatus.fail);
        return false;
      }
      list = res;

      // 保存ids
      await BanStatusCardHiveDb.setCardIds(list.map((e) => e.oid).toList());
      await BanStatusCardHiveDb.setExpireTime(DateTime.now().add(const Duration(days: 1)));

      list.forEach(CardHiveDb.setCard);
    } else {
      log('本地有ban cards数据');

      final start = DateTime.now();
      for (var i = 0; i < cardIds.length; i++) {
        final card = await CardHiveDb.get(cardIds[i]);

        list.add(
          card ?? MdCard()
            ..oid = cardIds[i],
        );
      }

      log('读取本地数据消耗时间: ${DateTime.now().difference(start).inMilliseconds}');

      // 过期
      if (expireDate == null || expireDate.isBefore(DateTime.now())) {
        refreshFlag = true;
      }
    }

    log('获取 ban cards 成功');
    banCardStore
      ..setCards(list)
      ..setPageStatus(PageStatus.success);

    return refreshFlag;
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
    final mode = await DarkModeHiveDb.get();

    if (mode != ThemeMode.light) {
      Get.changeThemeMode(mode);
    }
  }

  Future<void> init() async {
    await initDarkMode();

    startCounterDown();

    final shouldFetchBanCards = await fetchBanCards();

    if (shouldFetchBanCards) {
      await fetchBanCards(force: true);
    }
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
