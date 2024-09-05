import 'dart:developer';

import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/CardHiveDb.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/pages/splash/BanStatusCardHiveDb.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:get/get.dart';

class BanCardStore extends GetxController {
  RxList<MdCard> cards = <MdCard>[].obs;

  Rx<PageStatus> pageStatus = PageStatus.loading.obs;

  Map<String, MdCard> idToCardMap = {};

  Rx<Map<String, List<MdCard>>> group = Rx<Map<String, List<MdCard>>>({
    'Forbidden': [],
    'Limited 1': [],
    'Limited 2': [],
    'Limited 3': [],
  });

  void setCards(List<MdCard> data) {
    final banStatus2Cards = <String, List<MdCard>>{
      'Forbidden': [],
      'Limited 1': [],
      'Limited 2': [],
      'Limited 3': [],
    };
    data.forEach((item) {
      banStatus2Cards[item.banStatus]?.add(item);

      idToCardMap[item.oid] = item;
    });

    group.value = banStatus2Cards;
    cards.value = data;
  }

  void setPageStatus(PageStatus value) {
    pageStatus.value = value;
  }

  Future<void> setupLocalData() async {
    final cardIds = await BanStatusCardHiveDb.getCardIds();

    if (cardIds == null) {
      fetchData().ignore();
      return;
    }

    final expireDate = await BanStatusCardHiveDb.getExpireTime();

    final list = <MdCard>[];

    final start = DateTime.now();
    for (var i = 0; i < cardIds.length; i++) {
      final card = await CardHiveDb().get(cardIds[i]);

      list.add(
        card ?? MdCard()
          ..oid = cardIds[i],
      );
    }
    log('读取本地数据消耗时间: ${DateTime.now().difference(start).inMilliseconds}');
    setCards(list);

    setPageStatus(PageStatus.success);

    if (expireDate == null || expireDate.isBefore(DateTime.now())) {
      fetchData().ignore();
    }
  }

  Future<void> fetchData({bool force = false}) async {
    final params = <String, String>{
      'limit': '0',
      r'banStatus[$exists]': 'true',
      r'alternateArt[$ne]': 'true',
      r'rush[$ne]': 'true',
      // 'fields': 'oid,banStatus'
    };

    final (err, list) = await CardApi().list(params).toCatch;

    if (err != null || list == null) {
      if (cards.isEmpty) {
        setPageStatus(PageStatus.fail);
      }
      return;
    }

    await BanStatusCardHiveDb.setCardIds(list.map((e) => e.oid).toList());
    await BanStatusCardHiveDb.setExpireTime(DateTime.now().add(const Duration(days: 1)));

    list.forEach(CardHiveDb().set);

    setPageStatus(PageStatus.success);
    setCards(list);
  }
}
