import 'dart:developer';

import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/components/MdCardItemView.dart';
import 'package:duel_links_meta/components/MdCardItemView2.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/ban_list_change/BanStatusCard.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BanStatusCardView extends StatefulWidget {
  const BanStatusCardView({super.key});

  @override
  State<BanStatusCardView> createState() => _BanStatusCardViewState();
}

class _BanStatusCardViewState extends State<BanStatusCardView> with AutomaticKeepAliveClientMixin {
  Map<String, List<MdCard>> banStatus2CardsGroup = {};
  var _pageStatus = PageStatus.loading;

  void handleTapCardItem(List<MdCard> cards, int index) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: cards, index: index),
      ),
    );
  }

  //
  Future<bool> fetchCards({bool force = false}) async {
    var banStatusCardIdsKey = 'ban_status:card_ids';
    var banStatusCardIdsFetchDateKey = 'ban_status:card_ids';

    var cardIds = await MyHive.box2.get(banStatusCardIdsKey) as List<String>?;

    var refreshFlag = false;

    var list = <MdCard>[];

    if (cardIds == null) {
      final params = <String, String>{
        'limit': '0',
        r'banStatus[$exists]': 'true',
        r'alternateArt[$ne]': 'true',
        r'rush[$ne]': 'true',
        // 'fields': 'oid,banStatus'
      };

      final (err, res) = await CardApi().list(params).toCatch;
      if (err != null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });
        return false;
      }
      list = res!.map(MdCard.fromJson).toList();

      // 保存ids
      MyHive.box2.put(banStatusCardIdsKey, list.map((e) => e.oid).toList());
      // 保存card
      list.forEach((element) {
        MyHive.box2.put('card:${element.oid}', element);
      });
    } else {
      log('本地有数据');
      // await Future.delayed(Duration(milliseconds: 300));

      try {
        // list = (cardIds as List).map((e) => (MyHive.box2.get('card:$e') ?? MdCard()..oid = e) as MdCard).toList();
        // list = cardIds.map((e) => (MyHive.box2.get('card:$e') ?? MdCard()..oid = e) as MdCard).toList();

        var start = DateTime.now();
        for (var i=0; i < cardIds.length;i++) {
          final card = await MyHive.box2.get('card:${cardIds[i]}') as MdCard?;

          list.add(card??MdCard()..oid = cardIds[i]);
        }
        log('读取本地数据消耗时间: ${DateTime.now().difference(start).inMilliseconds}');
      } catch (e) {
        MyHive.box2.delete(banStatusCardIdsKey);

        log('转换失败 $e');

        return true;
      }
    }

    final group = <String, List<MdCard>>{
      'Forbidden': [],
      'Limited 1': [],
      'Limited 2': [],
      'Limited 3': [],
    };

    list.forEach((item) {
      group[item.banStatus]?.add(item);
    });

    setState(() {
      banStatus2CardsGroup = group;
      _pageStatus = PageStatus.success;
    });

    return refreshFlag;
  }

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _pageStatus == PageStatus.success ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: banStatus2CardsGroup.keys.map((key) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SvgPicture.asset('assets/images/icon_${key.toLowerCase()}.svg',
                              width: 20, height: 20),
                        ),
                        const SizedBox(width: 4),
                        Text(key, style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  Card(
                    // margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: banStatus2CardsGroup[key]!.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5, childAspectRatio: 0.57, crossAxisSpacing: 6),
                          itemBuilder: (context, _index) {
                            return MdCardItemView2(
                              id: banStatus2CardsGroup[key]![_index].oid,
                              mdCard: banStatus2CardsGroup[key]![_index],
                              onTap: (card) => handleTapCardItem(banStatus2CardsGroup[key]!, _index),
                            );
                          }),
                    ),
                  ),
                ],
              )).toList(),
            ),
          ),
        ),
        if (_pageStatus == PageStatus.loading) const Positioned.fill(child: Center(child: Loading()))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
