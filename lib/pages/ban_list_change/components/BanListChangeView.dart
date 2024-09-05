import 'dart:developer';

import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/BanListChangeHiveDb.dart';
import 'package:duel_links_meta/hive/db/CardHiveDb.dart';
import 'package:duel_links_meta/http/BanListChangeApi.dart';
import 'package:duel_links_meta/pages/ban_list_change/components/BanListChangeCardView.dart';
import 'package:duel_links_meta/pages/ban_list_change/components/BanListChangePickerView.dart';
import 'package:duel_links_meta/pages/ban_list_change/type/DataGroup.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/ban_list_change/BanListChange.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/util/time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class BanListChangeView extends StatefulWidget {
  const BanListChangeView({super.key});

  @override
  State<BanListChangeView> createState() => _BanListChangeViewState();
}

class _BanListChangeViewState extends State<BanListChangeView> with AutomaticKeepAliveClientMixin {
  var _pageStatus = PageStatus.loading;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<DataGroup<BanListChange>> _banListChangeGroup = [];
  BanListChange? currentBanListChange;
  final formatter = DateFormat('MM-dd');
  bool _isInit = false;

  //
  Future<bool> fetchData({bool force = false}) async {
    var reRefreshFlag = false;

    var list = await BanListChangeHiveDb().get();
    final expireTime = await BanListChangeHiveDb().getExpireTime();

    if (list == null || force) {
      final params = {
        r'rush[$ne]': 'true',
        'sort': '-date,-announced',
        'fields': '-linkedArticle',
      };

      final (err, res) = await BanListChangeApi().list(params: params).toCatch;

      if (err != null || res == null) {
        setState(() {
          _pageStatus = PageStatus.fail;
        });

        return false;
      }

      list = res;
      BanListChangeHiveDb().set(list).ignore();
      BanListChangeHiveDb().setExpireTime(DateTime.now().add(const Duration(days: 1))).ignore();
    } else {
      reRefreshFlag = expireTime == null || expireTime.isBefore(DateTime.now());
    }

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
      _banListChangeGroup = dataGroupList;
      currentBanListChange = dataGroupList[0].items[0];
      _pageStatus = PageStatus.success;
    });

    return reRefreshFlag;
  }

  //
  Future<void> handleTapBanListCard(int index) async {
    final cards = <MdCard>[];

    for (var i = 0; i < currentBanListChange!.changes.length; i++) {
      final item = currentBanListChange!.changes[i];
      var card = await CardHiveDb().get(item.card!.oid);
      card ??= MdCard()
        ..oid = item.card!.oid
        ..name = item.card!.name;

      cards.add(card);
    }

    await showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: cards, index: index),
      ),
    );
  }

  void handlePickerConfirm(int yearIndex, int itemIndex) {
    final banListChange = _banListChangeGroup[yearIndex].items[itemIndex];

    setState(() {
      currentBanListChange = banListChange;
    });

    Navigator.pop(context);
  }

  //
  void showUpdatesDatePicker() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => BanListChangePicker(
        data: _banListChangeGroup,
        onConfirm: handlePickerConfirm,
      ),
    );
  }


  Future<void> _handleRefresh() async {
    final shouldRefresh = await fetchData();
    _isInit = true;
    if (shouldRefresh) {
      await fetchData(force: true);
    }
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: _pageStatus == PageStatus.success ? 1 : 0,
            duration: const Duration(milliseconds: 300),
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
                      ),
                    ],
                  ),
                ),
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

          if (_pageStatus == PageStatus.fail) const Center(
            child: Text('Loading failed'),
          )
        ],
      ),
    );
  }
}
