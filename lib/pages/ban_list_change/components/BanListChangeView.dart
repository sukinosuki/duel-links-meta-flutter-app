import 'dart:developer';

import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/http/CardApi.dart';
import 'package:duel_links_meta/pages/ban_list_change/components/BanListChangeCardView.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/util/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:intl/intl.dart';

import '../../../http/BanListChangeApi.dart';
import '../../../type/ban_list_change/BanListChange.dart';
import '../../../util/time_util.dart';
import '../../cards_viewpager/index.dart';
import '../type/DataGroup.dart';
import 'BanListChangePickerView.dart';

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
  fetchBanListChanges() async {
    var params = {
      'rush[\$ne]': 'true',
      'sort': '-date,-announced',
    };

    var (err, res) = await BanListChangeApi().list(params: params).toCatch;

    if (err != null) {
      setState(() {
        _pageStatus = PageStatus.fail;
      });
      return;
    }

    var list = res!.map((e) => BanListChange.fromJson(e)).toList();
    var cardIds = list.map((e) => e.changes.map((e) => e.card!.oid).toList()).expand((element) => element).toSet().toList();

    var formatter = DateFormat('MM-dd');

    List<DataGroup<BanListChange>> dataGroupList = [];

    list.forEach((item) {
      var year = item.date?.year ?? item.announced?.year;
      item.formattedMonthDay = formatter.format((item.date ?? item.announced)!);

      var index = dataGroupList.indexWhere((element) => element.name == year.toString());

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

  fetchCards(List<String> cardIds) async {
    List<MdCard> cards = [];

    var size = 0;
    while (size < cardIds.length) {
      var ids = cardIds.sublist(size, size + 100 > cardIds.length ? cardIds.length : size + 100);
      size += 100;

      var (cardsErr, cardsRes) = await CardApi().getById(ids.join(',')).toCatch;
      if (cardsErr != null) {
        return;
      }
      cards.addAll(cardsRes!.map((e) => MdCard.fromJson(e)).toList());

      log('cards: ${cards.length}');
    }

    Map<String, MdCard> cardId2CardMap = {};

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

  handleTapBanListCard(int index) {
    List<MdCard> cards = currentBanListChange!.changes.map((e) => e.card2).toList();

    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: cards, index: index),
      ),
    );
  }

  handlePickerConfirm(int yearIndex, int itemIndex) {
    var banListChange = banListChangeGroup[yearIndex].items[itemIndex];

    setState(() {
      currentBanListChange = banListChange;
    });

    Navigator.pop(context);
  }

  showUpdatesDatePicker() {
    showModalBottomSheet(
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
