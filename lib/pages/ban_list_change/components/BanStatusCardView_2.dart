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
  Map<String, List<String>> banStatus2CardsGroup = {};
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

  Future<bool> fetchCards({bool force = false}) async {
    var banStatusCardIdsKey = 'ban_status:card_ids';
    var banStatusCardIdsFetchDateKey = 'ban_status:card_ids';

    var cardIds = MyHive.box.get(banStatusCardIdsKey);

    var refreshFlag = false;

    var list = <BanStatusCard>[];

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
      list = res!.map(BanStatusCard.fromJson).toList();
      MyHive.box.put(banStatusCardIdsKey, list);
    } else {
      log('本地有数据');
      await Future.delayed(Duration(milliseconds: 300));

      try {
        list = (cardIds as List<dynamic>).map((e) => e as BanStatusCard).toList();

        list.forEach((element) {
          var card = MyHive.box.get('card:${element.oid}');
        });
      } catch (e) {
        return true;
      }
    }

    final group = <String, List<String>>{
      'Forbidden': [],
      'Limited 1': [],
      'Limited 2': [],
      'Limited 3': [],
    };

    list.forEach((item) {
      group[item.banStatus]?.add(item.oid);
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
          duration: const Duration(milliseconds: 400),
          child: ListView.builder(
              itemCount: banStatus2CardsGroup.keys.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SvgPicture.asset('assets/images/icon_${banStatus2CardsGroup.keys.elementAt(index).toLowerCase()}.svg',
                                width: 20, height: 20),
                          ),
                          const SizedBox(width: 4),
                          Text(banStatus2CardsGroup.keys.elementAt(index), style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: banStatus2CardsGroup[banStatus2CardsGroup.keys.elementAt(index)]!.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5, childAspectRatio: 0.57, crossAxisSpacing: 6),
                            itemBuilder: (context, _index) {
                              return MdCardItemView2(
                                id: banStatus2CardsGroup[banStatus2CardsGroup.keys.elementAt(index)]![_index],
                                // mdCard: banStatus2CardsGroup[key]![index],
                                // onTap: (card) => handleTapCardItem(banStatus2CardsGroup[key]!, index),
                              );
                            }),
                      ),
                    ),
                  ],
                );
              }),
        ),
        if (_pageStatus == PageStatus.loading) const Positioned.fill(child: Center(child: Loading()))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
