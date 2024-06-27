import 'dart:developer';

import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/http/BanListChangeApi.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/pages/ban_list_change/components/BanListChangeCardView.dart';
import 'package:duel_links_meta/pages/ban_list_change/components/BanListChangePickerView.dart';
import 'package:duel_links_meta/pages/ban_list_change/type/DataGroup.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/ban_list_change/BanListChange.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/util/time_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BanListChangeView extends StatefulWidget {
  const BanListChangeView({super.key});

  @override
  State<BanListChangeView> createState() => _BanListChangeViewState();
}

class _BanListChangeViewState extends State<BanListChangeView> with AutomaticKeepAliveClientMixin {
  var _pageStatus = PageStatus.loading;

  List<DataGroup<BanListChange>> banListChangeGroup = [];

  BanListChange? currentBanListChange;

  //
  Future<void> fetchBanListChanges() async {
    final params = {
      r'rush[$ne]': 'true',
      'sort': '-date,-announced',
    };

    final (err, res) = await BanListChangeApi().list(params: params).toCatch;

    if (err != null) {
      setState(() {
        _pageStatus = PageStatus.fail;
      });
      return;
    }

    final list = res!.map(BanListChange.fromJson).toList();
    final cardIds = list.map((e) => e.changes.map((e) => e.card!.oid).toList()).expand((element) => element).toSet().toList();

    final formatter = DateFormat('MM-dd');

    final dataGroupList = <DataGroup<BanListChange>>[];

    list.forEach((item) {
      final year = item.date?.year ?? item.announced?.year;
      item.formattedMonthDay = formatter.format((item.date ?? item.announced)!);

      final index = dataGroupList.indexWhere((element) => element.name == year.toString());

      if (index != -1) {
        dataGroupList[index].items.add(item);
      } else {
        dataGroupList.add(DataGroup(name: year.toString(), items: [item]));
      }
    });

    dataGroupList.forEach((element) {
      element.items.sort((a, b) => b.formattedMonthDay.compareTo(a.formattedMonthDay));
    });

    setState(() {
      banListChangeGroup = dataGroupList;
      currentBanListChange = dataGroupList[0].items[0];
      _pageStatus = PageStatus.success;
    });

    fetchCards(cardIds);
  }

  Future<void> fetchCards(List<String> cardIds) async {
    final cards = <MdCard>[];

    var size = 0;
    while (size < cardIds.length) {
      final ids = cardIds.sublist(size, size + 100 > cardIds.length ? cardIds.length : size + 100);
      size += 100;

      final (cardsErr, cardsRes) = await CardApi().getById(ids.join(',')).toCatch;
      if (cardsErr != null) {
        return;
      }
      cards.addAll(cardsRes!.map(MdCard.fromJson).toList());

      log('cards: ${cards.length}');
    }

    final cardId2CardMap = <String, MdCard>{};

    cards.forEach((card) {
      cardId2CardMap[card.oid] = card;
    });
    log('cardId2CardMap: ${cardId2CardMap.length}');

    banListChangeGroup.forEach((group) {
      group.items.forEach((item) {
        item.changes.forEach((change) {
          if (cardId2CardMap[change.card?.oid] != null) {
            change.card2 = cardId2CardMap[change.card?.oid]!;
          }
        });
      });
    });
  }

  void handleTapBanListCard(int index) {
    final cards = currentBanListChange!.changes.map((e) => e.card2).toList();

    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: cards, index: index),
      ),
    );
  }

  void handlePickerConfirm(int yearIndex, int itemIndex) {
    final banListChange = banListChangeGroup[yearIndex].items[itemIndex];

    setState(() {
      currentBanListChange = banListChange;
    });

    Navigator.pop(context);
  }

  void showUpdatesDatePicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black12,
      builder: (context) => BanListChangePicker(data: banListChangeGroup, onConfirm: handlePickerConfirm),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchBanListChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _pageStatus == PageStatus.success ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Updates'),
                      GestureDetector(
                        onTap: showUpdatesDatePicker,
                        child: Row(
                          children: [
                            Text(TimeUtil.format(currentBanListChange?.date ?? currentBanListChange?.announced)),
                            const Icon(Icons.keyboard_arrow_down, size: 16),
                          ],
                        ),
                      )
                    ],
                  )),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: currentBanListChange?.changes.length ?? 0,
                  itemBuilder: (context, index) {
                    return BanListChangeCardView(
                      change: currentBanListChange!.changes[index],
                      onTap: () => handleTapBanListCard(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (_pageStatus == PageStatus.loading)
          const Positioned.fill(
            child: Center(
              child: Loading(),
            ),
          )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
